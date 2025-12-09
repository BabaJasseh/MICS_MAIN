* Encoding: UTF-8.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open the bh file.
get file = 'bh.sav'.

aggregate
  /outfile='tmpbh.sav'
  /break=HH1 HH2 LN
  /BH4D_first=first(BH4D) 
  /BH4M_first=first(BH4M) 
  /BH4Y_first=first(BH4Y)
  /BH6_first=first(BH6)
  /BH3_last=last(BH3) 
  /BH4D_last=last(BH4D) 
  /BH4M_last=last(BH4M) 
  /BH4Y_last=last(BH4Y)
  /BH6_last=last(BH6).

* Open the women data file.
get file = 'wm.sav'.

* Delete variables if previously created.
delete variables BH4D_first BH4M_first BH4Y_first BH6_first BH3_last BH4D_last BH4M_last BH4Y_last BH6_last.

* Sort the cases by cluster number, household number and line number.
sort cases by HH1 HH2 LN.

* Merge the women's date's of first and last birth file.
match files
  /file = *
  /table = 'tmpbh.sav'
  /by HH1 HH2 LN.

variable labels BH3_last 'Sex of newborn'.
value labels BH3_last 1 'Male' 2 'Female'.

* Save the women file.
save outfile = 'wm.sav'.

get file = "hh.sav".

sort cases by hh1 hh2.

include "targets.sps".
 
save outfile = "tmphh.sav" /keep hh1 hh2 team /rename hh1 = wm1 hh2 = wm2.

* Open the women data file.
get file = 'wm.sav'.

select if (WM17 = 1).

sort cases by wm1 wm2.

match files / file = *
 /table = 'tmphh.sav'
 /by wm1 wm2.

select if (CM1 = 1 or (CM1 = 2 and CM8 = 1)).

compute layer = 1.
compute layer1 = 1.
compute layer2 = 1.
compute tot1 = 100.
compute total = 1.

* separatly for first birth.
compute fbmyb = 0.
compute fbyb   = 0.
compute fbab   = 0.
compute fbnd   = 0.

if (BH4M_first < 97 and BH4Y_first < 9997) fbmyb = 100.  
if (BH4M_first >= 97 and BH4Y_first< 9997) fbyb = 100.  
if (BH4M_first >= 97 and BH4Y_first >= 9997 and BH6_first < 97) fbab = 100.  
if (fbmyb=0 and fbyb=0 and fbab=0) fbnd=100.

*..and last birth.

do if (CM11 > 1).

+ compute lbmyb = 0.
+ compute lbyb   = 0.
+ compute lbnd   = 0.

+ if (BH4M_last < 97 and BH4Y_last < 9997) lbmyb = 100.  
+ if (BH4M_last >= 97 and BH4Y_last < 9997) lbyb = 100.  
+ if (lbmyb = 0 and lbyb = 0) lbnd=100.

end if. 

save outfile = "tmp.sav".

aggregate 
  /outfile = "tmp1.sav"
  /break = team
  /teamtfirst = mean (fbmyb)
  /teamtlast = mean (lbmyb).

aggregate 
  /outfile = "tmp2.sav"
  /break = total
  /teamtfirst = mean (fbmyb)
  /teamtlast = mean (lbmyb).

* Add this summary information .
get file = 'tmp.sav'.
add files
  /file = *
  /file = 'tmp1.sav'
  /file = 'tmp2.sav'.

do if (teamtfirst < 99).
+ compute targetfirst = teamtfirst.
end if.

do if (teamtlast < 99).
+ compute targetlast = teamtlast.
end if.

* to calculate correct number of women exclude temporarily generated cases needed for calculation of target reached.
do if (sysmis (teamtfirst)).
+ compute bnfirst = 1.
end if.

do if (sysmis (teamtlast) and CM11 > 1).
+ compute bnlast = 1.
end if.


value labels tot1 1 " ".
variable labels tot1 "Total".
variable labels total "Total".
value labels total 1 " " .
variable labels targetfirst "Target not met".
variable labels targetlast "Target not met".
value labels bnfirst 1 "Number of first births" .
variable labels fbmyb "Year and month of birth".
variable labels fbyb "Year of birth only".
variable labels fbab "Completed years since first birth only".
variable labels fbnd "Other/DK/Missing".
value labels layer1 1 " Date of first birth".
value labels bnlast 1 "Number of last births" .
variable labels lbmyb "Year and month of birth".
variable labels lbyb "Year of birth only".
variable labels lbnd "Other/DK/Missing".
value labels layer2 1 "Date of last birth".
value labels layer 1 "Completeness of reporting of date of birth".

ctables
  /vlabels variables = layer layer1 layer2 bnfirst bnlast display = none
   /table total [c] + team [c] by 
    layer [c] >
   (layer1 [c] > (fbmyb [s] [mean '' f5.1] +fbyb [s] [mean '' f5.1] + fbab [s] [mean '' f5.1] + fbnd [s] [mean '' f5.1]) + tot1 [s] [mean '' f5.1] + bnfirst [c] [count '' f5.0] + targetfirst [s] [mean '' f5.1] +
    layer2 [c] > (lbmyb [s] [mean '' f5.1] +lbyb [s] [mean '' f5.1] + lbnd [s] [mean '' f5.1]) + tot1 [s] [mean '' f5.1] + bnlast [c] [count '' f5.0] + targetlast [s] [mean '' f5.1])
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title = 
   "Table F6B: Birth date reporting: First and last births"
   "Percent distribution of first and last births to women age 15-49 years by completeness of date of birth, according to interviewe team" + surveyname
  Caption="Target >=99".
								
new file.

erase file = "tmpbh.sav".
erase file = "tmphh.sav".
erase file = "tmp.sav".
erase file = "tmp1.sav".
erase file = "tmp2.sav".
