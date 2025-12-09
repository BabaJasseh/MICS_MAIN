* Encoding: UTF-8.

cd "C:\MICS7\!!MICS7 STANDARD\Standard MICS7 CAPI\MICS7capiV7.3.1\CENTRAL OFFICE\FCT".
set decimal=dot.
 
/****************************** HOUSEHOLD*************************************.
insert file = "MYHH.SPS".
sort cases by hh1 hh2.
compute filter=0.
if hh1=lag(hh1) and hh2=lag(hh2) filter=1.
select if filter=0.
save outfile = "hh.sav".

*----------- For PowerBI-----------.
compute hhweight=1.
value labels hh6 1 "Urban" 2 "Rural".
SAVE TRANSLATE OUTFILE='HH.xlsx' /FIELDNAMES   /TYPE=XLS /VERSION=12 /replace
/EXCELOPTIONS SHEET='Rawdata'
/keep hh1 hh2 hh4 hh5d hh5m hh5y hh6 hh7 hh11m hh11h hh13m hh13h hh46 hh48 hh49 hh51 hh52 hhweight HH3.

new file.

insert file = "MYHL.SPS".
sort cases by hh1 hh2 HL1.
compute filter=0.
if hh1=lag(hh1) and hh2=lag(hh2) and HL1=lag(HL1) filter=1.
select if filter=0.
select if not sysmis(HL1).
save outfile = "hl.sav".

*----------- For PowerBI-----------.
compute hhweight=1.
value labels hh6 1 "Urban" 2 "Rural".
RENAME VARIABLES (HL1=LN).
SAVE TRANSLATE OUTFILE='HL.xlsx' /FIELDNAMES   /TYPE=XLS /VERSION=12 /replace
/EXCELOPTIONS SHEET='HL'
/keep hh1 hh2 LN HL4 HL20 HL6 HL12 HL14 hh6 hh7 hhweight hh5d hh5m hh5y HH3 HH4.

new file.

/****************************** WOMEN *************************************.
insert file = "MYWM.SPS".
select if wm17<>97.  /* discard temporary records of delegated questionnaires */.
sort cases by hh1 hh2 wm3.
compute filter=0.
if hh1=lag(hh1) and hh2=lag(hh2) and wm3=lag(wm3) filter=1.
select if filter=0.
save outfile = "wm.sav".

*----------- For PowerBI-----------.
compute wmweight=1.
value labels hh6 1 "Urban" 2 "Rural".
SAVE TRANSLATE OUTFILE='WM.xlsx' /FIELDNAMES   /TYPE=XLS /VERSION=12 /replace
/EXCELOPTIONS SHEET='Rawdata'
/keep hh1 hh2 LN wm4 wm6d wm6m wm6y hh6 hh7 wm7m wm7h wm10m wm10h wm17 
     ma8m ma8y ma11 ma11c
     wmweight wdob wdoi WMINT.
new file.

************* birth history ***************.
insert file = "MYBH.SPS".
sort cases by wm1 wm2 wm3 BH0.
compute filter=0.
if wm1=lag(wm1) and wm2=lag(wm2) and wm3=lag(wm3) and BH0=lag(BH0) filter=1.
select if filter=0.  
save outfile = "bh.sav".


*----------- For PowerBI-----------.
compute wmweight=1.
value labels hh6 1 "Urban" 2 "Rural".
SAVE TRANSLATE OUTFILE='BH.xlsx' /FIELDNAMES   /TYPE=XLS /VERSION=12 /replace
/EXCELOPTIONS SHEET='Rawdata'
/keep HH1 HH2 LN BH0 BH2 BH3 BH4D BH4M BH4Y BH5 BH6 BH4C BH8 BH9C HH6 HH7 WDOI WDOB WMWEIGHT, 
     wm6d, wm6m, wm6y, WMINT HH4 /* hh4=SUPERVISOR*/.

new file.


************ woman time use ****************.
insert file = "MYWTU.SPS".
sort cases by wm1 wm2 wm3 TU6.
compute filter=0.
if wm1=lag(wm1) and wm2=lag(wm2) and wm3=lag(wm3) and TU6=lag(TU6) filter=1.
select if filter=0.  
save outfile = "wtu.sav".


