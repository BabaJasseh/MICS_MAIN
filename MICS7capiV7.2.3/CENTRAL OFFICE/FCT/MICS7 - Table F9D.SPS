* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = "hh.sav".

sort cases by hh1 hh2.

include "targets.sps".
 
save outfile = "tmphh.sav" /keep hh1 hh2 team /rename hh1 = fs1 hh2 = fs2.

* Open the children data file.
get file = 'fs.sav'.

sort cases by fs1 sf2.

match files / file = *
 /table = 'tmphh.sav'
 /by fs1 sf2.

select if (FS17 = 1).


compute tot = 1.
value labels tot 1 " " .
variable labels tot "Total" .

* Take into account only collected measurments.

do if (FA8 < 99.3).  

+ compute wend0 = 0.
+ if (mod (FA8*10, 10) = 0) wend0 = 100.

+ compute wend5 = 0.
+ if (mod (FA8*10, 10) = 5) wend5 = 100.

+ compute wheap = (wend0 + wend5) / 20.

end if.

do if (FA11 < 999.3).

+ compute hend0 = 0.
+ if (mod (FA11*10, 10) = 0) hend0 = 100.

+ compute hend5 = 0.
+ if (mod (FA11*10, 10) = 5) hend5 = 100.

+ compute hheap = (hend0 + hend5) / 20.

end if.

save outfile = 'tmp.sav'.

aggregate 
  /outfile = "tmp1.sav"
  /break = team
  /hteamt = mean (hheap)
  /wteamt = mean (wheap).

aggregate 
  /outfile = "tmp2.sav"
  /break = tot
  /hteamt = mean (hheap)
  /wteamt = mean (wheap).

* Add this summary information .
get file = 'tmp.sav'.
add files
  /file = *
  /file = 'tmp1.sav'
  /file = 'tmp2.sav'.

* target should be set to 1.5 for both hight and weight, as per definition when the ratio is above 1.5, there is an unexpected excess for zero or five. 
do if (hteamt > 1.5).
+ compute targeth = hteamt.
end if.

do if (wteamt > 1.5).
+ compute targetw = wteamt.
end if.

* to calculate correct number of children exclude temporarily generated cases needed for calculation of target reached.
do if (sysmis (hteamt) and FA11 < 999.3).
+ compute cnh = 1.
end if.

do if (sysmis (wteamt) and FA8 < 99.3).
+ compute cnw = 1.
end if.

variable labels targetw "Target not met".
variable labels targeth "Target not met".

variable labels cnh  "Number of children age 5-9 years with height measurement".
variable labels cnw  "Number of children age 5-9 years with weight measurement ".

variable labels wend0 '0'.
variable labels hend0 '0'.
variable labels wend5 '5'.           
variable labels hend5 '5'.                          
variable labels wheap 'Heaping ratio'.           
variable labels hheap 'Heaping ratio'.  

compute wlayer = 1.
value labels wlayer 1 "Weight measurements".

compute hlayer = 1.
value labels hlayer 1 "Height measurements".

compute layer = 1.
value labels layer 1 "Percent reported with digit".

ctables
    /vlabels variables= wlayer hlayer layer display=none
    /table tot [c] + team [c] by 
    wlayer[c] > ( layer[c] > (wend0 [s] [mean '' f5.1] + wend5 [s] [mean '' f5.1]) + wheap [s] [mean '' f5.1]) + targetw [s] [mean '' f5.1] + cnw [s] [sum '' f7.0] + 
    hlayer [c] > ( layer[c] > (hend0 [s] [mean '' f5.1] + hend5 [s] [mean '' f5.1]) + hheap [s] [mean '' f5.1]) + targeth [s] [mean '' f5.1] + cnh [s] [sum '' f7.0] 
   /categories variables=all empty=exclude missing=exclude
   /slabels position=column visible = no
   /titles title = 
   "F9D. Heaping in anthropometric measurements (age 5-9)"
   "Percentage of weight and height/length measurements by digits reported with 0 and 5 among measured children age 5-9 years, " + surveyname.		

new file.

erase file = "tmphh.sav".	
erase file = "tmp.sav".		
erase file = "tmp1.sav".	
erase file = "tmp2.sav".	

