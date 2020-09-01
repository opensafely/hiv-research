*KB 16/7/2020
*an_sens_furtherexploration_bmismok

cap log close
log using ./output/an_sens_furtherexploration_bmismok_`1', replace t

run global 

use "cr_create_analysis_dataset_STSET_onsdeath_fail1", clear

use "an_impute_imputeddata", clear

**************************
*  Analyse imputed data  *
**************************

// Declare imputed data as survival

mi stset stime_onsdeath, fail(onsdeath==1) enter(enter_date)	///
	origin(enter_date) id(patient_id)
/*
if "`1'"=="omitbmismok"{
local adjlist_nobmismok = subinstr("$adjustmentlist", "i.obese4cat", "", 1)
local adjlist_nobmismok = subinstr("`adjlist_nobmismok'", "i.smoke_nomiss", "", 1)
mi estimate, eform: stcox i.hiv i.ethnicity `adjlist_nobmismok', strata(stp)
estimates save "./output/models/an_sens_furtherexploration_bmismok_`1'", replace						
}

if "`1'"=="omitbmismokinccpop"{
local adjlist_nobmismok = subinstr("$adjustmentlist", "i.obese4cat", "", 1)
local adjlist_nobmismok = subinstr("`adjlist_nobmismok'", "i.smoke_nomiss", "", 1)
mi estimate, eform: stcox i.hiv i.ethnicity `adjlist_nobmismok' if bmicat<. & smoke<., strata(stp)
estimates save "./output/models/an_sens_furtherexploration_bmismok_`1'", replace						
}
*/
if "`1'"=="ccbmismok"{
mi estimate, eform: stcox i.hiv i.ethnicity age1 age2 age3 i.male i.imd i.smoke_nomiss i.obese4cat if bmicat<. & smoke<., strata(stp)
estimates save "./output/models/an_sens_furtherexploration_bmismok_`1'", replace						
}

if "`1'"=="ccbmionly"{
mi estimate, eform: stcox i.hiv i.ethnicity age1 age2 age3 i.male i.imd i.smoke_nomiss i.obese4cat if bmicat<., strata(stp)
estimates save "./output/models/an_sens_furtherexploration_bmismok_`1'", replace						
}

if "`1'"=="ccsmokonly"{
mi estimate, eform: stcox i.hiv i.ethnicity age1 age2 age3 i.male i.imd i.smoke_nomiss i.obese4cat if smoke<., strata(stp)
estimates save "./output/models/an_sens_furtherexploration_bmismok_`1'", replace						
}


log close

