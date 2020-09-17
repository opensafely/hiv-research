*KB
*16/09/2020

* Open a log file
capture log close
log using "./output/an_sens_underlyingandu071", text replace

run global

* Add imputations to the full dataset
use "an_impute_imputeddata", clear

merge 1:1 patient_id using diedcategory_16092020 

tab _d hiv
tab diedcat if hiv==1 & _d==1, m
tab diedcat if hiv==0 & _d==1, m

replace onsdeath=2 if onsdeath==1 & diedcat==1|diedcat==2|diedcat==3

**************************
*  Analyse imputed data  *
**************************

// Declare imputed data as survival

mi stset stime_onsdeath, fail(onsdeath==1) enter(enter_date)	///
	origin(enter_date) id(patient_id)
	
mi estimate, eform: stcox i.hiv age1 age2 age3 i.male i.imd i.smoke_nomiss i.obese4cat i.ethnicity, strata(stp)


log close