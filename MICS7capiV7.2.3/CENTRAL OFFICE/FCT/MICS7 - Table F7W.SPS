* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = "hh.sav".

sort cases by hh1 hh2.

include "targets.sps".
 
save outfile = "tmphh.sav" /keep hh1 hh2 team /rename hh1 = wm1 hh2 = wm2.

* Open the women data file.
get file = 'wm.sav'.

select if (WM17 = 1).

sort cases by wm1 wm2.

match files / file = *
 /table = 'tmphh.sav'
 /by wm1 wm2.

compute total = 1.
variable labels total "Number of women".

compute tot1 = 1.
value labels tot1 1 " " .
variable labels tot1 "Total" .
		
compute layer = 1.
variable labels layer " ".
value labels layer 1 "Percentage of women:".

compute lbirth = 0.
if (CM17 = 1 ) lbirth = 100.
variable labels lbirth "With a live birth in the last 2 years" .

compute pregn = 0.
if (CP1 = 1) pregn = 100.
variable labels pregn "Currently pregnant" .

compute fgm = 0.
if (FG1 = 1 or FG2 = 1) fgm = 100.
variable labels fgm "Who have ever heard of FGM" .

compute esex = 0.
if (SB1 > 0 and SB1 < 97) esex=100.
variable labels esex "Who have ever had sex".

ctables
  /vlabels variables = layer display = none
  /table tot1 [c] + team [c] by 
		lbirth [s] [mean '' f5.1] +
		pregn [s] [mean '' f5.1] +
                                    fgm [s] [mean '' f5.1] +
		esex [s] [mean '' f5.1] +     
		total [s] [sum '' f7.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title = 
   "F7W. Question responses by team: Women's questionnaire"
   "Percentage of certain responses to key questions in the women's questionnaires, according to interviewer team, " + surveyname.

new file.
		
erase file = "tmphh.sav".		

