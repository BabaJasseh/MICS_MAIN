* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = "hh.sav".

sort cases by hh1 hh2.

include "targets.sps".
 
save outfile = "tmp.sav"  /keep hh1 hh2 team /rename hh1 = fs1 hh2 = fs2.

get file = "hl.sav"
 /keep hh1 hh2 hl1 hl6
 /rename hh1 = fs1 hh2 = fs2 hl1 = fs4 hl6 = motherAge.
sort cases by fs1 fs2 fs4.
save outfile = "tmphl.sav".

* Open children 5 - 17 data file.
get file = "fs.sav".

sort cases by fs1 fs2 fs4.

match files /file=*
  /table='tmp.sav'
  /by fs1 fs2.

match files /file=*
  /table='tmphl.sav'
  /by fs1 fs2 fs4.

recode fs17 (1 = 100) (else = 0) into complete.

compute nh = 1.
variable labels nh "".
value labels nh 1 "Number of children".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

compute consent=0.
if (fs17 = 6) consent=100.

do if (CB3 >=15 and CB3 <= 17).
+ compute emancipated = 0.
+ if fs4 = 90 emancipated = 100.
+ compute eman = 1.
end if.

variable labels consent "Percentage with no adult consent".
variable labels emancipated "Percentage emancipated children".
variable labels eman "Number of selected children age 15-17 years".


* Ctables command in English (currently active, comment it out if using different language).
ctables
 /vlabels variables=total nh display=none
 /table  total [c] + team [c] by
          (fs17 [c][rowpct.validn f5.1]) + nh [c] + consent [s] [mean '' f5.1] + emancipated [s] [mean '' f5.1]  + eman [s] [sum '' f5.0]
 /slabels visible = no
 /categories variables = fs17 total = yes
 /categories variables=all empty=exclude missing=exclude
 /title title=  "F3C. Response rate: 5-17" 							
                  "Percent distribution of selected children age 5-17 by result of individual interview with mother/caretaker, according to interviewer team, " + surveyname.					

new file.

erase file  = "tmp.sav".
erase file  = "tmphl.sav".
