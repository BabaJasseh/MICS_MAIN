* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open household members data file.
get files="hh.sav".

include "targets.sps".

select if (hh46 = 1).

* Select completed households.
compute complete = 1.
variable labels complete "Number of completed households".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

aggregate outfile = 'tmp1.sav'
  /break   =   HH6 team
  /hhcomp  = sum(complete)
  /children   = sum(HH51)
  /children5_17  = sum(HH52)
  /t2cU = mean(t2cU)
  /t2cR = mean(t2cR)
  /t2aU = mean(t2aU)
  /t2aR = mean(t2aR).

aggregate outfile = 'tmp2.sav'
  /break   =  HH6 total
  /hhcomp  = sum(complete)
  /children   = sum(HH51)
  /children5_17  = sum(HH52)
  /t2cU = mean(t2cU)
  /t2cR = mean(t2cR)
  /t2aU = mean(t2aU)
  /t2aR = mean(t2aR).

* Add this summary information together in one data file.
get file = 'tmp1.sav'.
add files
  /file = *
  /file = 'tmp2.sav'.

compute mchildren = children/hhcomp.
compute mchildren5_17 = children5_17/hhcomp.

* Separatly for urban areas.
do if (HH6 = 1 and mchildren < 0.80*t2cU).
+ compute target  =  mchildren.
end if.
do if (HH6 = 1 and mchildren5_17 < 0.80*t2aU).
+ compute target2  =  mchildren5_17.
end if.

*... and for rural areas.
do if (HH6 = 2 and mchildren < 0.80*t2cR).
+ compute target  =  mchildren.
end if.
do if (HH6 = 2 and mchildren5_17 < 0.80*t2aR).
+ compute target2  =  mchildren5_17.
end if.

variable labels mchildren "Mean number of eligible children under 5 per HH".
variable labels mchildren5_17 "Mean number of eligible children 5-17 per HH".
variable labels hhcomp "Number of completed households".
variable labels children "Number of eligible children under 5 in completed households".
variable labels children5_17 "Number of eligible children 5-17 in completed households".
variable labels target "Target not met".
variable labels target2 "Target not met".

* Ctables command for the tabulation in newer versions of SPSS.
ctables
  /vlabels variables=total HH6 display=none
  /table total [c] + team [c] by
          hh6[c] > (hhcomp [s] [sum f5.0] + 
          children [s] [sum f5.0] + 
          mchildren [s] [mean '' f5.1] +
          target [s] [mean '' f5.1] + 
          children5_17 [s] [sum f5.0] + 
          mchildren5_17 [s] [mean '' f5.1] +
          target2 [s] [mean '' f5.1]) 
  /slabels visible = no
  /categories variables=all empty=exclude missing=exclude
  /titles title=  "F2UC. Eligible children per household" 							
                    "Mean number of eligible children per household, according to interviewer team, " + surveyname 
           caption='Target: Expected to find 0.5 children under 5 in urban areas and 0.83 in rural areas; 1.24 children 5-17 in urban areas and 1.33 in rural areas.'.

new file.
erase file 'tmp1.sav'.
erase file 'tmp2.sav'.

