* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = "hh.sav".

sort cases by hh1 hh2.

include "targets.sps".
 
save outfile = "tmphh.sav" /keep hh1 hh2 team /rename hh1 = wm1 hh2 = wm2.

* add year of interview of a women.
get file = "wm.sav"
  /keep wm1 wm2 wm3 wm6y.
sort cases by wm1 wm2 wm3.
save outfile = "tmp2.sav".

* Open the birth history data file.
get file = 'bh.sav'.

sort cases by wm1 wm2 wm3.

match files / file = *
 /table = 'tmphh.sav'
 /by wm1 wm2.

match files / file = *
 /table = 'tmp2.sav'
 /by wm1 wm2 wm3.

save outfile = "tmp.sav".

get file = 'tmp.sav'.

sort cases by wm1 wm2 wm3.

* deaths in the last 15 years.
select if (BH5 = 2 and (BH4Y>=9997 or BH4Y>= WM6Y - 15)).

* compute age at death in months.
compute ageatdth = 0.
if (BH9U = 1) ageatdth = trunc(BH9N*12/365).
if (BH9U = 2) ageatdth = BH9N.
if (BH9U = 3) ageatdth = BH9N*12.
if (BH9U = 9 or BH9N = 99) ageatdth = 99.

recode ageatdth (8 = 1) (9 = 2) (10 = 3) (11 = 4) (12 = 5) (13 = 7) (14 = 8) (15 = 9) (16 = 10) (else = 0) into aged.

* separatly for 1 year.
if (BH9U = 3 and BH9N = 1) aged = 6.

variable labels  aged 'Age at death (in months)'.
value labels aged
  1 '8m'
  2 '9m'
  3 '10m'
  4 '11m'
  5 '12m'
  6 '1y'
  7 '13m'
  8 '14m'
  9 '15m'
  10 '16m'.

* select only 8 - 19 months. 
select if (aged > 0).

compute layer12 = 1.
variable labels layer12 " ".
value labels layer12 1 "12 months".

compute layer = 1.
variable labels layer " ".
value labels layer 1 "Age at death (in months)".

compute total = 1.
variable labels total  " ".
value labels total 1 "Total 8-16 months (including <1 year>)".

do if (aged = 5 or aged = 6).
+ compute total12 = 1.
end if.
variable labels total12  " ".
value labels total12 1 "Total 12 months".

compute ttot = 1.
value labels ttot 1 " ".
variable labels ttot "Total".

save outfile = "tmp.sav".

aggregate 
  /outfile = 'tmp3.sav'
  /break = team
  /tot12 = sum (total12)
  /tot = sum (total).

aggregate 
  /outfile = 'tmp4.sav'
  /break = ttot
  /tot12 = sum (total12)
  /tot = sum (total).

* Add this summary information .
get file = 'tmp.sav'.

add files
  /file = *
  /file = 'tmp3.sav'
  /file = 'tmp4.sav'.

save outfile = "tmp.sav".

do if (not(sysmis (tot))).
+ compute ratio12 = tot12*9/tot.
end if.
variable labels ratio12 "12 months ratio (including 1 year)".

* Target should be set to 1.5.
do if (ratio12 > 1.5).
+ compute target = ratio12.
end if.

* to calculate correct number of deceased children exclude temporarily generated cases needed for calculation of target reached.
do if (sysmis (tot)).
+ compute cn = 1.
end if.

variable labels target "Target not met".
variable labels cn " ".
value labels cn 1 "Total 8-16 months (including 1 year)" .

save outfile = "tmp.sav".

ctables
  /vlabels variables = layer layer12 cn aged display = none
   /table ttot [c] + team [c] by 
    layer [c] > aged [c] [count '' f5.0] + cn [c] [count '' f5.0]  + ratio12 [s] [mean '' f5.2] + target [s] [mean '' f5.1]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title = 
   "F11D. Birth histories: Age at death heaping"
   "Number of deaths in the last 15 years by reported months of age at death (including age at death reported as one year) "+
   "and the 12 months ratios, according to interviewer team, " + surveyname
     caption="Target >=1.5".												

new file.		

erase file = "tmp.sav".		
erase file = "tmphh.sav".	
erase file = "tmp2.sav".		
erase file = "tmp3.sav".	
erase file = "tmp4.sav".		
