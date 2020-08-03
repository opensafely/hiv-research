*KB 3/8/2020

cap log close
log using an_exploresus, replace t

use cr_create_analysis_dataset, clear


/*
gen cad = date(covid_admission_date, "YMD")
gen cdd = date(covid_admission_discharge_date, "YMD")
format %d cad
format %d cdd

gen dod = date(died_date_ons, "YMD")
format %d dod
*/

*Describe SUS admissions/discharge data
safecount if covid_admission_date<. /*All COVID admissions (U071 + U072)*/
noi di _n "N COVID admissions (U071+U072) = " r(N)
local totaladmissions = r(N)
safecount if covid_confirmed_admission_date<. /*U071 only*/
noi di _n "N 'confirmed COVID' admissions (U071 only) = " r(N)
local totalconfirmedadmissions = r(N)

cou if covid_admission_date>=. & covid_confirmed_admission_date<.
if r(N)>0 noi di in red _n "WARNING - " r(N) " records of with confirmed covid admission date but no covid admission date"

safecount if covid_admission_discharge_date<.
noi di _n "N with a discharge date = " r(N) " (" %3.1f r(N)/`totaladmissions' "%)"
cou if covid_admission_date>=. & covid_admission_discharge_date<. /*must be an admission there's a discharge*/
if r(N)>0 noi di in red _n "WARNING - " r(N) " records of with confirmed covid discharge date but no covid admission date"

gen admission_length = covid_admission_discharge_date - covid_admission_date
noi di _n "Summary of admission lengths:"
noi summ admission_length,d  

cou if ons_died_date<. & covid_admission_date<.
noi di _n "N deaths among admitted = " r(N) " (" %3.1f r(N)/`totaladmissions' "%)"
cou if ons_died_date<. & onsdeath==1 & covid_admission_date<.
noi di "...of which COVID deaths are N = " r(N)

*Timing of admissions
noi di _n "Summary of admission dates:"
noi summ covid_admission_date, f d


gen onscovid_died_date = ons_died_date if onsdeath==1
gen onsnoncovid_died_date = ons_died_date if onsdeath==2

frame change default
cap frame drop weekly
frame create weekly startdate cov_admissions conf_cov_admissions covdeaths noncovdeaths alldeaths 

forvalues startweek = 21946(7)22127{
                local endweek = `startweek' + 6
				foreach var of varlist covid_admission_date covid_confirmed_admission_date onscovid_died_date onsnoncovid_died_date ons_died_date {
                safecount if `var'>=`startweek' & `var'<=`endweek'
                local N`var' = r(N)     
                local postcontent "`postcontent' (`N`var'')" 
        }
        frame post weekly (`startweek') `postcontent'
        local postcontent
}

frame change weekly

format %d startdate

scatter cov_admissions startd, c(l) || scatter conf_cov_admissions startd , c(l) ///
         || scatter covdeaths startd , c(l)
graph export ./output/an_exploresus_ADMISSIONS_DTHS_OVER_TIME.svg, as(svg) replace 
		 

scatter covdeaths startd , c(l) || scatter noncovdeaths startd , c(l)  ///
         || scatter alldeaths startd , c(l) 
graph export ./output/an_exploresus_COV_NONCOV_DTHS_OVER_TIME.svg, as(svg) replace


frame change default

*Relationship with HIV and other variables
noi di _n _n "Relationship with HIV and other variables" _n _dup(50) "*"
noi safetab covidadmission hiv , col
noi safetab covidadmission hiv if agegroup<=4, col /*<70s*/

use cr_create_analysis_dataset_STSET_covidadmission, clear

noi stcox i.hiv age1 age2 age3 i.male, strata(stp)

****************************************************************************	

cap prog drop basecoxmodel
prog define basecoxmodel
	syntax , age(string) [ethnicity(real 0) if(string)] 

	if `ethnicity'==1 local ethnicity "i.ethnicity"
	else local ethnicity

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
end
****************************************************************************
noi di _n _n "ALL hospital admissions" _n _dup(50) "*"

basecoxmodel, age("age1 age2 age3") ethnicity(1) 
if _rc==0{
noi di _n  "FULLY ADJUSTED INCLUDING ETHNICITY (COMPLETE CASES)" _n 
noi estimates
estimates save ./output/models/an_exploresus_MULTIVARMODEL_agespline_cceth, replace
 }
else di "WARNING HIV model (CC eth) DID NOT FIT (OUTCOME `outcome')"

basecoxmodel, age("i.agegroup") ethnicity(0) 
if _rc==0{
noi di _n  "FULLY ADJUSTED EXCLUDING ETHNICITY (FULL STUDY POP)" _n 
noi estimates
estimates save ./output/models/an_exploresus_MULTIVARMODEL_agegroup_noeth, replace
 }
else di "WARNING HIV model (no eth) DID NOT FIT (OUTCOME `outcome')"

basecoxmodel, age("age1 age2 age3") ethnicity(0) 
if _rc==0{
noi di _n  "FULLY ADJUSTED EXCLUDING ETHNICITY (FULL STUDY POP)" _n 
noi estimates
estimates save ./output/models/an_exploresus_MULTIVARMODEL_agespline_noeth, replace
 }
else di "WARNING HIV model (no eth) DID NOT FIT (OUTCOME `outcome')"
 
***********************
*All admissions

* Survival time = last followup date (first: end study, death, or that outcome)
summ any_admission_date
local admcensor = r(max)-7
gen stime_anyadmission 	= min(`admcensor', any_admission_date, ons_died_date)
gen anyadmission = 1 if any_admission_date<. 
replace anyadmission 	= 0 if (any_admission_date > `admcensor')|(any_admission_date > ons_died_date)  

stset stime_anyadmission , fail(anyadmission=1) 				///
	id(patient_id) enter(enter_date) origin(enter_date)

noi safetab anyadmission hiv , col
noi safetab anyadmission hiv if agegroup<=4, col /*<70s*/

noi tab any_admission_primary if anyadmission==1 & hiv==1, sort
noi tab any_admission_primary if anyadmission==1 & hiv==0, sort

noi stcox i.hiv age1 age2 age3 i.male, strata(stp)
basecoxmodel, age("age1 age2 age3") ethnicity(0) 
if _rc==0{
noi di _n  "FULLY ADJUSTED EXCLUDING ETHNICITY (FULL STUDY POP)" _n 
noi estimates
 }
else di "WARNING HIV model on any admission (no eth) DID NOT FIT (OUTCOME `outcome')"


log close
