* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = "hh.sav".

sort cases by hh1 hh2.

include "targets.sps".
 
save outfile = "tmphh.sav" /keep hh1 hh2 team /rename hh1 = wm1 hh2 = wm2.

* add year of interview of a women.
get file = "wm.sav"
  /keep wm1 wm2 wm3 wm6y.
sort cases by wm1 wm2 wm3.
save outfile = "tmp2.sav".

* Open the birth history data file.
get file = 'bh.sav'.

sort cases by wm1 wm2 wm3.

match files / file = *
 /table = 'tmphh.sav'
 /by  wm1 wm2.

match files / file = *
 /table = 'tmp2.sav'
 /by wm1 wm2 wm3.

save outfile = "tmp.sav".

get file = 'tmp.sav'.

compute ttot = 1.
value labels ttot 1 " ".
variable labels ttot "Total".

*deaths in the last 15 years.
select if  (BH4Y>=9997 or BH4Y>= WM6Y - 15).

*if deaths in the last 15 years.
do if (BH5 = 2).

* compute age at death in months for children who died.
+compute ageatdth = 0.
+if (BH9U = 1) ageatdth = trunc(BH9N*12/365).
+if (BH9U = 2) ageatdth = BH9N.
+if (BH9U = 3) ageatdth = BH9N*12.
+if (BH9U = 9 or BH9N = 99) ageatdth = 99.

+recode ageatdth (1 thru 11 = 2) (12 thru 97 = 3) (99 = 9) (else = 1) into aged.

+compute neon = 0.
+if (aged = 1) neon = 1.

+compute infant = 0.
+if (aged = 1 or aged = 2) infant = 1.

+compute deadc = 1.
end if.

variable labels aged "Age at death in months for children who died".
value labels aged
1 "< 1 month"
2 "1-11 months"
3 "12+ months"
9 "Missing".

variable labels deadc "Total dead".

* still alive.
do if (BH5 = 1).
+ compute survc = 1.
end if.

variable labels survc "Still alive".

compute tceb = 1.
variable labels tceb "Total births".

save outfile = "tmp.sav".

aggregate 
  /outfile = 'tmp4.sav'
  /break = team
  /tneon = sum (neon)
  /tinfant = sum (infant)
  /ttceb = sum (tceb).

aggregate 
  /outfile = 'tmp5.sav'
  /break = ttot
  /tneon = sum (neon)
  /tinfant = sum (infant)
  /ttceb = sum (tceb).

* Add this summary information .
get file = 'tmp.sav'.
add files
  /file = *
  /file = 'tmp4.sav'
  /file = 'tmp5.sav'.

save outfile = "tmp.sav".

do if (not(sysmis (ttceb))).
+ compute ratio1 = tneon / tinfant.
+ compute ratio2 = tinfant / ttceb *1000.
end if.
variable labels ratio1 "Ratio of neonatal to infant".
variable labels ratio2 "Infant deaths to total births (per thousand)".

* to calculate correct number of children exclude temporarily generated cases needed for calculation of target reached.
do if (sysmis (ttceb)).
+ compute cn = 1.
end if.

ctables
   /table ttot [c] + team [c] by 
    aged [c] [count '' f5.0] + deadc [s] [sum '' f5.0]  + survc [s] [sum '' f5.0]  + tceb [s] [sum '' f5.0]  + ratio1 [s] [mean '' f5.2] + ratio2 [s] [mean '' f5.2]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title = 
   "F11E. Birth histories: Child mortality"
   "Number of births in the last 15 years by survival status and age at death (for those who died), " +
   "the ratio of neonatal deaths (<1 month) to all infant deaths (<12 months),  "+
   "and the ratio of infant deaths to all births, according to interviewer team, " + surveyname.																	

new file.		

erase file = "tmp.sav".		
erase file = "tmphh.sav".	
erase file = "tmp2.sav".			
erase file = "tmp4.sav".		
erase file = "tmp5.sav".	
