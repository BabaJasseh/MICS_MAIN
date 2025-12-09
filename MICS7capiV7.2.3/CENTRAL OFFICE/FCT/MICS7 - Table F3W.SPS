* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = "hh.sav".

sort cases by hh1 hh2.

include "targets.sps".

save outfile = "tmp.sav"  /keep hh1 hh2 team /rename hh1 = wm1 hh2 = wm2.

get file = "hl.sav"
 /keep hh1 hh2 hl1 hl6
 /rename hh1 = wm1 hh2 = wm2 hl1 = wm3.
sort cases by wm1 wm2 wm3.
save outfile = "tmphl.sav".

* Open women data file.
get file = "wm.sav".

sort cases by wm1 wm2 wm3.

match files /file=*
  /table='tmp.sav'
  /by wm1 wm2.

match files /file=*
  /table='tmphl.sav'
  /by wm1 wm2 wm3.

recode WM17 (1 = 100) (else = 0) into complete.

compute nh = 1.
variable labels nh "".
value labels nh 1 "Number of women".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

do if (hl6 >= 15 and hl6 <= 17).
+ compute wom1517 = 1.
+ compute consent=0.
+ if (WM17 = 6)  consent = 100.
end if.

variable labels consent "Percentage with no adult consent".
variable labels wom1517 "".
value labels wom1517 1 "Number of women age 15-17 years".

compute layer = 1.
variable labels layer " ".
value labels layer 1 "Result of individual interview (Women's Questionnaire)".

* Ctables command in English (currently active, comment it out if using different language).
ctables
 /vlabels variables=total nh wom1517 layer wm17 display=none
 /table  total [c] + team [c] by
          layer [c] > (wm17 [c][rowpct.validn f5.1]) + nh [c] +consent [s] [mean '' f5.1] + wom1517 [c]
 /slabels visible = no
 /categories variables = wm17 total = yes
 /categories variables=all empty=exclude missing=exclude
 /title title=  "F3W. Response Rate: Eligible women" 							
                  "Percent distribution of eligible women age 15-49 years by result of individual interview, according to interviewer team, " + surveyname.					

new file.

erase file  = "tmp.sav".
erase file  = "tmphl.sav".
