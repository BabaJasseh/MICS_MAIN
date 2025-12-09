* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = "hh.sav".

sort cases by hh1 hh2.

include "targets.sps".
 
save outfile = "tmp.sav"  /keep hh1 hh2 team /rename hh1 = mwm1 hh2 = mwm2.

get file = "hl.sav"
 /keep hh1 hh2 hl1 hl6
 /rename hh1 = mwm1 hh2 = mwm2 hl1 = mwm3 hl1 = mwm3.
sort cases by mwm1 mwm2 mwm3.
save outfile = "tmphl.sav".

* Open men data file.
get file = "mn.sav".

sort cases by mwm1 mwm2 mwm3.

match files /file=*
  /table='tmp.sav'
  /by mwm1 mwm2.

match files /file=*
  /table='tmphl.sav'
  /by mwm1 mwm2 mwm3.

recode MWM17 (1 = 100) (else = 0) into complete.

compute nh = 1.
variable labels nh "".
value labels nh 1 "Number of men".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

do if (hl6 >=15 and hl6 <=17).
+ compute men1517 = 1.
+ compute consent=0.
+ if MWM17=6  consent=100.
end if.

variable labels consent "Percentage with no adult consent".
variable labels men1517 "".
value labels men1517 1 "Number of men age 15-17 years".

compute layer = 1.
variable labels layer " ".
value labels layer 1 "Result of individual interview (Men's Questionnaire)".


* Ctables command in English (currently active, comment it out if using different language).
ctables
 /vlabels variables=total nh men1517 layer MWM17 display=none
 /table  total [c] + team [c] by
          layer [c] >(MWM17 [c][rowpct.validn f5.1]) + nh [c] + consent [s] [mean '' f5.1] + men1517 [c]
 /slabels visible = no
 /categories variables = MWM17 total = yes
 /categories variables=all empty=exclude missing=exclude
 /title title=  "F3M. Response Rate: Eligible men" 							
                  "Percent distribution of eligible men age 15-49 years by result of individual interview, according to interviewer team, " + surveyname.					

new file.

erase file  = "tmp.sav".
erase file  = "tmphl.sav".
