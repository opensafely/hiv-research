*KB 16/7/2020
*an_phcheck_interaction_mi

cap log close
log using ./output/an_phcheck_interaction_mi, replace t

run global 

use "an_impute_imputeddata", clear

**************************
*  Analyse imputed data  *
**************************

// Declare imputed data as survival

mi stset stime_onsdeath, fail(onsdeath==1) enter(enter_date)	///
	origin(enter_date) id(patient_id)

mi stsplit timeperiod, at(60 90)
	
mi estimate (_b[1.hiv]+_b[60.timeperiod#1.hiv]) (_b[1.hiv]+_b[60.timeperiod#1.hiv] + _b[90.timeperiod#1.hiv]), eform: stcox i.hiv i.ethnicity $adjustmentlist 60.timeperiod#1.hiv 90.timeperiod#1.hiv, strata(stp)

mi test 60.timeperiod#1.hiv 90.timeperiod#1.hiv

estimates save "./output/models/an_phcheck_interaction_mi", replace						



log close

