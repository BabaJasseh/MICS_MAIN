* Encoding: UTF-8.
*Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = "hh.sav".

sort cases by hh1 hh2.

include "targets.sps".
 
save outfile = "tmp.sav"  /keep hh1 hh2 team /rename hh1 = fs1 hh2 = fs2.
sort cases by hh1 hh2.

* Open 5-17 data file.
get file = "fs.sav".

sort cases by fs1 fs2 fs3.

match files /file=*
  /table='tmp.sav'
  /by fs1 fs2.

select if (CB3 >=7 and CB3 <=14).

compute nh = 1.
variable labels nh "".
value labels nh 1 "Number of children".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

compute layer = 1.
variable labels layer " ".
value labels layer 1 "Result of learning assessment (age 7-14 in 5-17 Questionnaire)".


* Ctables command in English (currently active, comment it out if using different language).
ctables
 /vlabels variables=total nh layer display=none
 /table  total [c] + team [c] by
          layer [c] >(FL28 [c][rowpct.validn f5.1]) + nh [c] 
 /slabels visible = no
 /categories variables = FL28 total = yes
 /categories variables=all empty=exclude missing=exclude
 /title title=  "F3C2. Response rate: 7-14" 							
                  "Percent distribution of selected children age 7-14 by result of learning assessment, according to interviewer team, " + surveyname.					

new file.
erase file 'tmp.sav'.
