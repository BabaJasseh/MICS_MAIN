* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = "hh.sav".

sort cases by hh1 hh2.

include "targets.sps".
 
save outfile = "tmphh.sav" /keep hh1 hh2 team /rename hh1 = mwm1 hh2 = mwm2.

* Open the man data file.
get file = 'mn.sav'.

select if (MWM17 = 1).

sort cases by mwm1 mwm2.

match files / file = *
 /table = 'tmphh.sav'
 /by mwm1 mwm2.

compute total=1.
variable labels total "Number of men".

compute tot1 = 1.
value labels tot1 1 " " .
variable labels tot1 " Total" .

compute esex=0.
if (MSB1 > 0 and MSB1 < 97) esex=100.
variable labels esex "Ever had sex".
	
compute layer = 1.
value labels layer 1 "Percentage of men who have:".
variable labels layer " ".

ctables
 /vlabels variables = layer display = none
 /table tot1 [c]  + team [c] by
	esex [s] [mean '' f5.1] +
	total [s] [sum '' f7.0]
 /categories variables=all empty=exclude missing=exclude
 /slabels position=column visible = no
 /titles title = 
   "F7M. Question responses by team: Men's questionnaire"
   "Percentage of certain responses to key questions in the men's questionnaires, according to interviewer team " + surveyname.
			
new file.		

erase file = "tmphh.sav".		

