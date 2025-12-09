* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open the women data file.
get file = 'hh.sav'.

include "targets.sps".

select if (HH46 = 1).

compute hhn = 1.
compute total = 1.
compute miss1 = 0.
compute miss2 = 0.

if (FE1 = 9 and FE2 = 9 and FE3 = 9 and FE4 = 9 and FE5 = 9 and FE6 = 9 and FE7 = 9 and FE8 = 9) miss1 = 100.
if (FE1 = 2 and FE2 = 2 and FE3 = 2 and FE4 = 2 and FE5 = 2 and FE6 = 2 and FE7 = 2 and FE8 = 2) miss2 = 100.

variable labels total "Total".
value labels total 1 " " .
variable labels hhn " ".
value labels hhn 1 "Number of households" .
variable labels miss1 "Percentage with all <Missing> responses to all FIES questions".
variable labels miss2 "Percentage with all: <No> responses to all FIES questions".	

ctables
  /vlabels variables = hhn
         display = none
   /table total [c] + team [c] by 
   miss1 [s] [mean '' f5.1]  + miss2 [s] [mean '' f5.1]  + hhn [c] [count '' f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title = 
   "F14. Food Insecurity"
   "Percentage of households with certain responses to questions in Food Insecurity Expereince module, " + surveyname
.

new file.		
