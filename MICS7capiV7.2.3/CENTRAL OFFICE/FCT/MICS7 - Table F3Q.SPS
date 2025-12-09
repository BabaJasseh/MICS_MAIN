* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = "hh.sav".

include "targets.sps".

select if (HH9 = 1 and HH46 = 1).

recode WQ31 (sysmis = 95).
add value labels WQ31 95 "Permision given, water quality test results still not entered".

compute nh = 1.
variable labels nh "".
value labels nh 1 "Number of households selected".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

compute layer = 1.
variable labels layer " ".
value labels layer 1 "Result of water quality testing (Water Quality Testing Questionnaire)".


* Ctables command in English (currently active, comment it out if using different language).
ctables
 /vlabels variables=total nh layer WQ31 display=none
 /table  total [c] + team [c] by
          layer [c] >(WQ31 [c][rowpct.validn f5.1]) + nh [c] 
 /slabels visible = no
 /categories variables = WQ31 total = yes
 /categories variables=all empty=exclude missing=exclude
 /title title=  "F3Q. Response rate: Qater Quality Testing" 							
                  "Percent distribution of selected households by result of water quality testing, according to interviewer team, " + surveyname.					

new file.


