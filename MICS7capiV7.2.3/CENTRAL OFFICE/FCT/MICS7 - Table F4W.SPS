* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open women data file.
get file = "wm.sav".

sort cases by wm1 wm2 wm3.

save outfile = "tmpwm.sav" /keep wm1 wm2 wm3 wm17 /rename wm1 = hh1 wm2 = hh2 wm3 = hl1.

get file = "hl.sav".

sort cases by hh1 hh2 hl1.

select if (hl4 = 2 and hl6 >= 15 and hl6 <= 49).

include "targets.sps".
 
match files /file=*
  /table='tmpwm.sav'
  /by hh1 hh2 hl1.

compute total = 1.
variable labels total " ".
value labels total 1 "Total".

compute wom = 1.

do if (hl6 >=15 and hl6 <=19).
+ compute wom1519 = 1.
end if.
do if (hl6 >=20 and hl6 <=24).
+ compute wom2024 = 1.
end if.
do if (hl6 >=25 and hl6 <=29).
+ compute wom2529 = 1.
end if.
do if (hl6 >=30 and hl6 <=34).
+ compute wom3034 = 1.
end if.
do if (hl6 >=35 and hl6 <=39).
+ compute wom3539 = 1.
end if.
do if (hl6 >=40 and hl6 <=44).
+ compute wom4044 = 1.
end if.
do if (hl6 >=45 and hl6 <=49).
+ compute wom4549 = 1.
end if.

compute cwom = 0.
if (WM17 = 1) cwom = 1.

compute cwom1519 = 0.
if (WM17 = 1 and hl6 >=15 and hl6 <=19) cwom1519 = 1.

compute cwom2024 = 0.
if (WM17 = 1 and hl6 >=20 and hl6 <=24) cwom2024 = 1.

compute cwom2529 = 0.
if (WM17 = 1 and hl6 >=25 and hl6 <=29) cwom2529 = 1.

compute cwom3034 = 0.
if (WM17 = 1 and hl6 >=30 and hl6 <=34) cwom3034 = 1.

compute cwom3539 = 0.
if (WM17 = 1 and hl6 >=35 and hl6 <=39) cwom3539 = 1.

compute cwom4044 = 0.
if (WM17 = 1 and hl6 >=40 and hl6 <=44) cwom4044 = 1.

compute cwom4549 = 0.
if (WM17 = 1 and hl6 >=45 and hl6 <=49) cwom4549 = 1.

compute layer = 1.
variable labels layer " ".
value labels layer 1 "Women's age (15-49 years)".

aggregate outfile = 'tmp1.sav'
  /break   = team 
  /twom1  = sum(wom1519)
  /twomc1 = sum(cwom1519)
  /twom2  = sum(wom2024)
  /twomc2 = sum(cwom2024)
  /twom3  = sum(wom2529)
  /twomc3 = sum(cwom2529)
  /twom4  = sum(wom3034)
  /twomc4 = sum(cwom3034)
  /twom5  = sum(wom3539)
  /twomc5 = sum(cwom3539)
  /twom6  = sum(wom4044)
  /twomc6 = sum(cwom4044)
  /twom7  = sum(wom4549)
  /twomc7 = sum(cwom4549)
  /twom = sum(wom)
  /twomc = sum(cwom).

 aggregate outfile = 'tmp2.sav'
  /break   =  total
  /twom1  = sum(wom1519)
  /twomc1 = sum(cwom1519)
  /twom2  = sum(wom2024)
  /twomc2 = sum(cwom2024)
  /twom3  = sum(wom2529)
  /twomc3 = sum(cwom2529)
  /twom4  = sum(wom3034)
  /twomc4 = sum(cwom3034)
  /twom5  = sum(wom3539)
  /twomc5 = sum(cwom3539)
  /twom6  = sum(wom4044)
  /twomc6 = sum(cwom4044)
  /twom7  = sum(wom4549)
  /twomc7 = sum(cwom4549)
  /twom = sum(wom)
  /twomc = sum(cwom).

* Add this summary information together in one data file.
get file = 'tmp1.sav'.
add files
  /file = *
  /file = 'tmp2.sav'.

compute target = 90.

compute rrate1 =  twomc1/twom1*100.
variable labels rrate1 "    % interviewed (15-19)".
compute rrate2 =  twomc2/twom2*100.
variable labels rrate2 "    % interviewed (20-24)".
compute rrate3 =  twomc3/twom3*100.
variable labels rrate3 "    % interviewed (25-29)".
compute rrate4 =  twomc4/twom4*100.
variable labels rrate4 "    % interviewed (30-34)".
compute rrate5 =  twomc5/twom5*100.
variable labels rrate5 "    % interviewed (35-39)".
compute rrate6 =  twomc6/twom6*100.
variable labels rrate6 "    % interviewed (40-44)".
compute rrate7 =  twomc7/twom7*100.
variable labels rrate7 "    % interviewed (45-49)".
compute rrate =  twomc/twom*100.
variable labels rrate "    % interviewed (Total)".

compute minrrate = min (rrate1, rrate2, rrate3, rrate4, rrate5, rrate6, rrate7).
variable labels minrrate "Minimum percentage interviewed in any age group".

do if (minrrate <= target).
compute targetmet = minrrate.
end if.

variable labels targetmet "Target not met".

variable labels twom1 "No of women (15-19)".
variable labels twom2 "No of women (20-24)".
variable labels twom3 "No of women (25-29)".
variable labels twom4 "No of women (30-34)".
variable labels twom5 "No of women (35-39)".
variable labels twom6 "No of women (40-44)".
variable labels twom7 "No of women (45-49)".
variable labels twom "No of women (Total)".

ctables
  /vlabels var= total
     display = none  
  /table  total [c] + team[c] by (twom1 [s] [sum '' f5.0] + rrate1 [s] [mean '' f5.1]) +
 	twom2 [s] [sum '' f5.0] + rrate2 [s] [mean '' f5.1] +
	twom3 [s] [sum '' f5.0] + rrate3 [s] [mean '' f5.1] +
	twom4 [s] [sum '' f5.0] + rrate4 [s] [mean '' f5.1] +
	twom5 [s] [sum '' f5.0] + rrate5 [s] [mean '' f5.1] +
	twom6 [s] [sum '' f5.0] + rrate6 [s] [mean '' f5.1] +
	twom7 [s] [sum '' f5.0] + rrate7 [s] [mean '' f5.1] +
	twom [s] [sum '' f5.0] + rrate [s] [mean '' f5.1] +
	minrrate [s] [mean '' f5.1] + targetmet [s] [mean '' f5.1]
   /slabels visible = no
      /titles title=  "F4W. Age distribution of women interviewed "										
                    "Number of women age 15-49 years listed in the household schedule and proportion successfully interviewed by age group, according to interviewer team, "+ surveyname
           caption= "Target>=90".

new file.
erase file 'tmp1.sav'.
erase file 'tmp2.sav'.
erase file 'tmpwm.sav'.
