********************************************************************************
*
*	Do-file:		an_checkassumptions_3c.do
*
*	Project:		Risk factors for poor outcomes in Covid-19; Ethnicity MNAR
*
*	Programmed by:	Elizabeth Williamson
*
*	Data used:		cr_create_analysis_dataset.dta
*					imputed.dta (imputed data, combined across regions)
*
*	Data created:	None. Models on screen.
*
*	Other output:	Log file output/an_checkassumptions_MI_estimate
*
********************************************************************************
*
*	Purpose:		This do-file fits a sensitivity analysis for missing 
*					ethnicity, using multiple imputation incorporating 
*					information from external data sources (e.g. census)
*					about the marginal proportions of ethnic groups 
*					within broad geographical regions. 
*  
********************************************************************************

* Open a log file
capture log close
log using "./output/an_imputed_`1'", text replace

********************************   NOTES  **************************************

*  Assumes region is string, taking  values: 
*    East, East Midlands, London, North East, North West, South East, 
*    South West, West Midlands, and Yorkshire and The Humber
*
*  Assumes ethnicity is numeric, taking values: 
*	1, 2, 3, 4, 5, (missing: . or .u)
*	in the order White, Black, Asian, Mixed, Other
*	with value labels exactly as above. 
*	(NB: this is now intially recoded from ordering: 
*      White, Mixed, Asian, Black, Other)	
*
*
*  Assumes a complete case sample other than ethnicity
*
********************************************************************************

run global

* Add imputations to the full dataset
use "an_impute_imputeddata", clear

**************************
*  Analyse imputed data  *
**************************

// Declare imputed data as survival

mi stset stime_onsdeath, fail(onsdeath==1) enter(enter_date)	///
	origin(enter_date) id(patient_id)


if "`1'"=="demog"{
mi estimate, eform: stcox i.hiv age1 age2 age3 i.male i.imd i.ethnicity, strata(stp)
estimates save "./output/models/an_imputed_demog", replace						
}

if "`1'"=="full"{
mi estimate: stcox i.hiv i.ethnicity $adjustmentlist, strata(stp)
estimates save "./output/models/an_imputed_full", replace
mi estimate, eform 						
}

if "`1'"=="byage"{
gen ageover60 = agegroup>=4
mi estimate (_b[1.hiv]+_b[1.hiv#1.ageover60]): stcox i.hiv i.ethnicity $adjustmentlist 1.hiv#1.ageover60, strata(stp)
estimates save "./output/models/an_imputed_byage", replace
mi estimate, eform						
}

if "`1'"=="bysex"{
mi estimate (_b[1.hiv]+_b[1.hiv#1.male]): stcox i.hiv i.ethnicity $adjustmentlist 1.hiv#1.male, strata(stp)
estimates save "./output/models/an_imputed_bysex", replace	
mi estimate, eform					
}

if "`1'"=="byethnicity"{
mi passive: gen nonblack = (ethnicity != 4) if ethnicity<.
mi estimate (_b[1.hiv]+_b[1.hiv#1.nonblack]): stcox i.hiv i.ethnicity $adjustmentlist 1.hiv#1.nonblack, strata(stp)
estimates save "./output/models/an_imputed_byethnicity", replace	
mi estimate, eform					
}

if "`1'"=="bycomorbidities"{
gen anycomorbidity = 						///
	hypertension					///
	|chronic_respiratory_disease 	///
	|(asthmacat>1)					///
	|chronic_cardiac_disease 		///
	|(diabcat>1)					///
	|(cancer_exhaem_cat>1) 			///
	|(cancer_haem_cat>1)			///
	|chronic_liver_disease 			///
	|stroke_dementia		 		///
	|other_neuro					///
	|(reduced_kidney_function_cat>1)	///
	|organ_transplant 				///
	|spleen 						///
	|ra_sle_psoriasis  				///
	|other_imm_except_hiv		
mi estimate (_b[1.hiv]+_b[1.hiv#1.anycomorbidity]): stcox i.hiv i.ethnicity $adjustmentlist 1.hiv#1.anycomorbidity, strata(stp)
estimates save "./output/models/an_imputed_bycomorbidities", replace
mi estimate, eform						
}

if "`1'"=="cuminc"{
xi $adjustmentlist
for num 2/5: mi passive: gen _Iethnicity_X=(ethnicity==X) 
mi estimate, cmdok: stpm2 hiv age1 age2 age3 _I*, df(3) scale(hazard) eform 
estimates save "./output/models/an_imputed_cuminc", replace
mi estimate, eform	
}
	
log close

