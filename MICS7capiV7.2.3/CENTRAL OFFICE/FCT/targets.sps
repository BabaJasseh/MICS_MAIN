* Encoding: windows-1252.

compute team = HH4.

recode hh6(1,2=1)(3,4=2).
value labels hh6 1 "Urban" 2 "Rural".


* In case tables are to be run by interviewers:
*compute team = HH3.

variable labels team "Team".
formats team (f3.0).

* TARGETS!.
*--------------------------------------------------------------------------------------------------------------------------------------------------.
* Table F2W. Eligible women per household.
* Change targets below accordingly.
* In the below example it is expected to find 1.43 women in urban areas and 1.26 women in rural areas.

compute  t2wU = 1.43.
compute  t2wR = 1.26.

*--------------------------------------------------------------------------------------------------------------------------------------------------.
* F2M. Eligible men per household.
* Change targets below accordingly.
* In the below example it is expected to find 1.37 men in urban areas and 1.06 men in rural areas.

compute  t2mU = 1.37.
compute  t2mR = 1.06.

*--------------------------------------------------------------------------------------------------------------------------------------------------.
* F2UC. Eligible children per household.
* Change targets below accordingly.
* In the below example it is expected to find 0.5 children under 5 in urban areas and 0.83 in rural areas; 1.24 children 5-17 in urban areas and 1.33 in rural areas.

compute  t2CU = 0.5.
compute  t2CR = 0.83.

compute  t2AU = 1.24.
compute  t2AR = 1.33.

*--------------------------------------------------------------------------------------------------------------------------------------------------.
* F5W. Age displacement: women
* Change targets if necessary.

compute target5w = 0.8.


*--------------------------------------------------------------------------------------------------------------------------------------------------.
* F5M. Age displacement: men
* Change targets if necessary.

compute target5m = 0.8.

*--------------------------------------------------------------------------------------------------------------------------------------------------.
* F5U. Age displacement: children under-5
* Change targets if necessary.

compute target5u = 0.8.

*--------------------------------------------------------------------------------------------------------------------------------------------------.
* F5C. Age displacement: children
* Change targets if necessary.

compute target5c = 0.8.

*--------------------------------------------------------------------------------------------------------------------------------------------------.
* F10. Children ever born and children surviving.
* Change targets if necessary.
*Note: Target should be defined to be > 75% of the mean CEB from a previous survey or census.							
*Survey managers should provide data processors with the country-specific target.								
*Example: CEB in previous survey: 2.01 thus Target = 2.01 * 0.75 = 1.51.	

compute target10 = 2.01 * 0.75.
