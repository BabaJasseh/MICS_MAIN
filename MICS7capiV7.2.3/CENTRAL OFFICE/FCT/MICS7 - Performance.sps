* Encoding: windows-1252.
***.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open household members data file.
get file = 'hl.sav'.

include "targets.sps".

sort cases by hh1 hh2 hl1.

aggregate
  /outfile=* mode=addvariables
  /break=hh1 
  /hl1_max=max(hl1).

variable labels HL1_max "Mean number of household members".

select if (HL1 = 1).

string today (A11).
compute today = $DATE11.
alter type today(date11).

compute survey_date=DATE.DMY(HH5D,HH5M,HH5Y).
alter type survey_date (date11).

compute NUMdays = DATEDIFF(today,survey_date,"days").

rank variables=NUMdays (a) /ntiles (2) /print=no /ties=mean.

variable labels NNUMdays "".
value labels NNUMdays 1 "First half of fieldwork to date" 2 "Second half of fieldwork to date".

compute clusters = 1.
variable labels clusters "".
value labels clusters 1 "Total number of households".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

*Ctables command in English (currently active, comment it out if using different language).
ctables
 /vlabels variables=total clusters NNUMdays HH6 display=none
 /table  total [c] + team [c] by
          NNUMdays [c] > (HH6 > (HL1_max [s] [mean '' f5.1])) + clusters [c]
 /slabels visible = no
 /categories var=all empty=exclude missing=exclude
 /title title=  "Performance overview" 							
                  "Performance indicators sectioned in periods of fieldwork, by interviewer team, " + surveyname.					

new file.													

