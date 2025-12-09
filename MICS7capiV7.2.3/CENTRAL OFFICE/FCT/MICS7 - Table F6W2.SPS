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

compute tot1 = 100.
compute total = 1.
compute wn = 1.

value labels tot1 1 " ".
variable labels tot1 "Total".
variable labels total "Total".
value labels total 1 " " .
variable labels wn " ".
value labels wn 1 "Number of women" .

variable labels WB3M "Month of birth".

ctables
  /vlabels variables = wn
         display = none
   /table total [c] + team [c] by WB3M [c] [rowpct.validn '' f5.1] + tot1 [s] [mean '' f5.1] + wn [c] [count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title = 
   "F6W2. Birth date reporting: Women "
   "Percent distribution of women age 15-49 years by month of birth information, according to interviewer team, " + surveyname.

new file.

erase file "tmphh.sav".