/****************************** UNDER 5 *************************************.
insert file = "MYCH.SPS".
select if uf17<>97.  /* discard temporary records of delegated questionnaires */.
sort cases by hh1 hh2 uf3.
compute filter=0.
if hh1=lag(hh1) and hh2=lag(hh2) and uf3=lag(uf3) filter=1.
select if filter=0. 
save outfile = "ch.sav".

*----------- For PowerBI-----------.
compute chweight=1.
value labels hh6 1 "Urban" 2 "Rural".
SAVE TRANSLATE OUTFILE='CH.xlsx' /FIELDNAMES   /TYPE=XLS /VERSION=12 /replace
/EXCELOPTIONS SHEET='Rawdata'
/keep hh1 hh2 LN uf6 uf7d uf7m uf7y hh6 hh7 uf8m uf8h uf11m uf11h uf17 chweight UFINT  
     AN8 AN9 AN11 AN12 AN14D AN14M AN14Y HAZFLAG WAZFLAG WHZFLAG.

new file.

/****************************** 5-17 *************************************.
insert file = "MYFS.SPS".
select if fs17<>97.  /* discard temporary records of delegated questionnaires */.
sort cases by hh1 hh2 fs3.
compute filter=0.
if hh1=lag(hh1) and hh2=lag(hh2) and fs3=lag(fs3) filter=1.
select if filter=0.
save outfile = "fs.sav".

*----------- For PowerBI-----------.
compute fsweight=1.
value labels hh6 1 "Urban" 2 "Rural".
SAVE TRANSLATE OUTFILE='FS.xlsx' /FIELDNAMES   /TYPE=XLS /VERSION=12 /replace
/EXCELOPTIONS SHEET='Rawdata'
/keep hh1 hh2 LN fs6 fs7d fs7m fs7y hh6 hh7 fs8m fs8h fs11m fs11h fs17 fsweight FSINT.

new file.

************ fs time use ****************.
insert file = "MYFTU.SPS".
sort cases by fs1 fs2 fs3 FTU6.
compute filter=0.
if fs1=lag(fs1) and fs2=lag(fs2) and fs3=lag(fs3) and FTU6=lag(FTU6) filter=1.
select if filter=0.  
save outfile = "ftu.sav".

/****************************** MEN *************************************.
insert file = "MYMN.SPS".
select if mwm17<>97.  /* discard temporary records of delegated questionnaires */.
sort cases by hh1 hh2 mwm3.
compute filter=0.
if hh1=lag(hh1) and hh2=lag(hh2) and mwm3=lag(mwm3) filter=1.
select if filter=0.
save outfile = "mn.sav".

*----------- For PowerBI-----------.
compute mwmweight=1.
value labels hh6 1 "Urban" 2 "Rural".
SAVE TRANSLATE OUTFILE='MN.xlsx' /FIELDNAMES   /TYPE=XLS /VERSION=12 /replace
/EXCELOPTIONS SHEET='Rawdata'
/keep hh1 hh2 LN mwm4 mwm6d mwm6m mwm6y hh6 hh7 mwm7m mwm7h mwm10m mwm10h mwm17 
     mma8m mma8y mma11 mma11c
     mwmweight mwdob mwdoi mWMINT.
new file.

************ man time use ****************.
insert file = "MYMTU.SPS".
sort cases by mwm1 mwm2 mwm3 mTU6.
compute filter=0.
if mwm1=lag(mwm1) and mwm2=lag(mwm2) and mwm3=lag(mwm3) and MTU6=lag(MTU6) filter=1.
select if filter=0.  
save outfile = "mtu.sav".


