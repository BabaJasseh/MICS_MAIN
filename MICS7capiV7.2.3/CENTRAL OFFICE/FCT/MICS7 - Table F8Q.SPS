* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = "hh.sav".

include "targets.sps". 

select if (WQ31 >= 1).

compute sObs = 2.
if (WQ12 <= 3) sObs = 1.
variable labels sObs "Household sample".
value labels sObs 1 "Source observed" 2 "Unable to observe source".

compute sSample = 2.
if (WQ19 = 1) sSample = 1.
if (WQ18 <> 1) sSample = 3.
variable labels sSample "Source sample".
value labels sSample 1 "Shown: Collected" 2 "Shown: Not collected" 3 "Not shown".

do if (WQ20 = 1).
+ compute blankecoli=0.
+ if WQ29 > 0 blankecoli=100.
end if.
value labels blankecoli  100 "Detected" 0 "Not detected".

compute blanktest = 2.
if (WQ20 = 1) blanktest = 1.
variable labels blanktest "Blank test:".
value labels blanktest 1 "Blank test: Number of blank tests with E. coli:" 2 "Blank test:Test not conducted".

if blanktest = 1 tot = 1.
value labels tot 1 "Number of households selected for blank testing".

compute nh = 1.
variable labels nh "".
value labels nh 1 "Number of households selected for water quality testing".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

* Ctables command in English (currently active, comment it out if using different language).
ctables
 /vlabels variables=total nh tot blanktest blankecoli display=none
 /table  total [c] + team [c] by
          sObs [c][rowpct.validn f5.1] + sSample [c][rowpct.validn f5.1] + nh [c] + blanktest [c] > blankecoli [c][count '' f5.0] + tot [c]
 /slabels visible = no
 /categories variables=all empty=exclude missing=exclude
 /title title=  "F8Q. Response rate: Qater Quality Testing" 							
                  "Percent distribution of selected households by result of water quality testing, according to interviewer team, " + surveyname.					

new file.


