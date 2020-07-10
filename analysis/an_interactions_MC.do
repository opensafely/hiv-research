*an_interactions
*KB 9/7/2020

cap log close
log using ./output/an_interactions_MC, replace t

run global

use "cr_matchedcohort_STSET_onsdeath_fail1", clear

*By age
gen ageover60 = agegroup>=4
capture stcox 	i.hiv i.ethnicity $adjustmentlist_MC 1.hiv#1.ageover60 , strata(setid)
if _rc==0 {
		noi di _n "AGE INTERACTION MODEL INC ETHNICITY (COMPLETE CASES)" _n 
		estimates
		estimates save ./output/models/an_interactions_MC_ageover60, replace
		}
	else di "WARNING - hiv age-interaction MODEL DID NOT SUCCESSFULLY FIT"

*By sex
gen female = 1-male
capture stcox 	i.hiv i.ethnicity $adjustmentlist_MC 1.hiv#1.female, strata(setid)
if _rc==0 {
		noi di _n "AGE INTERACTION MODEL INC ETHNICITY (COMPLETE CASES)" _n 
		estimates
		estimates save ./output/models/an_interactions_MC_female, replace
		}
	else di "WARNING - hiv male interaction MODEL DID NOT SUCCESSFULLY FIT"

*By black/non-black
gen nonblack = (ethnicity != 4) if ethnicity<.
capture stcox 	i.hiv i.ethnicity $adjustmentlist_MC 1.hiv#1.nonblack, strata(setid)
if _rc==0 {
		noi di _n "BLACK/NON-BLACK INTERACTION MODEL INC ETHNICITY (COMPLETE CASES)" _n 
		estimates
		estimates save ./output/models/an_interactions_MC_nonblack, replace
		}
	else di "WARNING - hiv black/non-black interaction MODEL DID NOT SUCCESSFULLY FIT"

*By comorbidity status
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
capture stcox 	i.hiv i.ethnicity $adjustmentlist_MC 1.hiv#1.anycomorbidity, strata(setid)
if _rc==0 {
		noi di _n "ANY_COMORBIDITY INTERACTION MODEL INC ETHNICITY (COMPLETE CASES)" _n 
		estimates
		estimates save ./output/models/an_interactions_MC_anycomorbidity, replace
		}
	else di "WARNING - hiv any_comorbidity interaction MODEL DID NOT SUCCESSFULLY FIT"

log close