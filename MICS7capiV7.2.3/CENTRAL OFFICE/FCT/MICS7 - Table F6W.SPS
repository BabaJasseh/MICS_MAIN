* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

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

compute layer = 1.
compute tot1 = 100.
compute total = 1.
compute wmyb = 0.
compute wyab   = 0.
compute wyb   = 0.
compute wab   = 0.
compute wnd   = 0.

if (WB3M < 98 and WB3Y < 9998) wmyb = 100.  
if (WB3M >= 98 and WB3Y < 9998 and WB4 <98) wyab = 100.  
if (WB3M >= 98 and WB3Y >= 9998 and WB4 < 98) wab = 100.  
if (WB3M >= 98 and WB3Y < 9998 and WB4>=98) wyb = 100.
if (wmyb=0 and wyab=0 and wyb=0 and wab=0) wnd=100.

save outfile = "tmp.sav".

aggregate 
  /outfile = "tmp1.sav"
  /break = team
  /teamt = mean (wmyb).

aggregate 
  /outfile = "tmp2.sav"
  /break = total
  /teamt = mean (wmyb).

* Add this summary information .
get file = 'tmp.sav'.
add files
  /file = *
  /file = 'tmp1.sav'
  /file = 'tmp2.sav'.

do if (teamt < 99).
+ compute target = teamt.
end if.

* to calculate correct number of women exclude temporarily generated cases needed for calculation of target reached.
do if (sysmis (teamt)).
+ compute wn = 1.
end if.

value labels tot1 1 " ".
variable labels tot1 "Total".
variable labels total "Total".
value labels total 1 " " .
variable labels target "Target not met".
variable labels wn " ".
value labels wn 1 "Number of women" .
variable labels wmyb "Year and month of birth".
variable labels wyab "Year of birth and age".
variable labels wyb "Year of birth only".
variable labels wab "Age only".
variable labels wnd "Other/No data".
value labels layer 1 " Completeness of reporting".

ctables
  /vlabels variables = layer wn
         display = none
   /table total [c] + team [c] by 
    layer [c] > (wmyb [s] [mean '' f5.1] + wyab [s] [mean '' f5.1] + wyb [s] [mean '' f5.1] +
    wab [s] [mean '' f5.1] + wnd [s] [mean '' f5.1]) + tot1 [s] [mean '' f5.1] + wn [c] [count '' f5.0]  + target [s] [mean '' f5.1]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title = 
   "F6W. Birth date reporting: Women "
   "Percent distribution of women age 15-49 years by completeness of date of birth/age reporting information, according to interviewer team, " + surveyname
      caption="Target >=99".

new file.		

erase file = "tmphh.sav".
erase file = "tmp.sav".		
erase file = "tmp1.sav".	
erase file = "tmp2.sav".		
