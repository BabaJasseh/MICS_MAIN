* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = "hh.sav".

sort cases by hh1 hh2.

include "targets.sps".
 
save outfile = "tmphh.sav" /keep hh1 hh2 team.

get file = "tn.sav".

sort cases hh1 hh2 tnln.

match files / file = *
 /table = 'tmphh.sav'
 /by hh1 hh2.

compute obs = 0.
if (tn3 = 1) obs = 100.
variable labels obs "Percent of bednets observed by interviewer".

compute total = 1.
variable labels total " ".
value labels total 1 "Total number of bednets".

compute tot = 1.
variable labels tot "Total".
value labels tot 1 " ".

save outfile = "tmp.sav".

aggregate 
  /outfile = "tmp1.sav"
  /break = team
  /teamt = mean (obs).

aggregate 
  /outfile = "tmp2.sav"
  /break = tot
  /teamt = mean (obs).

* Add this summary information .
get file = 'tmp.sav'.
add files
  /file = *
  /file = 'tmp1.sav'
  /file = 'tmp2.sav'.

* target should be set to 90 - at least 90% of nets should be seen.
do if (teamt < 90).
+ compute target = teamt.
end if.

* to calculate correct number of women exclude temporarily generated cases needed for calculation of target reached.
do if (sysmis (teamt)).
+ compute tnn = 1.
end if.

variable labels target "Target not met".

variable labels tnn " ".
value labels tnn 1 "Total number of bednets".

ctables
  /vlabels variables = total tnn display = none
  /table tot [c]  + team [c] by  
	obs [s] [mean,'' ,f7.1] + tnn [c][count,'',f5.0] + target [s] [mean,'' ,f7.1]
  /categories var= all empty = exclude
  /slabels visible = no 
  /titles title="F8D. Observation of bednets"  
	"Percentage of bednets in all households observed by the interviewers, " + surveyname.

new file.

erase file = "tmphh.sav".		
erase file = "tmp.sav".						
erase file = "tmp1.sav".
erase file = "tmp2.sav".	


