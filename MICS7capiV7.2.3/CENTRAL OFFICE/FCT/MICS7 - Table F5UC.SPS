* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = "hh.sav"
  /keep hh1 hh2 hh4.
sort cases by hh1 hh2.
save outfile = "tmp.sav".

* Open the household listing data.
get file = "hl.sav".
sort cases by hh1 hh2.

match files / file = *
 /table = 'tmp.sav'
 /by hh1 hh2.

* Encoding: windows-1252.
include "surveyname.sps".

get file = "hh.sav".

sort cases by hh1 hh2.

include "targets.sps".
 
save outfile = "tmp.sav" /keep hh1 hh2 team target5u target5c.

* Open household listing data file.
get file = "hl.sav".

sort cases by hh1 hh2.

match files /file=*
  /table='tmp.sav'
  /by hh1 hh2.

select if (HL6 >= 0 and HL6 <= 9).

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

compute cch = 1.

compute cch0= 0.
compute cch1= 0.
compute cch2= 0.
compute cch3= 0.
compute cch4= 0.
compute cch5= 0.
compute cch6= 0.
compute cch7= 0.
compute cch8= 0.
compute cch9= 0.

if (HL6 = 0) cch0 = 1.
if (HL6 = 1) cch1 = 1.
if (HL6 = 2) cch2 = 1.
if (HL6 = 3) cch3 = 1.
if (HL6 = 4) cch4 = 1.
if (HL6 = 5) cch5 = 1.
if (HL6 = 6) cch6 = 1.
if (HL6 = 7) cch7 = 1.
if (HL6 = 8) cch8 = 1.
if (HL6 = 9) cch9 = 1.

aggregate outfile = 'tmp1.sav'
  /break   = team 
  /cch  = sum(cch)
  /cch0 = sum(cch0)
  /cch1 = sum(cch1)
  /cch2 = sum(cch2)
  /cch3 = sum(cch3)
  /cch4 = sum(cch4)
  /cch5 = sum(cch5)
  /cch6 = sum(cch6)
  /cch7 = sum(cch7)
  /cch8 = sum(cch8)
  /cch9 = sum(cch9)
  /targetu = mean(target5u)
  /targetc = mean(target5c).

aggregate outfile = 'tmp2.sav'
  /break   =  total
  /cch  = sum(cch)
  /cch0 = sum(cch0)
  /cch1 = sum(cch1)
  /cch2 = sum(cch2)
  /cch3 = sum(cch3)
  /cch4 = sum(cch4)
  /cch5 = sum(cch5)
  /cch6 = sum(cch6)
  /cch7 = sum(cch7)
  /cch8 = sum(cch8)
  /cch9 = sum(cch9)
  /targetu = mean(target5u)
  /targetc = mean(target5c).

* Add this summary information together in one data file.
get file = 'tmp1.sav'.
add files
  /file = *
  /file = 'tmp2.sav'.

variable labels cch0 "0".
variable labels cch1 "1".
variable labels cch2 "2".
variable labels cch3 "3".
variable labels cch4 "4".
variable labels cch5 "5".
variable labels cch6 "6".
variable labels cch7 "7".
variable labels cch8 "8".
variable labels cch9 "9".
variable labels cch "Total". 

compute ratioc =  cch4/cch5.
variable labels ratioc "Age ratio (4/5)".

compute ratiocu =  cch7/cch6.
variable labels ratiocu "Age ratio (7/6)".

do if (ratioc <= targetu).
compute targetmet = ratioc.
end if.

do if (ratiocu <= targetc).
compute targetmetcu = ratiocu.
end if.

variable labels targetmet "Target not met".
variable labels targetmetcu "Target not met".

compute layer = 0.
value labels layer 0 "Children's age (0 - 9 years)" .


ctables
 /vlabels variables = layer display =  none  
 /table   total [c] + team [c] by
           layer[c] > 
	(cch0 [s] [sum f5.0] + 
	cch1 [s] [sum f5.0] + 
	cch2 [s] [sum f5.0] +
	cch3 [s] [sum f5.0] + 
	cch4 [s] [sum f5.0] + 
	cch5 [s] [sum f5.0] + 
	cch6 [s] [sum f5.0] + 
	cch7 [s] [sum f5.0] + 
	cch8 [s] [sum f5.0] + 
	cch9 [s] [sum f5.0]) + 
	cch [s] [sum f5.0] +
	ratioc [s] [sum f5.1] + 
	targetmet [s] [sum f5.1] +
	ratiocu [s] [sum f5.1] + 
	targetmetcu [s] [sum f5.1] 
  /slabels position=column visible =no
  /titles title=  "F5UC: Age displacement: young children "										
                    "Number of children age 0-9 years listed in the household schedule by single year of age and age ratios 4/5 and 7/6, according to interviewer team, "+ surveyname
           caption='Target: Age ratio for 4 to 5 year old <=  0.8 and for 7 to 6 year old  <= 0.8'.

new file.
erase file 'tmp.sav'.
erase file 'tmp1.sav'.
erase file 'tmp2.sav'.
