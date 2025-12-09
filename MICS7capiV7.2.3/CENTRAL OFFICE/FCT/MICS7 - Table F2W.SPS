* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open household members data file.
get files = "hh.sav".

include "targets.sps".

* select complted households.
select if (HH46 = 1).

compute complete = 1.
variable labels complete "Number of completed households".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

aggregate outfile = 'tmp1.sav'
  /break   = HH6 team
  /hhcomp  = sum (complete)
  /women   = sum (HH49)
  /t2wU = mean(t2wU)
  /t2wR = mean(t2wR).

aggregate outfile = 'tmp2.sav'
  /break   =  HH6 total
  /hhcomp  = sum (complete)
  /women   = sum (HH49)
  /t2wU = mean(t2wU)
  /t2wR = mean(t2wR).

* Add this summary information together in one data file.
get file = 'tmp1.sav'.
add files
  /file = *
  /file = 'tmp2.sav'.

compute mwomen = women/hhcomp.

* Separatly for urban areas.
do if (HH6 = 1 and mwomen < 0.80*t2wU).
+ compute target  =  mwomen.
end if.

*... and for rural areas.
do if (HH6 = 2 and mwomen < 0.80*t2wR).
+ compute target  =  mwomen.
end if.

variable labels mwomen "Mean number of eligible women per HH".
variable labels hhcomp "Number of completed households".
variable labels women "Number of eligible women in completed households".
variable labels target "Target not met".

* Ctables command for the tabulation in newer versions of SPSS.
ctables
  /vlabels variables=total hh6 display=none
  /table  total [c] + team [c] by
           hh6[c] > (hhcomp [s] [sum f5.0] + 
           women [s] [sum f5.0] + 
           mwomen [s] [mean '' f5.1] +
           target [s] [mean '' f5.1])
  /slabels visible = no
  /categories variables=all empty=exclude missing=exclude
  /titles title=  "F2W. Eligible women per household  " 							
                    "Mean number of eligible women per household, according to interviewer team, " + surveyname 
           caption='Target: Expected to find 1.25 women in urban areas and 1.03 women in rural areas'.

new file.

erase file 'tmp1.sav'.
erase file 'tmp2.sav'.

