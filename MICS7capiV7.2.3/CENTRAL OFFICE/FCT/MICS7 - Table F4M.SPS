* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open women data file.
get file = "mn.sav".

sort cases by mwm1 mwm2 mwm3.

save outfile = "tmpmn.sav" /keep mwm1 mwm2 mwm3 mwm17 /rename mwm1 = hh1 mwm2 = hh2 mwm3 = hl1.

get file = "hl.sav".

sort cases by hh1 hh2 hl1.

select if (hl9 <> sysmis(hl9) and hl4 = 1 and hl6>=15 and hl6<=49).

include "targets.sps".
 
match files /file=*
  /table='tmpmn.sav'
  /by hh1 hh2 hl1.

compute total = 1.
variable labels total " ".
value labels total 1 "Total".

compute men = 1.

do if (hl6 >=15 and hl6 <=19).
+ compute men1519 = 1.
end if.
do if (hl6 >=20 and hl6 <=24).
+ compute men2024 = 1.
end if.
do if (hl6 >=25 and hl6 <=29).
+ compute men2529 = 1.
end if.
do if (hl6 >=30 and hl6 <=34).
+ compute men3034 = 1.
end if.
do if (hl6 >=35 and hl6 <=39).
+ compute men3539 = 1.
end if.
do if (hl6 >=40 and hl6 <=44).
+ compute men4044 = 1.
end if.
do if (hl6 >=45 and hl6 <=49).
+ compute men4549 = 1.
end if.

compute cmen = 0.
if (MWM17 = 1) cmen = 1.

compute cmen1519 = 0.
if (MWM17 = 1 and hl6 >=15 and hl6 <=19) cmen1519 = 1.

compute cmen2024 = 0.
if (MWM17 = 1 and hl6 >=20 and hl6 <=24) cmen2024 = 1.

compute cmen2529 = 0.
if (MWM17 = 1 and hl6 >=25 and hl6 <=29) cmen2529 = 1.

compute cmen3034 = 0.
if (MWM17 = 1 and hl6 >=30 and hl6 <=34) cmen3034 = 1.

compute cmen3539 = 0.
if (MWM17 = 1 and hl6 >=35 and hl6 <=39) cmen3539 = 1.

compute cmen4044 = 0.
if (MWM17 = 1 and hl6 >=40 and hl6 <=44) cmen4044 = 1.

compute cmen4549 = 0.
if (MWM17 = 1 and hl6 >=45 and hl6 <=49) cmen4549 = 1.

compute layer = 1.
variable labels layer " ".
value labels layer 1 "Men's age (15-49 years)".

aggregate outfile = 'tmp1.sav'
  /break   = team 
  /tmen1  = sum(men1519)
  /tmenc1 = sum(cmen1519)
  /tmen2  = sum(men2024)
  /tmenc2 = sum(cmen2024)
  /tmen3  = sum(men2529)
  /tmenc3 = sum(cmen2529)
  /tmen4  = sum(men3034)
  /tmenc4 = sum(cmen3034)
  /tmen5  = sum(men3539)
  /tmenc5 = sum(cmen3539)
  /tmen6  = sum(men4044)
  /tmenc6 = sum(cmen4044)
  /tmen7  = sum(men4549)
  /tmenc7 = sum(cmen4549)
  /tmen = sum(men)
  /tmenc = sum(cmen).

 aggregate outfile = 'tmp2.sav'
  /break   =  total
  /tmen1  = sum(men1519)
  /tmenc1 = sum(cmen1519)
  /tmen2  = sum(men2024)
  /tmenc2 = sum(cmen2024)
  /tmen3  = sum(men2529)
  /tmenc3 = sum(cmen2529)
  /tmen4  = sum(men3034)
  /tmenc4 = sum(cmen3034)
  /tmen5  = sum(men3539)
  /tmenc5 = sum(cmen3539)
  /tmen6  = sum(men4044)
  /tmenc6 = sum(cmen4044)
  /tmen7  = sum(men4549)
  /tmenc7 = sum(cmen4549)
  /tmen = sum(men)
  /tmenc = sum(cmen).

* Add this summary information together in one data file.
get file = 'tmp1.sav'.
add files
  /file = *
  /file = 'tmp2.sav'.

compute target = 90.

compute rrate1 =  tmenc1/tmen1*100.
variable labels rrate1 "    % interviewed (15-19)".
compute rrate2 =  tmenc2/tmen2*100.
variable labels rrate2 "    % interviewed (20-24)".
compute rrate3 =  tmenc3/tmen3*100.
variable labels rrate3 "    % interviewed (25-29)".
compute rrate4 =  tmenc4/tmen4*100.
variable labels rrate4 "    % interviewed (30-34)".
compute rrate5 =  tmenc5/tmen5*100.
variable labels rrate5 "    % interviewed (35-39)".
compute rrate6 =  tmenc6/tmen6*100.
variable labels rrate6 "    % interviewed (40-44)".
compute rrate7 =  tmenc7/tmen7*100.
variable labels rrate7 "    % interviewed (45-49)".
compute rrate =  tmenc/tmen*100.
variable labels rrate "    % interviewed (Total)".

compute minrrate = min (rrate1, rrate2, rrate3, rrate4, rrate5, rrate6, rrate7).
variable labels minrrate "Minimum percentage interviewed in any age group".

do if (minrrate <= target).
compute targetmet = minrrate.
end if.

variable labels targetmet "Target not met".

variable labels tmen1 "No of men (15-19)".
variable labels tmen2 "No of men (20-24)".
variable labels tmen3 "No of men (25-29)".
variable labels tmen4 "No of men (30-34)".
variable labels tmen5 "No of men (35-39)".
variable labels tmen6 "No of men (40-44)".
variable labels tmen7 "No of men (45-49)".
variable labels tmen "No of men (Total)".

ctables
  /vlabels var= total
     display = none  
  /table  total [c] + team[c] by (tmen1 [s] [sum '' f5.0] + rrate1 [s] [mean '' f5.1]) +
 	tmen2 [s] [sum '' f5.0] + rrate2 [s] [mean '' f5.1] +
	tmen3 [s] [sum '' f5.0] + rrate3 [s] [mean '' f5.1] +
	tmen4 [s] [sum '' f5.0] + rrate4 [s] [mean '' f5.1] +
	tmen5 [s] [sum '' f5.0] + rrate5 [s] [mean '' f5.1] +
	tmen6 [s] [sum '' f5.0] + rrate6 [s] [mean '' f5.1] +
	tmen7 [s] [sum '' f5.0] + rrate7 [s] [mean '' f5.1] +
	tmen [s] [sum '' f5.0] + rrate [s] [mean '' f5.1] +
	minrrate [s] [mean '' f5.1] + targetmet [s] [mean '' f5.1]
  /slabels visible = no
  /titles title=  "F4M. Age distribution of men interviewed "										
                    "Number of men age 15-49 years listed in the household schedule and proportion successfully interviewed by age group, according to interviewer team, "+ surveyname.								

new file.
erase file 'tmp1.sav'.
erase file 'tmp2.sav'.
erase file 'tmpmn.sav'.
