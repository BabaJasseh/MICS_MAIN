* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open the household data file.
get file = 'hh.sav'.

include "targets.sps".

* Give value 1 to each HH to calculate total number of hhs sampled.
compute total = 1.
variable labels total "".
value labels total 1 "Total".

* Give value 1 to each HH occupied to calculate total number of hhs occupied.
recode HH46 (1,2,4,7 = 100) (else = 0) into occupied.

* Give value 1 to each hh interviewed to calculate total no of interviewed HHs.
recode HH46 (1 = 100) (else = 0) into complete.

aggregate 
  /outfile = "tmp1.sav"
  /break = team
  /socc = sum (occupied)
  /scompl = sum (complete).

aggregate 
  /outfile = "tmp2.sav"
  /break = total
  /socc = sum (occupied)
  /scompl = sum (complete).

* Add this summary information .
add files
  /file = *
  /file = 'tmp1.sav'
  /file = 'tmp2.sav'.

* Give value 1 to each HH to calculate total number of hhs sampled.
variable labels total "".
value labels total 1 "Total".

compute rr = scompl/socc*100.
variable labels rr "Household response rate".

* to calculate correct number of HH exclude temporarily generated cases needed for calculation of response rates.
do if (sysmis (rr)).
+ compute nh = 1.
end if.

variable labels nh "".
value labels nh 1 "Number of households".

* Ctables command in English (currently active, comment it out if using different language).
ctables
 /vlabels variables=total nh display=none
 /table  total [c] + team [c] by
          HH46 [c] [rowpct.validn f5.1] + nh [c] + rr [s] [mean f5.1]
 /slabels visible = no
 /categories variables = HH46 total = yes
 /categories variables=all empty=exclude missing=exclude
 /titles title= "F1. Household response rate " 
              "Percent distribution of sampled households by result of household interview, according to interviewer team, " + surveyname.					

new file.

erase file 'tmp1.sav'.
erase file 'tmp2.sav'.
