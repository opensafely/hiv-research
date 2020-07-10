*an_outcomes
*KB 9/7/2020

cap log close
log using ./output/an_outcomes_MC, replace t

run global 

frames reset  
use "cr_matchedcohort_STSET_onsdeath_fail1", clear

strate hiv, per(365000) output(./output/an_outcomes_MC_RATES)


******************************
*  Age-sex Cox model  *
******************************
capture stcox age1 age2 age3 i.male i.hiv, strata(setid) 
if _rc==0 {
		noi di _n  "AGE-SEX ADJUSTED (FULL STUDY POP)" _n 
		estimates
		estimates save ./output/models/an_outcomes_MC_agesex, replace
		}
	else {
	di "WARNING - AGESEX MODEL DID NOT SUCCESSFULLY FIT"
	}
	
**************************************
*  Demographics +/- ethnicity model  *
**************************************
capture stcox age1 age2 age3 i.male i.imd i.ethnicity i.hiv, strata(setid) 
if _rc==0 {
		noi di _n "DEMOGRAPHICS ADJUSTED INCLUDING ETHNICITY (COMPLETE CASES)" _n 
		estimates
		estimates save ./output/models/an_outcomes_MC_adjdemographics_inceth, replace
		}
	else di "WARNING - hiv adj demog inc CC eth MODEL DID NOT SUCCESSFULLY FIT"

capture stcox age1 age2 age3 i.male i.imd i.hiv, strata(setid) 
if _rc==0 {
		noi di _n  "DEMOGRAPHICS ADJUSTED EXCLUDING ETHNICITY (FULL STUDY POP)" _n 
		estimates
		estimates save ./output/models/an_outcomes_MC_adjdemographics_noeth, replace
		}
	else di "WARNING - hiv adj demog no eth MODEL DID NOT SUCCESSFULLY FIT"


******************************
*  Multivariable Cox model  *
******************************


capture stcox 	i.hiv i.ethnicity $adjustmentlist , strata(stp)
if _rc==0 {
		noi di _n "FULLY ADJUSTED MODEL INC ETHNICITY (COMPLETE CASES)" _n 
		estimates
		estimates save ./output/models/an_outcomes_adjfull_inceth, replace
		}
	else di "WARNING - hiv adj demog inc CC eth MODEL DID NOT SUCCESSFULLY FIT"

capture stcox 	i.hiv $adjustmentlist , strata(stp)
if _rc==0 {
		noi di _n "FULLY ADJUSTED MODEL NO ETHNICITY " _n 
		estimates
		estimates save ./output/models/an_outcomes_adjfull_noeth, replace
		}
	else di "WARNING - hiv full adj exc eth MODEL DID NOT SUCCESSFULLY FIT"

capture stcox 	i.hiv  i.ethnicity i.hepc $adjustmentlist , strata(stp)
if _rc==0 {
		noi di _n "FULLY ADJUSTED MODEL INC ETHNICITY (COMPLETE CASES) PLUS HEP C" _n 
		estimates
		estimates save ./output/models/an_outcomes_adjfull_plushepc_inceth, replace
		}
	else di "WARNING - hiv full adj plus hepc inc eth MODEL DID NOT SUCCESSFULLY FIT"

log close

