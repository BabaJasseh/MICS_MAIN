* Encoding: windows-1252.
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

select if bh4y >= 1387. /* 2008.

compute tot1 = 1.
value labels tot1 1 " " .
variable labels tot1 "Total" .

compute total = 1.
variable labels total "Total" .

ctables
 /table tot1 [c] + team [c]  by 
    bh4y [c] [count '' f7.0] + total [s] [count '' f7.0]
 /categories variables=all empty=exclude missing=exclude
 /slabels position=column visible = no
 /titles title = 
   "F11A. Birth histories: Birth displacement"
   "Number of births since [1387 (2008)] by year of birth in birth histories, according to interviewer team, " + surveyname.
new file.		

erase file = "tmphh.sav".		
