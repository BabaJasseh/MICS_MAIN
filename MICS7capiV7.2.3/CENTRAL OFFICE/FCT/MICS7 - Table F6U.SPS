* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = "hh.sav".

sort cases by hh1 hh2.

include "targets.sps".
 
save outfile = "tmphh.sav" /keep hh1 hh2 team /rename hh1 = uf1 hh2 = uf2.

* Open the under 5 data file.
get file = 'ch.sav'.

select if (UF17 = 1).

sort cases by uf1 uf2.

match files / file = *
 /table = 'tmphh.sav'
 /by uf1 uf2.

compute layer = 1.
compute tot1 = 100.
compute total = 1.
compute chmyb = 0.
compute chyab   = 0.
compute chab   = 0.
compute chyb   = 0.
compute mchd   = 0.

if (UB1M < 98 and UB1Y < 9998) chmyb = 100.  
if (UB1M >= 98 and UB1Y < 9998 and UB2 < 98) chyab = 100.  
if (UB1M >= 98 and UB1Y >= 9998 and UB2 < 98 ) chab = 100.  
if (UB1M >= 98 and UB1Y < 9998 and UB2 >= 98 ) chyb = 100.  
if (chmyb = 0 and chyab = 0 and chyb = 0 and  chab = 0) chnd = 100.

save outfile = "tmp.sav".

aggregate 
  /outfile = "tmp1.sav"
  /break = team
  /teamt = mean (chmyb).

aggregate 
  /outfile = "tmp2.sav"
  /break = total
  /teamt = mean (chmyb).

* Add this summary information .
get file = 'tmp.sav'.
add files
  /file = *
  /file = 'tmp1.sav'
  /file = 'tmp2.sav'.

do if (teamt < 99).
+ compute target = teamt.
end if.

* to calculate correct number of children under 5 exclude temporarily generated cases needed for calculation of target reached.
do if (sysmis (teamt)).
+ compute cn = 1.
end if.

value labels tot1 1 " ".
variable labels tot1 "Total".
variable labels total "Total".
value labels total 1 " " .
variable labels target "Target not met".
variable labels cn " ".
value labels cn 1 "Number of children under 5" .
variable labels chmyb "Year and month of birth".
variable labels chyab "Year of birth and age".
variable labels chyb "Year of birth only".
variable labels chab "Age only".
variable labels mchd "Other/No data".
value labels layer 1 " Completeness of reporting".

ctables
  /vlabels variables = layer cn
         display = none
   /table total [c] + team [c] by 
    layer [c] > (chmyb [s] [mean '' f5.1] + chyab [s] [mean '' f5.1] + chyb [s] [mean '' f5.1]  +
    chab [s] [mean '' f5.1] + mchd [s] [mean '' f5.1]) + tot1 [s] [mean '' f5.1] + cn [c] [count '' f5.0]  + target [s] [mean '' f5.1]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title = 
   "F6U. Birth date reporting: Children under-5"
   "Percent distribution of children age under 5 years by completeness of date of birth/age reporting information, according to interviewer team, " + surveyname.

new file.		

erase file = "tmphh.sav".
erase file = "tmp.sav".	
erase file = "tmp1.sav".	
erase file = "tmp2.sav".		
