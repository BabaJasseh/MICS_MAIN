* Encoding: UTF-8.
* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = "hh.sav".

sort cases by hh1 hh2.

include "targets.sps".
 
save outfile = "tmphh.sav" /keep hh1 hh2 team /rename hh1 = uf1 hh2 = uf2.

get file = 'ch.sav'.
sort cases by uf1 uf2 uf3.

match files / file = *
 /table = 'tmphh.sav'
 /by uf1 uf2.

select if (UF17 = 1).

recode BR1 (1,2 = 100) (else = 0) into card.
variable labels card "Percent of children reported to have a birth certificate (1)".

recode BR1 (1 = 100) (else=0) into cseen.
variable label cseen "Percent of children whose birth certificate was seen by interviewer (2)".

compute regncard = 0.
if (card = 0 and br2 = 1) regncard = 100.
variable labels regncard "Percent of children whose birth was registered but does not have a birth certificate (3)" .

compute regorcard = 0.
if (card = 100 or regncard = 100) regorcard=100.
variable labels regorcard "Percent of all births with a birth certificate or registered (4)".

do if (card = 100).
compute pseen=0.
if (cseen=100) pseen=100.
end if.

variable labels pseen "Proportion of birth certificates seen (%) (6) = (2) / (1))".

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

* target should be set to 90 - at least 90% of birth certificates should be seen.
do if (teamt < 90).
+ compute target = teamt.
end if.

* to calculate correct number of women exclude temporarily generated cases needed for calculation of target reached.
do if (sysmis (teamt)).
+ compute cn = 1.
end if.

variable labels target "Target not met".

variable labels cn = " ".
value labels cn 1 "Number of children (5)".

ctables
  /vlabels variables =cn display = none
  /table tot2 [c] + team [c] by
	card [s] [mean '' f7.1] + 
	cseen [s] [mean '' f7.1] + 
	regncard [s] [mean '' f7.1]+
	regorcard [s] [mean '' f7.1] + 
	cn [c][count '' f5.0] + 
	pseen [s] [mean '' f7.1] +
	target [s] [mean '' f7.1]
  /categories variables = all empty = exclude missing = exclude
 /slabels visible = no  
  /titles title="F8A: Observation of birth certificates"  
	"Percentage of children under 5 who have a birth certificate, percentage of children under 5 whose birth certificate was seen by the interviewer, "+
                   "percentage of children whose birth has been registered, and proportion of birth certificates seen, according to interviewer team, " + surveyname
   Caption="Target >=90, at least 90% of birth certificates should be seen".

new file.

erase file = "tmphh.sav".	
erase file = "tmp.sav".		
erase file = "tmp1.sav".	
erase file = "tmp2.sav".	

