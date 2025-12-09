* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = "hh.sav".

sort cases by hh1 hh2.

include "targets.sps".
 
save outfile = "tmphh.sav" /keep hh1 hh2 team /rename hh1 = wm1 hh2 = wm2.

* Open the birth history data file.
get file = 'bh.sav'.

sort cases by wm1 wm2.

match files / file = *
 /table = 'tmphh.sav'
 /by wm1 wm2.

* select deceased children.
select if (BH5 = 2).

compute layer = 1.
compute tot1 = 100.
compute total = 1.
compute cmyb = 0.
compute cyb   = 0.
compute cmb   = 0.
compute cnd   = 0.

if (BH4M < 98 and BH4Y < 9998) cmyb = 100.  
if (BH4M >= 98 and BH4Y<9998) cyb = 100.  
if (BH4M < 98 and BH4Y >= 9998 and BH6 >= 98 ) cmb = 100.  
if (cmyb=0 and cyb = 0 and cmb=0) cnd=100.	

save outfile = "tmp.sav".

aggregate 
  /outfile = "tmp1.sav"
  /break = team
  /teamt = mean (cmyb).

aggregate 
  /outfile = "tmp2.sav"
  /break = total
  /teamt = mean (cmyb).

* Add this summary information .
get file = 'tmp.sav'.
add files
  /file = *
  /file = 'tmp1.sav'
  /file = 'tmp2.sav'.

do if (teamt < 99).
+ compute target = teamt.
end if.

* to calculate correct number of deceased children exclude temporarily generated cases needed for calculation of target reached.
do if (sysmis (teamt)).
+ compute cn = 1.
end if.

value labels tot1 1 " ".
variable labels tot1 "Total".
variable labels total "Total".
value labels total 1 " " .
variable labels target "Target not met".
variable labels cn " ".
value labels cn 1 "Number of deceased children" .
variable labels cmyb "Year and month of birth".
variable labels cyb "Year of birth only".
variable labels cmb "Month of birth only".
variable labels cnd "Other/No data".
value labels layer 1 " Completeness of reporting".

ctables
  /vlabels variables = layer cn display = none
   /table total [c] + team [c] by 
    layer [c] > (cmyb [s] [mean '' f5.1] + cyb [s] [mean '' f5.1] + cmb [s] [mean '' f5.1] + cnd [s] [mean '' f5.1]) + tot1 [s] [mean '' f5.1] + cn [c] [count '' f5.0]  + target [s] [mean '' f5.1]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title = 
   "F11C. Birth histories: Birth date reporting for deceased children"
   "Percent distribution of deceased children by completeness of date of birth information in birth histories, according to interviewer team," + surveyname
  caption="Target >=99".

new file.		

erase file = "tmphh.sav".	
erase file = "tmp.sav".		
erase file = "tmp1.sav".	
erase file = "tmp2.sav".		
