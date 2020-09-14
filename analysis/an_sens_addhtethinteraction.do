*an_sens_addhtethinteraction
*kb 15/9/20

cap log close
log using ./output/an_sens_addhtethinteraction, replace t


use "an_impute_imputeddata", clear

**************************
*  Analyse imputed data  *
**************************

// Declare imputed data as survival

mi stset stime_onsdeath, fail(onsdeath==1) enter(enter_date)	///
	origin(enter_date) id(patient_id)

*Analyse without then with hypertension-ethnicity interaction
mi estimate, eform: stcox i.hiv age1 age2 age3 i.male i.imd i.smoke_nomiss i.obese4cat i.ethnicity i.hypertension, strata(stp)
mi estimate, eform 						


mi estimate, eform: stcox i.hiv age1 age2 age3 i.male i.imd i.smoke_nomiss i.obese4cat i.ethnicity i.ethnicity##i.hypertension, strata(stp)
mi estimate, eform 						

*test for interaction
mi test 2.ethnicity#1.hypertension 3.ethnicity#1.hypertension 4.ethnicity#1.hypertension 5.ethnicity#1.hypertension

log close
