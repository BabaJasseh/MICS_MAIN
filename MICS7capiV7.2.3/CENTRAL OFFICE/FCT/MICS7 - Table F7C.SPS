* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = "hh.sav".

sort cases by hh1 hh2.

include "targets.sps".
 
save outfile = "tmphh.sav" /keep hh1 hh2 team /rename hh1 = fs1 hh2 = fs2.

* Open the children 5-17 data file.
get file = 'fs.sav'.

select if (FS17 = 1).

sort cases by fs1 fs2.

match files / file = *
 /table = 'tmphh.sav'
 /by fs1 fs2.

compute total = 1.
value labels total 1 "Number of children age 5-17".

compute tot1 = 1.
value labels tot1 1 " " .
variable labels tot1 "Total" .

compute nodifficulty = 0.
if (FCF6 = 1 and FCF8 = 1 and FCF14 = 1 and FCF15 = 1 and FCF16 = 1 and FCF17 = 1 and FCF18 = 1 and 
    FCF19 = 1and FCF20 = 1 and FCF21 = 1 and FCF22 = 1 and FCF23 = 1 and FCF24 = 1) nodifficulty = 100.

do if (CB3 < 15).
+ compute nodiscipline = 0.
+ if (FCD2A <> 1 and FCD2B <> 1 and FCD2C <> 1 and FCD2D <> 1 and FCD2E <> 1 and FCD2F <> 1 and FCD2G <> 1 and FCD2H <> 1 and FCD2I <> 1 and FCD2J <> 1 and FCD2K <> 1) nodiscipline = 100.
+ compute total1 = 1.
end if.

variable labels nodiscipline "Percentage of children with all <No> responses to Child Discipline".
variable labels nodifficulty "Percentage of children with all <No difficulty> responses to Child Functioning".
value labels total1 1 "Number of children age 5-14 with completed interview".

ctables
  /vlabels variables = total1  total 
         display = none
 /table tot1 [c] + team [c] by 
	nodiscipline [s] [mean '' f5.1] +
	total1 [c] [count '' f7.0] + 
                  nodifficulty [s] [mean,'',f5.1] +
              	total [c] [count '' f7.0] 
 /categories variables=all empty=exclude missing=exclude
 /slabels position=column visible = no
 /titles title = 
   "F7C. Question responses by team: 5-17 questionnaire"
   "Percentage of certain responses to key questions in the 5-17 questionnaire, according to interviewer team, " + surveyname.

new file.		

erase file = "tmphh.sav".		

