* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Observations of places for handwashing.

get file = 'hh.sav'.

include "targets.sps".

select if (HH46 = 1).

recode hw1 (1,2,3=100)(else=0) into hwash1.
recode hw1 (4=100)(else=0) into hwash2.
recode hw1 (5=100)(else=0) into hwash3.
recode hw1 (6=100)(else=0) into hwash4.
variable labels hwash1 "Percent of households where place for handwashing was observed".
variable labels hwash2 "Place for handwashing not in the dwelling, plot or yard".
variable labels hwash3 "No permission to see place for handwashing".
variable labels hwash4 "Other".

compute total = 1.
variable labels total " ".
value labels total 1 "Number of households".

compute tot1 = 100.
variable labels tot1 "Total".
value labels tot1 100 " ".

compute tot2 = 1.
variable labels tot2 "Total".
value labels tot2 1 " ".

save outfile = "tmp.sav".

aggregate 
  /outfile = "tmp1.sav"
  /break = team
  /hwash1m = mean (hwash1).

aggregate 
  /outfile = "tmp2.sav"
  /break = tot2
  /hwash1m = mean (hwash1).

* Add this summary information .
get file = 'tmp.sav'.
add files
  /file = *
  /file = 'tmp1.sav'
  /file = 'tmp2.sav'.

* target should be set to 99 - at least 99% of handwashing places should be seen.
do if (hwash1m < 90).
+ compute target = hwash1m.
end if.

do if (sysmis (hwash1m)).
+ compute hhn = 1.
end if.

variable labels target "Target not met".

variable labels hhn  " ".
value labels hhn 1 "Number of households".

ctables
  /vlabels variables = total hhn display = none
  /table  tot2 [c] + team [c]  by  
	hwash1 [s] [mean '' f7.1] + hwash2 [s] [mean '' f7.1] + hwash3 [s] [mean '' f7.1] + hwash4 [s] [mean '' f7.1] + hhn [c][count '' f5.0] + target [s] [mean '' f7.1]
  /categories variables= all empty = exclude
  /slabels visible = no 
  /titles title="F8E. Observation of places for hand washing"  
	"Percentage of places for handwashing observed by the interviewer in all interviewed households, according to interviewer team, " + surveyname
  caption= "Target >=90".

new file.	

erase file = "tmp.sav".						
erase file = "tmp1.sav".
erase file = "tmp2.sav".		


