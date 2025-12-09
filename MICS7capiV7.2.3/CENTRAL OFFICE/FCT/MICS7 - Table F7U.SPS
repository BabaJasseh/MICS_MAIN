* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = "hh.sav".

sort cases by hh1 hh2.

include "targets.sps".
 
save outfile = "tmphh.sav" /keep hh1 hh2 team /rename hh1 = uf1 hh2 = uf2.

* Open the children data file.
get file = 'ch.sav'.

select if (UF17 = 1).

sort cases by uf1 uf2.

match files / file = *
 /table = 'tmphh.sav'
 /by uf1 uf2.

compute total = 1.
value labels total 1 "Number of children under 5".

compute tot1 = 1.
value labels tot1 1 " " .
variable labels tot1 "Total" .

compute diarrhea=0.
if (CA1 = 1) diarrhea=100.
variable labels diarrhea "Diarrhea in the last 2 weeks" .

compute fever=0.
if (CA14 = 1) fever=100.
variable labels fever "Fever in the last 2 weeks".

compute cough=0.
if (CA16 = 1) cough=100.
variable labels cough "A symptom of ARI in the last 2 weeks".

compute layer = 1.
value labels layer 1 "Percentage of children with:".
variable labels layer "". 

do if (UB2 > 0).
+ compute nodiscipline = 0.
+ if (UCD2A <> 1 and UCD2B <> 1 and UCD2C <> 1 and UCD2D <> 1 and UCD2E <> 1 and UCD2F <> 1 and UCD2G <> 1 and UCD2H <> 1 and UCD2I <> 1 and UCD2J <> 1 and UCD2K <> 1) nodiscipline = 100.
+ compute total1 = 1.
end if.

do if (UB2 > 1).
+ compute nodifficulty = 0.
+ recode UCF12 (sysmis = 95).
+ recode UCF13 (sysmis = 95).
+ if (UCF7 = 1 and UCF9 = 1 and (UCF12 = 1 or UCF12 = 95) and (UCF13 = 1 or UCF13 = 95) and UCF14 = 1 and UCF15 = 1 and UCF16 = 1 and UCF17 = 1 and UCF18 = 1) nodifficulty = 100.
+ compute total2 = 1.
end if.
	
do if (cage > 5 and cage < 24).

* Include all questions under BD7.
+ compute noliquids = 0.
+ if (BD7A <> 1 and BD7B <> 1 and BD7C <> 1 and BD7D <> 1 and BD7E <> 1 and BD7X <> 1) noliquids = 100.

* Include all questions under BD8.
+ compute nofood = 0.
+ if (BD8A <> 1 and BD8B <> 1 and BD8C <> 1 and BD8D <> 1 and BD8E <> 1 and BD8F <> 1 and 
	BD8G <> 1 and BD8H <> 1 and BD8I <> 1 and BD8J <> 1 and BD8K <> 1 and BD8L <> 1 and 
	BD8M <> 1 and BD8N <> 1 and BD8X <> 1) nofood = 100.

* Include no food on BD8 and no breastmilk.
+ compute zerofood = 0.
+ if (BD8A = 2 and BD8B = 2 and BD8C = 2 and BD8D = 2 and BD8E = 2 and BD8F = 2 and 
	BD8G = 2 and BD8H = 2 and BD8I = 2 and BD8J = 2 and BD8K = 2 and BD8L = 2 and 
	BD8M = 2 and BD8N = 2 and BD8X = 2 and
        BD3 = 2) zerofood = 100.

+ compute total3 = 1.

end if.

variable labels nodiscipline "Percentage of children with all <No> responses to Child Discipline".
variable labels nodifficulty "Percentage of children with all <No difficulty> responses to Child Functioning".
variable labels noliquids " All <No> or <DK> responses to BD7 liquids".
variable labels nofood "All <No> or <DK> responses to BD8 solid or semi-solid foods".
value labels total1 1 "Number of children age 1-4".
value labels total2 1"Number of children age 2-4".
value labels total3 1"Number of children age 6-23 months".

ctables
  /vlabels variables = layer total total1 total2 total3 display = none
 /table tot1 [c] + team [c] by 
                 layer [c] > (diarrhea [s] [mean '' f5.1] +	
                 cough [s] [mean '' f5.1] +  	
                 fever [s] [mean '' f5.1]) +
	total [c] [count '' f7.0] + 
  	nodiscipline [s] [mean '' f5.1] +
	total1 [c] [count '' f7.0] + 
  	nodifficulty [s] [mean '' f5.1] +
	total2 [c] [count '' f7.0] + 
	layer [c] > (noliquids [s] [mean '' f5.1] +
	nofood [s] [mean '' f5.1] +
                  zerofood [s] [mean '' f5.1]) +
	total3 [c] [count '' f7.0]  
 /categories variables=all empty=exclude missing=exclude
 /slabels position=column visible = no
 /titles title = 
   "F7U. Question responses by team: Under-5 questionnaire"
   "Percentage of certain responses to key questions in the under five questionnaire, according to interviewer team, " + surveyname.

new file.		

erase file = "tmphh.sav".		

