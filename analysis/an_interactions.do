*an_interactions
*KB 9/7/2020

cap log close
log using ./output/an_interactions_`1', replace t

run global

use "cr_create_analysis_dataset_STSET_onsdeath_fail1", clear

*By age
if "`1'"=="byage"{
gen ageover60 = agegroup>=4
capture stcox 	i.hiv i.ethnicity $adjustmentlist 1.hiv#1.ageover60 , strata(stp)
if _rc==0 {
		noi di _n "AGE INTERACTION MODEL INC ETHNICITY (COMPLETE CASES)" _n 
		estimates
		estimates save ./output/models/an_interactions_ageover60, replace
		}
	else di "WARNING - hiv age-interaction MODEL DID NOT SUCCESSFULLY FIT"
}

*By sex
if "`1'"=="bysex"{
gen female = 1-male
capture stcox 	i.hiv i.ethnicity $adjustmentlist 1.hiv#1.female, strata(stp)
if _rc==0 {
		noi di _n "AGE INTERACTION MODEL INC ETHNICITY (COMPLETE CASES)" _n 
		estimates
		estimates save ./output/models/an_interactions_female, replace
		}
	else di "WARNING - hiv male interaction MODEL DID NOT SUCCESSFULLY FIT"
}

*By black/non-black
if "`1'"=="byethnicity"{
gen nonblack = (ethnicity != 4) if ethnicity<.
capture stcox 	i.hiv i.ethnicity $adjustmentlist 1.hiv#1.nonblack, strata(stp)
if _rc==0 {
		noi di _n "BLACK/NON-BLACK INTERACTION MODEL INC ETHNICITY (COMPLETE CASES)" _n 
		estimates
		estimates save ./output/models/an_interactions_nonblack, replace
		}
	else di "WARNING - hiv black/non-black interaction MODEL DID NOT SUCCESSFULLY FIT"
}

*By black/white 
if "`1'"=="byethnicity_wvsb"{
gen whitevsblack = (ethnicity != 4) if ethnicity<.
capture stcox 	i.hiv i.ethnicity age1 age2 age3 i.male i.imd i.smoke_nomiss i.obese4cat 1.hiv#1.whitevsblack if (ethnicity==1|ethnicity==4), strata(stp)
if _rc==0 {
		noi di _n "BLACK/NON-BLACK INTERACTION MODEL INC ETHNICITY (COMPLETE CASES)" _n 
		estimates
		estimates save ./output/models/an_interactions_whitevsblack, replace
		lincom 1.hiv + 1.hiv#1.whitevsblack, eform
		}
	else di "WARNING - hiv black/white interaction MODEL DID NOT SUCCESSFULLY FIT"
}
	
*By comorbidity status
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
capture stcox 	i.hiv i.ethnicity $adjustmentlist 1.hiv#1.anycomorbidity, strata(stp)
if _rc==0 {
		noi di _n "ANY_COMORBIDITY INTERACTION MODEL INC ETHNICITY (COMPLETE CASES)" _n 
		estimates
		estimates save ./output/models/an_interactions_anycomorbidity, replace
		}
	else di "WARNING - hiv any_comorbidity interaction MODEL DID NOT SUCCESSFULLY FIT"
}

log close