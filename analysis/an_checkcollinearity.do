*an_checkcollinearity

cap log close
log using ./output/an_checkcollinearity, replace t

use "an_impute_imputeddata", clear

xi: collin age1 age2 age3 i.male i.imd i.smoke_nomiss i.obese4cat i.ethnicity if _mi==0

xi: pwcorr age1 age2 age3 i.male i.imd i.smoke_nomiss i.obese4cat i.ethnicity if _mi==0

*Get univariate se's for comparison with demog_smokob model
*ethnicity (needs mi)
mi stset stime_onsdeath, fail(onsdeath==1) enter(enter_date)	///
	origin(enter_date) id(patient_id)
mi estimate, eform: stcox i.ethnicity, strata(stp)
*the rest
mi extract 0
stset stime_onsdeath, fail(onsdeath==1) enter(enter_date)	///
	origin(enter_date) id(patient_id)
stcox age1 age2 age3, strata(stp)
stcox i.male, strata(stp)
stcox i.imd, strata(stp)
stcox i.smoke_nomiss, strata(stp)
stcox i.obese4cat, strata(stp)
	
log close


**************************
*  Analyse imputed data  *
**************************

// Declare imputed data as survival

mi stset stime_onsdeath, fail(onsdeath==1) enter(enter_date)	///
	origin(enter_date) id(patient_id)

	
mi estimate, eform: stcox i.hiv age1 age2 age3 i.male i.imd i.smoke_nomiss i.obese4cat i.ethnicity, strata(stp)

mi estimate, eform: stcox i.hiv 


mi extract 0 
stset stime_onsdeath, fail(onsdeath==1) enter(enter_date)	///
	origin(enter_date) id(patient_id)


stcox i.hiv 
xi: collin age1 age2 age3 i.male i.imd i.smoke_nomiss i.obese4cat i.ethnicity