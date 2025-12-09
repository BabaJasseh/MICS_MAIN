* Encoding: UTF-8.
* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = "hh.sav".

sort cases by hh1 hh2.

include "targets.sps".
 
save outfile = "tmphh.sav" /keep hh1 hh2 team target10 /rename hh1 = wm1 hh2 = wm2.

* open women data file.
get file = 'wm.sav'.
* sort cases by cluster and household number.  
sort cases by wm1 wm2.

* add team number to women file.
match files / file = *
 /table = 'tmphh.sav'
 /by wm1 wm2.

select if (WM17 = 1).

compute total = 1.

aggregate outfile = 'tmp1.sav'
  /break   = team 
  /tceb  = sum (CEB)
  /tcsurv  = sum (CSURV)
  /tcdead = sum (CDEAD)
  /tot = sum (total)
  /target10 = mean (target10).
variable labels ceb "Total number of children ever born (2)".

aggregate outfile = 'tmp2.sav'
  /break   = total
  /tceb  = sum (CEB)
  /tcsurv  = sum (CSURV)
  /tcdead = sum (CDEAD)
  /tot = sum (total)
  /target10 = mean (target10).

get file = 'tmp1.sav'.
add files
  /file = *
  /file = 'tmp2.sav'.

compute ratioall =  tceb/tot.

compute ratioliv =  tcsurv/tot.

compute ratiodead =  tcdead/tot.

do if (ratioall < target10).
+ compute target = ratioall.
end if.		

variable labels ratioall "Mean number of children ever born".
variable labels ratioliv "Mean number of living children".
variable labels ratiodead "Mean number of deceased children".
variable labels tceb "Total number of children ever born".
variable labels tcsurv "Total number of living children".
variable labels tcdead "Total number of deceased children".
variable labels tot  "Number of women with completed interview".
value labels total 1 "Total".

variable labels target "Target not met".

ctables
  /vlabels variables = total display = none
  /table total [c] + team [c]  by 
	tot [s] [sum '' f5.0] + 
	tcsurv [s] [sum '' f5.0] +  ratioliv [s] [sum f5.1] +
	tcdead [s] [sum '' f5.0] +  ratiodead [s] [sum f5.1] +
	tceb [s] [sum '' f5.0] +  ratioall [s] [sum f5.1] +
	target [s] [sum f5.1] 
  /categories variables=all empty=exclude missing=exclude
    /slabels visible = no  
  /titles title="F10. Children ever born and children surviving"  
	"Number of women with completed interview, total number of children ever born (CEB), and mean number of CEB, according to interviewer team " + surveyname
           caption='Target: CEB in previous survey: 1.51 thus Target = 1.51 * 0.75 = 1.13.'.

new file.
erase file 'tmphh.sav'.
erase file 'tmp1.sav'.
erase file 'tmp2.sav'.