* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = "hh.sav"
  /keep hh1 hh2 team.
sort cases by hh1 hh2.
save outfile = "tmp.sav".

* Open the mm data file.
get file = 'mm.sav'.

sort cases by hh1 hh2.

match files / file = *
 /table = 'tmp.sav'
 /by hh1 hh2.

save outfile = "tmp.sav".
get file = 'tmp.sav'.

compute ttot = 1.

* All deceased sisters.
do if (MM15 = 2 and MM16 = 2).
+ compute totdead1 = 1.
+ compute missage1 = 0.
+ if (MM19 >= 97) missage1 = 100.
+ if (MM19 >= 97) cmissage1 = 1.
end if.

* Sisters who died at age 12+.
do if (MM15 = 2 and MM16 = 2 and MM19 >= 12 and MM19 < 97).
+ compute totdead2 = 1.
+ compute missage2 = 0.
+ if (MM22 >= 8 or MM23 >= 8 or MM24 >= 8) missage2 = 100.
+ if (MM22 >= 8 or MM23 >= 8 or MM24 >= 8) cmissage2 = 1.

+ compute missage3 = 0.
+ if (MM18 >= 97) missage3 = 100.
+ if (MM18 >= 97) cmissage3 = 1.
end if.

save outfile = 'tmp.sav'.

aggregate 
 /outfile = "tmp1.sav"
 /break ttot
 /targ1 = mean (missage1)
 /targ2 = mean (missage2)
 /targ3 = mean (missage3).

aggregate 
 /outfile = "tmp2.sav"
 /break team
 /targ1 = mean (missage1)
 /targ2 = mean (missage2)
 /targ3 = mean (missage3).

* Add this summary information .
get file = 'tmp.sav'.
add files
  /file = *
  /file = 'tmp1.sav'
  /file = 'tmp2.sav'.

*MICS allows less than 2 per cent missing on the age of death (column 3), 
*and no missing values on deaths during pregnancy, delivery or after delivery 
*and timing of deaths among sisters age 12 and older (columns 6 and 8). 
do if (targ1 >= 2).
+ compute target1 = targ1.
end if.

do if (targ2 > 0).
+ compute target2 = targ1.
end if.

do if (targ3 > 0).
+ compute target3 = targ3.
end if.

variable labels target1 "Target not met".
variable labels target2 "Target not met".
variable labels target3 "Target not met".

variable labels totdead1 " ".
value labels totdead1 1 "Number".
variable labels missage1 "Missing age at death: %".
variable labels cmissage1 " ".
value labels cmissage1 1 "Missing age at death: Number".

variable labels totdead2 " ".
value labels totdead2 1 "Number".
variable labels missage2 "Missing information on death during pregnancy & during delivery & after delivery: %".
variable labels cmissage2 " ".
value labels cmissage2 1 "Missing information on death during pregnancy & during delivery & after delivery: Number".

variable labels missage3 "Missing information on (years ago) of death: %".
variable labels cmissage3 " ".
value labels cmissage3 1 "Missing information on (years ago) of death: Number".

variable labels ttot "".
value labels ttot 1 "Total".

variable labels ttot "".
value labels ttot 1 "Total".

compute layer1 = 1.
variable labels layer1 " ".
value labels layer1 1 "All deceased sisters".

compute layer2 = 1.
variable labels layer2 " ".
value labels layer2 1 "Sisters who died at age 12+".

ctables
  /vlabels variables  = ttot totdead1 totdead2 layer1 layer2 cmissage1 cmissage2 cmissage3
	display = none
   /table ttot [c] + team [c] by 
    layer1 [c] > (totdead1 [c] [count,'',f5.0] + cmissage1 [c] [count,'',f5.0] + missage1 [s] [mean,'',f5.1] + target1 [s] [mean,'',f5.1]) + 
    layer2 [c] > (totdead2 [c] [count,'',f5.0] + cmissage2 [c] [count,'',f5.0] + missage2 [s] [mean,'',f5.1] + target2 [s] [mean,'',f5.1]) + 
    layer2 [c] > (cmissage3 [c] [count,'',f5.0] + missage3 [s] [mean,'',f5.1] + target3 [s] [mean,'',f5.1]) 
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title = 
   "F12.  Maternal mortality"
   	"Number of deceased sisters and number and percentage for whom age at death is missing; " +
   	"number of sisters who died at age 12 years and above and number and percentage for whom information on death during pregnancy, "+
  	"during delivery or after delivery is missing, and for whom information on timing of death (years ago) is missing, according to interviewer team, " + surveyname.	

new file.		

erase file = "tmp.sav".		
erase file = "tmp1.sav".	
erase file = "tmp2.sav".	
