* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open the women data file.
get file = 'wm.sav'.

include "targets.sps".

select if (WM17 = 1 and sysmis(VW1)=0).

compute wn = 1.
compute total = 1.

compute priv = 0.
if (VW1 = 2) priv = 100.

variable labels total "Total".
value labels total 1 " " .
variable labels wn " ".
value labels wn 1 "Number of women selected for Violence Against Women module" .
variable labels priv "Percentage of women selected for Violence Against Women module where the module was not administered due to lack of privacy".

ctables
  /vlabels variables = wn
         display = none
   /table total [c] + team [c] by 
    priv [s] [mean '' f5.1] + wn [c] [count '' f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title = 
   "F13B. Violence Against Women module: Privacy"
   "Percentage of women selected for Violence Against Women module where the module was not administered because privacy was not possible, by interviewer team, " + surveyname
.

new file.		
