* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open household members data file.
get files="hh.sav".

include "targets.sps".

select if (HH46 = 1).

* Select completed households only.

compute complete = 1.
variable labels complete "Number of completed households".

compute selected = 0.
if (HH8 = 1) selected = 1.
variable labels selected "Number of completed households selected for men's interviews".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

aggregate outfile = 'tmp1.sav'
  /break   =  HH6 team
  /hhcomp  = sum (complete)
  /hhsel  = sum (selected)
  /men   = sum (HH50)
  /t2mU = mean(t2mU)
  /t2mR = mean(t2mR).

aggregate outfile = 'tmp2.sav'
  /break   =  HH6 total
  /hhcomp  = sum (complete)
  /hhsel  = sum (selected)
  /men   = sum (HH50)
  /t2mU = mean(t2mU)
  /t2mR = mean(t2mR).

* Add this summary information together in one data file.
get file = 'tmp1.sav'.
add files
  /file = *
  /file = 'tmp2.sav'.

do if (hhsel > 0).
+ compute mmen = men/hhsel.
end if.

* TARGETS!.
* Change targets below accordingly.
* In the below example it is expected to find 1.37 men in urban areas and 1.06 men in rural areas.

* Separatly for urban areas.
do if (HH6 = 1 and mmen < 0.80*t2mU).
+ compute target  =  mmen.
end if.

*... and for rural areas.
do if (HH6 = 2 and mmen < 0.80*t2mR).
+ compute target  =  mmen.
end if.

variable labels hhcomp "Number of completed households".
variable labels hhsel "Number of completed households selected for men's interviews".
variable labels men "Number of eligible men in selected and completed households".
variable labels mmen "Mean number of eligible men per HH".
variable labels target "Target not met".

* Ctables command for the tabulation in newer versions of SPSS.
ctables
  /vlabels variables=total HH6 display=none
  /table   total [c] + team [c] by
           HH6[c] > ( hhcomp [s] [sum f5.0] + 
           hhsel [s] [sum f5.0] +
           men [s] [sum f5.0] + 
           mmen [s] [mean '' f5.1] +
           target [s] [mean '' f5.1])
  /slabels visible = no
  /categories variables=all empty=exclude missing=exclude
  /titles title=  "F2M Eligible men per household. " 							
                    "Mean number of eligible men per household, according to interviewer team, " surveyname .

new file.

erase file 'tmp1.sav'.
erase file 'tmp2.sav'.


