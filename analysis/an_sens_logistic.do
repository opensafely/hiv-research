cap log close

log using ./output/an_sens_logistic, replace t

run global

* Add imputations to the full dataset
use "an_impute_imputeddata", clear

// Declare imputed data as survival
mi stset stime_onsdeath, fail(onsdeath==1) enter(enter_date)	///
	origin(enter_date) id(patient_id)

mi estimate: logistic _d i.hiv age1 age2 age3 i.male i.imd i.smoke_nomiss i.obese4cat i.ethnicity
mi estimate, eform
estimates save "./output/models/an_sens_logistic_WITHOUTSTP", replace						
	
mi estimate: logistic _d i.hiv age1 age2 age3 i.male i.imd i.smoke_nomiss i.obese4cat i.ethnicity i.stp
mi estimate, eform
estimates save "./output/models/an_sens_logistic_WITHSTP", replace						

mi passive: gen nonblack = (ethnicity != 4) if ethnicity<.
mi estimate (_b[1.hiv]+_b[1.hiv#1.nonblack]): logistic _d i.hiv i.ethnicity age1 age2 age3 i.male i.imd i.smoke_nomiss i.obese4cat  1.hiv#1.nonblack i.stp
estimates save "./output/models/an_sens_logistic_ETHNICITY_INT", replace						
mi estimate, eform					


log close