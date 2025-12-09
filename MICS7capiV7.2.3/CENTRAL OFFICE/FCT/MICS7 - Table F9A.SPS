* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = "hh.sav".

sort cases by hh1 hh2.

include "targets.sps".
 
save outfile = "tmphh.sav" /keep hh1 hh2 team /rename hh1 = uf1 hh2 = uf2.

* Open the children data file.
get file = 'ch.sav'.

sort cases by uf1 uf2.

match files / file = *
 /table = 'tmphh.sav'
 /by uf1 uf2.

select if (UF17 = 1).

compute measured = 9.
if (AN8 < 99 and AN11 < 999) measured = 1.
if (AN8 = 99.3) measured = 2.
if (AN8 = 99.4 or AN8 = 99.5) measured = 3.
if (AN8 = 99.6) measured = 6.

variable labels measured "Result of height and weight measurement".
value labels measured 1 "Either or both measure" 2 "Child not present" 3 "Child or mother/caretaker refused" 6 "Other" 9 "Missing".

compute layer1 = 1.
value labels layer1 1 "Result of height and weight measurement" .

compute layer2 = 1.
value labels layer2 1 "Among children measured" .

compute tot1 = 1.
value labels tot1 1 " " .
variable labels tot1 "Total" .

compute tot2 = 1.
value labels tot2 1 " " .
variable labels tot2 " Number of children age 0-4" .

* select only children measured.
do if (measured= 1).

 compute Houtofr=0.
 if (HAZFLAG <> 0) Houtofr=100.
 variable labels Houtofr "Height out of range (%)".

compute hairinterference = 0.
if (AN13 = 1) hairinterference = 100.
variable labels hairinterference "Hair interference (%)".

compute Woutofr=0.
if (WAZFLAG <> 0) Woutofr=100.
variable labels Woutofr "Weight out of range (%)".

compute clothinterference = 0.
if (AN9 = 2) clothinterference = 100.
variable labels clothinterference "Clothing interference (%)".

compute WHoutofr=0.
if (WHZFLAG <> 0) WHoutofr=100.
variable labels WHoutofr "Weight for height out of range (%)".

compute chdmyb = 0.
if (not (UB1M < 97 and UB1Y < 9997)) chdmyb = 100.  
variable labels chdmyb "Date of birth incomplete (%)".

end if.

ctables
  /vlabels variables = layer1 layer2 an2 measured display = none
  /table  tot1 [c] + team [c] by 
	layer1 [c] > measured [c] [rowpct.validn '' f5.1] +
		tot2 [s]  [sum '' f7.0]+
   	layer2 [c] > (Houtofr [s] [mean '' f5.1] + hairinterference [s] [mean '' f5.1] + Woutofr [s] [mean '' f5.1] + clothinterference [s] [mean '' f5.1] + WHoutofr [s] [mean '' f5.1] + 
	chdmyb [s] [mean '' f5.1]) 
  /categories variables=measured empty=include missing=include total=yes label="Total"
  /slabels position=column visible = no
  /titles title = 
   "F9A. Height and weight of children (age 0-4)"
   "Percent distribution of children under 5 by result of height and weight measurement,  " +
    "and percentage of children measured who have out of range values, interference, or incomplete date of birth, according to interviewer team, " + surveyname.

new file.		

erase file = "tmphh.sav".		
