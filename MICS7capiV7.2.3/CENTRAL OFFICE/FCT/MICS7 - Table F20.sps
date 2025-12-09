* Encoding: UTF-8.

include "surveyname.sps".

get file "hh.sav".
sort cases by HH1 HH2.
include "targets.sps".
select if (HH46 = 1).
compute HHwithconsent = 0.
if (HH44BC = 1) HHwithconsent = 1.
compute HHwithphone = 0.
if (HH44BC = 1 and HH44DE = 1) HHwithphone = 1.
save outfile "HHphone.sav"
    /keep HH1 HH2 HH6 HH7 team HC7A HC12 HH44BC HH44DE HHwithconsent HHwithphone.

get file "wm.sav".
sort cases by HH1 HH2 LN.
select if (WM17 = 1).
compute WMwithconsent = 0.
if (WM15EF = 1) WMwithconsent = 1.
compute WMwithphone = 0.
if (WM15EF = 1 and WM15GH = 1) WMwithphone = 1.
aggregate
  /outfile = "WMphone.sav"
  /break = HH1 HH2
  /WMwithconsent_sum = sum(WMwithconsent) 
  /WMwithphone_sum = sum(WMwithphone).

get file "mn.sav".
sort cases by HH1 HH2 LN.
select if (MWM17 = 1).
compute MNwithconsent = 0.
if (MWM15EF = 1) MNwithconsent = 1.
compute MNwithphone = 0.
if (MWM15EF = 1 and MWM15GH = 1) MNwithphone = 1.
aggregate
  /outfile = "MNphone.sav"
  /break = HH1 HH2
  /MNwithconsent_sum = sum(MNwithconsent) 
  /MNwithphone_sum = sum(MNwithphone).

get file "ch.sav".
sort cases by HH1 HH2 LN.
select if (UF17 = 1).
compute CHwithconsent = 0.
if (UF15EF = 1) CHwithconsent = 1.
compute CHwithphone = 0.
if (UF15EF = 1 and UF15GH = 1) CHwithphone = 1.
aggregate
  /outfile = "CHphone.sav"
  /break = HH1 HH2
  /CHwithconsent_sum = sum(CHwithconsent) 
  /CHwithphone_sum = sum(CHwithphone).

get file "fs.sav".
sort cases by HH1 HH2 LN.
select if (FS17 = 1).
compute FSwithconsent = 0.
if (FS15EF = 1) FSwithconsent = 1.
compute FSwithphone = 0.
if (FS15EF = 1 and FS15GH = 1) FSwithphone = 1.
aggregate
  /outfile = "FSphone.sav"
  /break = HH1 HH2
  /FSwithconsent_sum = sum(FSwithconsent) 
  /FSwithphone_sum = sum(FSwithphone).

get file "HHphone.sav".
match files
  /file = *
  /table = 'WMphone.sav'
  /table = 'MNphone.sav'
  /table = 'CHphone.sav'
  /table = 'FSphone.sav'  
  /by HH1 HH2.

if sysmis(WMwithconsent_sum) WMwithconsent_sum = 0.
if sysmis(WMwithphone_sum) WMwithphone_sum = 0.
if sysmis(MNwithconsent_sum) MNwithconsent_sum = 0.
if sysmis(MNwithphone_sum) MNwithphone_sum = 0.
if sysmis(CHwithconsent_sum) CHwithconsent_sum = 0.
if sysmis(CHwithphone_sum) CHwithphone_sum = 0.
if sysmis(FSwithconsent_sum) FSwithconsent_sum = 0.
if sysmis(FSwithphone_sum) FSwithphone_sum = 0.

compute ALLwithconsent_sum = HHwithconsent + WMwithconsent_sum + MNwithconsent_sum + CHwithconsent_sum + FSwithconsent_sum.
compute ALLwithphone_sum = HHwithphone + WMwithphone_sum + MNwithphone_sum + CHwithphone_sum + FSwithphone_sum.
variable labels ALLwithconsent_sum "Number of household members who has given consent (including household respondent)".
variable labels ALLwithphone_sum "Number of household members who has provided a phone number (including household respondent)".
formats ALLwithconsent_sum ALLwithphone_sum (f2.0).

compute atleastoneconsent = 0.
if (ALLwithconsent_sum > 0) atleastoneconsent = 100.
variable labels atleastoneconsent "At least one consent given".
compute atleastonephone = 0.
if (ALLwithphone_sum > 0) atleastonephone = 100.
variable labels atleastonephone "At least one consent given and phone number provided".

compute layer = 0.
value labels layer 0 "Percentage with:".

compute total = 1. 
variable labels total "".
value labels total 1 "Total".

compute tot = 1.
value labels tot 1 " ".
variable labels tot "Number of completed households".

compute fixed = 0.
if (HC7A = 1) fixed = 100.
variable labels fixed "A fixed telephone line".
compute mobile = 0.
if (HC12 = 1) mobile = 100.
variable labels mobile "Any member with a mobile telephone".
compute either = 0.
if (fixed = 100 or mobile = 100) either = 100.
variable labels either "Either a fixed telephone line or any member with a mobile telephone".

recode either (100 = 1) (0 = 2) into either1.
variable labels either1 "Phone ownership (according to respondent to HH questionnaire)".
value labels either1 1 "Yes" 2 "No". 

ctables 
     /vlabels variables = total layer display = none  
     /table total [c] + team [c] + either1 [c] + HH6 [c] + HH7 [c] by layer [c] > (fixed [s] [mean "" f8.1] + mobile [s] [mean "" f8.1] + either [s] [mean "" f8.1]) + 
             layer [c] > (atleastoneconsent [s] [mean "" f8.1] + atleastonephone [s] [mean "" f8.1]) + tot [s] [sum '' f5.0]
     /categories variables=all empty=exclude missing=exclude
     /slabels position=column visible = no
     /titles title =  "F20. Phone ownership and Provision of consent and phone numbers for MICS Plus survey"
   "Percentage of households by ownership of fixed telephone line or mobile phone and percentage of households with at least one consent given and one phone number provided for MICS Plus survey, " + surveyname.

new file.

erase file "HHphone.sav".
erase file "WMphone.sav".
erase file "MNphone.sav".
erase file "CHphone.sav".
erase file "FSphone.sav".

