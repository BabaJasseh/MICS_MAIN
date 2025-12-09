* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = "hh.sav".

sort cases by hh1 hh2.

include "targets.sps".
 
save outfile = "tmphh.sav" /keep hh1 hh2 team /rename hh1 = mwm1 hh2 = mwm2.

* Open the men data file.
get file = 'mn.sav'.

select if (MWM17 = 1).

sort cases by mwm1 mwm2.

match files / file = *
 /table = 'tmphh.sav'
 /by mwm1 mwm2.

compute layer = 1.
compute tot1 = 100.
compute total = 1.
compute mmyb = 0.
compute myab   = 0.
compute myb   = 0.
compute mab   = 0.
compute mnd   = 0.

if (MWB3M < 98 and MWB3Y < 9998) mmyb = 100.  
if (MWB3M >= 98 and MWB3Y < 9998 and MWB4 < 98) myab = 100.  
if (MWB3M >= 98 and MWB3Y >= 9998 and MWB4 < 98) mab = 100.  
if (MWB3M >= 98 and MWB3Y < 9998 and MWB4 >= 98) myb = 100.  
if (mmyb = 0 and myab = 0 and myb = 0 and mab = 0) mmd=100.

save outfile = "tmp.sav".

aggregate 
  /outfile = "tmp1.sav"
  /break = team
  /teamt = mean (mmyb).

aggregate 
  /outfile = "tmp2.sav"
  /break = total
  /teamt = mean (mmyb).

* Add this summary information .
get file = 'tmp.sav'..
add files
  /file = *
  /file = 'tmp1.sav'
  /file = 'tmp2.sav'.

do if (teamt < 99).
+ compute target = teamt.
end if.

* to calculate correct number of men exclude temporarily generated cases needed for calculation of target reached.
do if (sysmis (teamt)).
+ compute mn = 1.
end if.

value labels tot1 1 " ".
variable labels tot1 "Total".
variable labels total "Total".
value labels total 1 " " .
variable labels target "Target not met".
variable labels mn " ".
value labels mn 1 "Number of men with completed interview" .
variable labels mmyb "Year and month of birth".
variable labels myab "Year of birth and age".
variable labels myb "Year of birth only".
variable labels mab "Age only".
variable labels mnd "Other/No data".
value labels layer 1 " Completeness of reporting".

ctables
  /vlabels variables = layer mn
         display = none
   /table total [c] + team [c] by 
    layer [c] > (mmyb [s] [mean '' f5.1] + myab [s] [mean '' f5.1] + myb [s] [mean '' f5.1] +
    mab [s] [mean '' f5.1] + mnd [s] [mean '' f5.1]) + tot1 [s] [mean '' f5.1] + mn [c] [count '' f5.0]  + target [s] [mean '' f5.1]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title = 
   "F6M. Birth date reporting: Men "
   "Percent distribution of men age 15-49 years by completeness of date of birth/age reporting information, according to interviewer team, " + surveyname.

new file.		

erase file = "tmphh.sav".
erase file = "tmp.sav".	
erase file = "tmp1.sav".	
erase file = "tmp2.sav".		
