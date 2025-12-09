* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = "hh.sav".

sort cases by hh1 hh2.

include "targets.sps".
 
save outfile = "tmphh.sav" /keep hh1 hh2 team /rename hh1 = uf1 hh2 = uf2.

get file = 'ch.sav'.
sort cases by uf1 uf2 uf3.

* select only children under age 3.
select if (UB2 < 3).

match files / file = *
 /table = 'tmphh.sav'
 /by uf1 uf2.

select if (UF17 = 1).

recode IM2 (1,2,3 = 100) (else = 0) into hascard.
variable labels hascard "Percent of children reported to have a vaccination card / document (1)".

recode IM5 (1,2,3 = 100) (else = 0) into cseen.
variable labels cseen "Percent of children whose vaccination card / document was seen by interviewer (2)".

do if (hascard = 100).
+ compute pseen = 0.
+ if (cseen = 100) pseen = 100.
end if.

variable labels pseen "Proportion of cards / document seen (%) (4)= (2)/(1)*100".

compute tot1 = 1.
variable labels tot1 "Total".
value labels tot1 1 " ".

compute tot2 = 1.
variable labels tot2 "Total".
value labels tot2 1 " ".

save outfile = "tmp.sav".

aggregate 
  /outfile = "tmp1.sav"
  /break = team
  /teamt = mean (pseen).

aggregate 
  /outfile = "tmp2.sav"
  /break = tot2
  /teamt = mean (pseen).

* Add this summary information .
get file = 'tmp.sav'.
add files
  /file = *
  /file = 'tmp1.sav'
  /file = 'tmp2.sav'.

* target should be set to 90 - at least 90% of vaccination cards should be seen.
do if (teamt < 90).
+ compute target = teamt.
end if.

* to calculate correct number of women exclude temporarily generated cases needed for calculation of target reached.
do if (sysmis (teamt)).
+ compute cn = 1.
end if.

variable labels target "Target not met".

variable labels cn = " ".
value labels cn 1 "Number of children (3)".

ctables
  /vlabels variables =cn display = none
  /table tot2 [c] + team [c] by
	hascard [s] [mean '' f7.1] + 
	cseen [s] [mean '' f7.1] + 
	cn [c][count '' f5.0] +
	pseen [s] [mean '' f7.1] +
	target [s] [mean '' f7.1]
    /categories variables = all empty = exclude missing = exclude
   /slabels visible = no  
  /titles title="F8B. Observation of vaccination cards / documents"  
	"Percentage of children under age 3 who have a vaccination card / document, percentage of children whose card / document was seen by the interviewer, and proportion of cards / documents seen,  "+
                   "according to interviewer team, " + surveyname
       caption="Target >=90, at least 90% of have a vaccination card / document should be seen".

new file.

erase file 'tmphh.sav'.
erase file 'tmp.sav'.
erase file = "tmp1.sav".	
erase file = "tmp2.sav".	