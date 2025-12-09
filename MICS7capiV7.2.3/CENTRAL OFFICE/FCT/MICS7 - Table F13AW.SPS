* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open the women data file.
get file = 'wm.sav'.

include "targets.sps".

select if (WM17 = 1).

select if (WB4>=15 and WB4<=24).

compute wn = 1.
compute layer = 1.
compute total = 1.
compute priv1 = 0.
compute priv2   = 0.

if (MH1 = 2) priv1 = 100.
if (MH40 = 2) priv2 = 100.

variable labels total "Total".
value labels total 1 " " .
variable labels wn " ".
value labels wn 1 "Number of women (age 15-24)" .
variable labels priv1 "Percentage of women (age 15-24) to whom the mental health module was not administered due to lack of privacy".
variable labels priv2 "Percentage of women (age 15-24) to whom the suicide questions in mental health module were not administered due to lack of privacy".
value labels layer 1 "Women (age 15-24)".

ctables
  /vlabels variables = layer wn
         display = none
   /table total [c] + team [c] by 
    layer [c] > priv1 [s] [mean '' f5.1] + priv2 [s] [mean '' f5.1] + wn [c] [count '' f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title = 
   "F13AW. Mental Health module: Privacy"
   "Percentage of women (age 15-24) who were not administered Mental Health module because privacy was not possible, " +
   "and percentage to whom the suicide questions were not administered because privacy was not possible, by interviewer team, " + surveyname
.

new file.		
