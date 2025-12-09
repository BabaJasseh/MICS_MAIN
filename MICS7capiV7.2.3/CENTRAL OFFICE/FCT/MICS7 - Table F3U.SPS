* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = "hh.sav".

sort cases by hh1 hh2.

include "targets.sps".
 
save outfile = "tmp.sav"  /keep hh1 hh2 team /rename hh1 = uf1 hh2 = uf2.

get file = "hl.sav"
 /keep hh1 hh2 hl1 hl6
 /rename hh1 = uf1 hh2 = uf2 hl1 = uf4 hl6 = motherAge.
sort cases by uf1 uf2 uf4.
save outfile = "tmphl.sav".

* Open children under 5 data file.
get file = "ch.sav".

sort cases by uf1 uf2 uf4.

match files /file=*
  /table='tmp.sav'
  /by uf1 uf2.

match files /file=*
  /table='tmphl.sav'
  /by uf1 uf2 uf4.

recode UF17 (1 = 100) (else = 0) into complete.

compute nh = 1.
variable labels nh "".
value labels nh 1 "Number of children".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

do if (motherAge >=15 and motherAge <= 17).
+ compute mc1517 = 1.
+ compute consent=0.
+ if UF17 = 6 consent=100.
end if.

variable labels consent "Percentage with no adult consent".
variable labels mc1517 "".
value labels mc1517 1 "Number of mother/caretakers age 15-17 years".

compute layer = 1.
variable labels layer " ".
value labels layer 1 "Result of individual interview (Under-5 Questionnaire)".

* Ctables command in English (currently active, comment it out if using different language).
ctables
 /vlabels variables=total nh mc1517 layer UF17 display=none
 /table  total [c] + team [c] by
          layer [c] > (UF17 [c][rowpct.validn f5.1]) + nh [c] +consent [s] [mean '' f5.1] + mc1517 [c]
 /slabels visible = no
 /categories variables = UF17 total = yes
 /categories variables=all empty=exclude missing=exclude
 /title title=  "F3U. Response Rate: Under 5" 							
                  "Percent distribution of eligible children under age 5 by result of individual interview with mother/caretaker, according to interviewer team, " + surveyname.					

new file.

erase file  = "tmp.sav".
erase file  = "tmphl.sav".