/*********** tabulation section *********************.
erase file='MICS7 - 00 - Fct.xlsx'.								   
* Generate all FCT at one goal.
* Make sure to comment out any table/syntax not relevant to your survey.

set tnumbers = labels /tvars = labels /ovars = labels.

 * oms
 /destination viewer = no
 /select all except = tables.
 * output close *.

* macro to save the output as the sheet in appropriate workbook.
define saveSheet(!positional !tokens(1))
!let !n = !unquote(!1) .
!let !sheet = !quote(!tail(!tail(!n))) .
!if (!substr(!n,1,2)="DQ") !then .
!let !sheet = !1 . 
!ifend .
!if (!substr(!n,1,2)="SE") !then .
!let !sheet = !quote(!substr(!n,4))
!ifend .
output export 
 /xlsx documentfile = !quote(!concat("MICS7 - ",!substr(!n,1,!index(!n,".")),"xlsx"))
      sheet=!sheet
      operation=MODIFYSHEET
 /contents export = visible  .
output close * .
!enddefine .

* Performance overview.
insert file = "MICS7 - Performance.sps".
saveSheet                 '00 - Fct.PERF' .
* F1. Household response rate.
insert file = "MICS7 - Table F1.SPS".
saveSheet                 '00 - Fct.F1' .
* F2W. Eligible women per household.
insert file = "MICS7 - Table F2W.SPS".
saveSheet                 '00 - Fct.F2W' .
* F2M. Eligible men per household.
insert file = "MICS7 - Table F2M.SPS".
saveSheet                 '00 - Fct.F2M' .
* F2C. Eligible children under 5 per household.
insert file = "MICS7 - Table F2UC.SPS".
saveSheet                 '00 - Fct.F2UC' .

* F3W. Response rate: Eligible women.
insert file = "MICS7 - Table F3W.SPS".
saveSheet                 '00 - Fct.F3W' .
* F3M. Response rate: Eligible men.
insert file = "MICS7 - Table F3M.SPS".
saveSheet                 '00 - Fct.F3M'.
* F3U. Response rate: Eligible children.
insert file = "MICS7 - Table F3U.SPS".
saveSheet                 '00 - Fct.F3U' .
* F3C. Response rate: Eligible children.
insert file = "MICS7 - Table F3C.SPS".
saveSheet                 '00 - Fct.F3C' .
* F3C2. Response rate: Eligible children.
insert file = "MICS7 - Table F3C2.SPS". 
saveSheet                 '00 - Fct.F3C2' .
* F3Q. Response rate: Water quality test.
 insert file = "MICS7 - Table F3Q.SPS".
 saveSheet                 '00 - Fct.F3Q' .

* F4W. Age distribution of women interviewed.
insert file = "MICS7 - Table F4W.SPS".
saveSheet                 '00 - Fct.F4W' .
* F4M. Age distribution of men interviewed.
insert file = "MICS7 - Table F4M.SPS".
saveSheet                 '00 - Fct.F4M' .

* F5W. Age displacement: women.
insert file = "MICS7 - Table F5W.SPS".
saveSheet                 '00 - Fct.F5W' .
* F5M. Age displacement: men.
insert file = "MICS7 - Table F5M.SPS".
saveSheet                 '00 - Fct.F5M' .
* F5UC. Age displacement: Age displacement: young children.
insert file = "MICS7 - Table F5UC.SPS".
saveSheet                 '00 - Fct.F5UC' .


* F6W. Birth date reporting: women.
insert file = "MICS7 - Table F6W.SPS".
saveSheet                 '00 - Fct.F6W' .
* F6W2. Birth date reporting: women.
insert file = "MICS7 - Table F6W2.SPS".
saveSheet                 '00 - Fct.F6W2' .
* F6M. Birth date reporting: men.
insert file = "MICS7 - Table F6M.SPS".
saveSheet                 '00 - Fct.F6M' .
* F6C. Birth date reporting: children under 5.
insert file = "MICS7 - Table F6U.SPS".
saveSheet                 '00 - Fct.F6U' .
* F6C. Birth date reporting: Children, adolescents and young people.
insert file = "MICS7 - Table F6C.SPS".
saveSheet                 '00 - Fct.F6C' .
* F6B. Birth date reporting: First and last births. ONLY FOR NON BH.
insert file = "MICS7 - Table F6B.SPS".
saveSheet                 '00 - Fct.F6B' .


* F7W. Question responses by team: Women's questionnaire.
insert file = "MICS7 - Table F7W.SPS".
saveSheet                 '00 - Fct.F7W' .
* F7M. Question responses by team: Men's questionnaire.
insert file = "MICS7 - Table F7M.SPS".
saveSheet                 '00 - Fct.7M' .
* F7U. Question responses by team: Under-5 questionnaire.
insert file = "MICS7 - Table F7U.SPS".
saveSheet                 '00 - Fct.F7U' .
* F7C. Question responses by team: 5-17 questionnaire.
insert file = "MICS7 - Table F7C.SPS".
saveSheet                 '00 - Fct.F7C' .

* F8A: Observation of birth certificates.
insert file = "MICS7 - Table F8A.SPS".
saveSheet                 '00 - Fct.F8A' .
* F8B. Observation of vaccination cards.
insert file = "MICS7 - Table F8B.SPS".
saveSheet                 '00 - Fct.F8B' .
* F8C. Observation of women's health cards.
insert file = "MICS7 - Table F8C.SPS".
saveSheet                 '00 - Fct.F8C' .
* F8D. Observation of bednets.
insert file = "MICS7 - Table F8D.SPS".
saveSheet                 '00 - Fct.F8D' .
* F8E. Observation of places for hand washing.
insert file = "MICS7 - Table F8E.SPS".
saveSheet                 '00 - Fct.F8E' .
* F8Q. Observation and collection of water quality samples.
insert file = "MICS7 - Table F8Q.SPS".
saveSheet                 '00 - Fct.F8Q' .

* F9A. Height and weight of children age 0-4.
insert file = "MICS7 - Table F9A.SPS".
saveSheet                 '00 - Fct.F9A' .
* F9B. Heaping in anthropometric measurements - children age 0-4.
insert file = "MICS7 - Table F9B.SPS".
saveSheet                 '00 - Fct.F9B' .
* F9C. Height and weight of children age 5-=9.
insert file = "MICS7 - Table F9C.SPS".
saveSheet                 '00 - Fct.F9C' .
* F9D. Heaping in anthropometric measurements - children age 5-9.
insert file = "MICS7 - Table F9D.SPS".
saveSheet                 '00 - Fct.F9D' .

* F10. Children ever born and children surviving.
insert file = "MICS7 - Table F10.SPS".
saveSheet                 '00 - Fct.F10' .

* F11A. Birth histories: Birth date reporting for living children.
insert file = "MICS7 - Table F11A.SPS".
saveSheet                 '00 - Fct.F11A' .
* F11B. Birth histories: Birth date reporting for deceased children.
insert file = "MICS7 - Table F11B.SPS".
saveSheet                 '00 - Fct.F11B' .
* F11C. Birth histories: Birth displacement.
insert file = "MICS7 - Table F11C.SPS".
saveSheet                 '00 - Fct.F11C' .
* F11D. Birth histories: Age at death heaping.
insert file = "MICS7 - Table F11D.SPS".
saveSheet                 '00 - Fct.F11D' .
* F11E. Birth histories: Child mortality.
insert file = "MICS7 - Table F11E.SPS".
saveSheet                 '00 - Fct.F11E' .

* F12.  Maternal mortality.
insert file = "MICS7 - Table F12.SPS".
saveSheet                 '00 - Fct.F12' .

* F13AW.  Mental health - Privacy - Women.
insert file = "MICS7 - Table F13AW.SPS".
saveSheet                 '00 - Fct.F13AW' .
* F13AM.  Mental health - Privacy - Men.
insert file = "MICS7 - Table F13AM.SPS".
saveSheet                 '00 - Fct.F13AM' .
* F13B.  Violence Against Women - Privacy.
insert file = "MICS7 - Table F13B.SPS".
saveSheet                 '00 - Fct.F13B' .

* F14.  Food Insecurity.
insert file = "MICS7 - Table F14.SPS".
saveSheet                 '00 - Fct.F14' .

* F20.  MICS Plus consent.
insert file = "MICS7 - Table F20.SPS".
saveSheet                 '00 - Fct.F20' .
									   
* Close the output.
output close *.







