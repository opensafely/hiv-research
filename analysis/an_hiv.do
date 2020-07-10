*an_hiv_outcome
*KB 30/6/2020

cap log close
log using "./output/an_hiv_`outcome'", replace t

use "cr_create_analysis_dataset.dta", clear

* Save a version set on ONS covid death outcome
stset stime_onsdeath, fail(onsdeath=1) 				///
	id(patient_id) enter(enter_date) origin(enter_date)

tab male if hiv==1
tab agegroup if hiv==1

safecount if hiv==1 & _d==1
di _n "Deaths among hiv: " r(N)


******************************
*  Age-sex Cox model  *
******************************
capture stcox age1 age2 age3 i.male i.hiv, strata(stp) 
if _rc==0 {
		noi di _n  "AGE-SEX ADJUSTED (FULL STUDY POP)" _n 
		estimates
		estimates save ./output/models/an_hiv_univariate, replace
		}
	else di "WARNING - `var' vs `outcome' MODEL DID NOT SUCCESSFULLY FIT"
	
**************************************
*  Demographics +/- ethnicity model  *
**************************************
capture stcox age1 age2 age3 i.male i.imd i.ethnicity i.hiv, strata(stp) 
if _rc==0 {
		noi di _n "DEMOGRAPHICS ADJUSTED INCLUDING ETHNICITY (COMPLETE CASES)" _n 
		estimates
		estimates save ./output/models/an_hiv_adjdemographics_inceth, replace
		}
	else di "WARNING - hiv adj demog inc CC eth MODEL DID NOT SUCCESSFULLY FIT"

capture stcox age1 age2 age3 i.male i.imd i.hiv, strata(stp) 
if _rc==0 {
		noi di _n  "DEMOGRAPHICS ADJUSTED EXCLUDING ETHNICITY (FULL STUDY POP)" _n 
		estimates
		estimates save ./output/models/an_hiv_adjdemographics_noeth, replace
		}
	else di "WARNING - hiv adj demog no eth MODEL DID NOT SUCCESSFULLY FIT"


******************************
*  Multivariable Cox model  *
******************************

*PROG TO DEFINE THE BASIC COX MODEL WITH OPTIONS FOR HANDLING OF AGE, BMI, ETHNICITY:
cap prog drop basecoxmodel
prog define basecoxmodel
	syntax , age(string) [ethnicity(real 0) if(string)] 

	if `ethnicity'==1 local ethnicity "i.ethnicity"
	else local ethnicity


	
timer clear
timer on 1
	capture stcox 	i.hiv 			///
			`age' 					///
			i.male 							///
			i.obese4cat						///
			i.smoke_nomiss					///
			`ethnicity'						///
			i.imd 							///
			i.htdiag_or_highbp				///
			i.chronic_respiratory_disease 	///
			i.asthmacat						///
			i.chronic_cardiac_disease 		///
			i.diabcat						///
			i.cancer_exhaem_cat	 			///
			i.cancer_haem_cat  				///
			i.chronic_liver_disease 		///
			i.stroke_dementia		 		///
			i.other_neuro					///
			i.reduced_kidney_function_cat	///
			i.organ_transplant 				///
			i.spleen 						///
			i.ra_sle_psoriasis  			///
			i.other_imm_except_hiv			///
			`if'							///
			, strata(stp)
timer off 1
timer list
end
*************************************************************************************

basecoxmodel, age("age1 age2 age3") ethnicity(1) 
if _rc==0{
noi di _n  "FULLY ADJUSTED INCLUDING ETHNICITY (COMPLETE CASES)" _n 
estimates
estimates save ./output/models/an_hiv_multiv_CCeth, replace
 }
else di "WARNING HIV model (CC eth) DID NOT FIT (OUTCOME `outcome')"

basecoxmodel, age("age1 age2 age3") ethnicity(0) 
if _rc==0{
noi di _n  "FULLY ADJUSTED EXCLUDING ETHNICITY (FULL STUDY POP)" _n 
estimates
estimates save ./output/models/an_hiv_multiv_noeth, replace
 }
else di "WARNING HIV model (no eth) DID NOT FIT (OUTCOME `outcome')"
 
log close
