*an_sensan_addhhsize
*kb 15/9/20

cap log close
log using ./output/an_sens_addhhsize, replace t


use "an_impute_imputeddata", clear

**************************
*  Analyse imputed data  *
**************************

merge 1:1 patient_id using _hhdata_ethstudy

// Declare imputed data as survival

mi stset stime_onsdeath, fail(onsdeath==1) enter(enter_date)	///
	origin(enter_date) id(patient_id)

*Analyse without then with hhsize
mi estimate, eform: stcox i.hiv age1 age2 age3 i.male i.imd i.smoke_nomiss i.obese4cat i.ethnicity if hh_total<., strata(stp)
mi estimate, eform 						


mi estimate, eform: stcox i.hiv age1 age2 age3 i.male i.imd i.smoke_nomiss i.obese4cat i.ethnicity i.hhtotal, strata(stp)
mi estimate, eform 						

log close
