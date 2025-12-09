* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = "hh.sav".

sort cases by hh1 hh2.

include "targets.sps".
 
save outfile = "tmp.sav" /keep hh1 hh2 team target5w.

* Open household listing data file.
get file = "hl.sav".

sort cases by hh1 hh2.

match files /file=*
  /table='tmp.sav'
  /by hh1 hh2.

select if (HL4 = 2 and HL6 >= 12 and HL6 <= 27).

compute total = 1.
variable labels total "Total".

compute cwom = 1.

compute cwom12 = 0.
if (HL6 = 12) cwom12 = 1.

compute cwom13 = 0.
if (HL6 = 13) cwom13 = 1.

compute cwom14 = 0.
if (HL6 = 14) cwom14 = 1.

compute cwom15 = 0.
if (HL6 = 15) cwom15 = 1.

compute cwom16 = 0.
if (HL6 = 16) cwom16= 1.

compute cwom17 = 0.
if (HL6 = 17) cwom17 = 1.

compute cwom18 = 0.
if (HL6 = 18) cwom18 = 1.

compute cwom19 = 0.
if (HL6 = 19) cwom19 = 1.

compute cwom20 = 0.
if (HL6 = 20) cwom20 = 1.

compute cwom21 = 0.
if (HL6 = 21) cwom21 = 1.

compute cwom22 = 0.
if (HL6 = 22) cwom22 = 1.

compute cwom23 = 0.
if (HL6 = 23) cwom23 = 1.

compute cwom24 = 0.
if (HL6 = 24) cwom24 = 1.

compute cwom25 = 0.
if (HL6 = 25) cwom25 = 1.

compute cwom26 = 0.
if (HL6 = 26) cwom26 = 1.

compute cwom27 = 0.
if (HL6 = 27) cwom27 = 1.

aggregate outfile = 'tmp1.sav'
  /break   = team 
  /agew  = sum(cwom)
  /agew12 = sum(cwom12)
  /agew13 = sum(cwom13)
  /agew14 = sum(cwom14)
  /agew15 = sum(cwom15)
  /agew16 = sum(cwom16)
  /agew17 = sum(cwom17)
  /agew18 = sum(cwom18)
  /agew19 = sum(cwom19)
  /agew20 = sum(cwom20)
  /agew21 = sum(cwom21)
  /agew22 = sum(cwom22)
  /agew23 = sum(cwom23)
  /agew24 = sum(cwom24)
  /agew25 = sum(cwom25)
  /agew26 = sum(cwom26)
  /agew27 = sum(cwom27)
  /target = mean(target5w).

aggregate outfile = 'tmp2.sav'
  /break   =  total
  /agew  = sum(cwom)
  /agew12 = sum(cwom12)
  /agew13 = sum(cwom13)
  /agew14 = sum(cwom14)
  /agew15 = sum(cwom15)
  /agew16 = sum(cwom16)
  /agew17 = sum(cwom17)
  /agew18 = sum(cwom18)
  /agew19 = sum(cwom19)
  /agew20 = sum(cwom20)
  /agew21 = sum(cwom21)
  /agew22 = sum(cwom22)
  /agew23 = sum(cwom23)
  /agew24 = sum(cwom24)
  /agew25 = sum(cwom25)
  /agew26 = sum(cwom26)
  /agew27 = sum(cwom27)
  /target = mean(target5w).

* Add this summary information together in one data file.
get file = 'tmp1.sav'.
add files
  /file = *
  /file = 'tmp2.sav'.

variable labels agew12 "12".
variable labels agew13 "13".
variable labels agew14 "14".
variable labels agew15 "15".
variable labels agew16 "16".
variable labels agew17 "17".
variable labels agew18 "18".
variable labels agew19 "19".
variable labels agew20 "20".
variable labels agew21 "21".
variable labels agew22 "22".
variable labels agew23 "23".
variable labels agew24 "24".
variable labels agew25 "25".
variable labels agew26 "26".
variable labels agew27 "27".
variable labels agew "Total". 

do if (agew15 > 0).
+ compute ratiow1415 =  agew14/agew15.
end if.
variable labels ratiow1415 "Age ratio (women 14/ women 15)".

do if (agew24 > 0).
+ compute ratiow2524 =  agew25/agew24.
end if.
variable labels ratiow2524 "Age ratio (women 25/ women 24)".

do if (ratiow1415 <= target).
compute targetmet1415 = ratiow1415.
end if.

do if (ratiow2524 <= target).
compute targetmet2524 = ratiow2524.
end if.

variable labels targetmet1415 "Target not met".
variable labels targetmet2524 "Target not met".

compute layer = 0.
value labels layer 0 "Women's age (12 - 27 years)".
value labels total 1 " ".

ctables
 /vlabels variables = layer
     display= none  
 /table  total [c] + team [c]  by
           layer[c] > ( agew12 [s] [sum f5.0] + agew13 [s] [sum f5.0] + agew14 [s] [sum f5.0] + agew15 [s] [sum f5.0] + agew16 [s] [sum f5.0] + agew17 [s] [sum f5.0] + agew18 [s] [sum f5.0] + 
           agew19 [s] [sum f5.0] + agew20 [s] [sum f5.0] + agew21 [s] [sum f5.0] + agew22 [s] [sum f5.0] + agew23 [s] [sum f5.0] + agew24 [s] [sum f5.0] + agew25 [s] [sum f5.0] + agew26 [s] [sum f5.0] + agew27 [s] [sum f5.0]) + 
           agew [s] [sum f5.0] + ratiow1415 [s] [sum f5.1] + targetmet1415 [s] [sum f5.1] + ratiow2524 [s] [sum f5.1] + targetmet2524 [s] [sum f5.1] 
  /slabels visible = no
 /titles title=  "F5W: Age displacement: women. "										
                    "Number of women age 12-27 years listed in the household schedule by single year of age and age ratio 14/15 and 25/24, according to interviewer team, "+ surveyname
           caption='Target: Age ratio target for 14 to 15 year olds <= 0.8'
           'Target: Age ratio target for 25 to 24 year olds <= 0.8'.

new file.
erase file 'tmp.sav'.
erase file 'tmp1.sav'.
erase file 'tmp2.sav'.
