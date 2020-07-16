*KB 16/7/2020
*an_sens_ccbmismok

cap log close
log using ./output/an_sens_ccbmismok, replace t

run global 

use "cr_create_analysis_dataset_STSET_onsdeath_fail1", clear

replace obese4cat = . if bmicat==.
replace smoke_nomiss = smoke 

capture stcox 	i.hiv i.ethnicity $adjustmentlist , strata(stp)
if _rc==0 {
		noi di _n "FULLY ADJUSTED MODEL COMPLETE CASE FOR ETHNICITY AND BMI AND SMOKING" _n 
		noi di _n "note - ignore that smoking var is still called smoke_nomiss - missing are omitted here" _n 
		estimates
		estimates save ./output/models/an_sens_ccbmismok_inceth, replace
		}
	else di "WARNING - cc analysis for bmi/smok/eth DID NOT SUCCESSFULLY FIT"


capture stcox 	i.hiv $adjustmentlist , strata(stp)
if _rc==0 {
		noi di _n "FULLY ADJUSTED MODEL COMPLETE CASE FOR BMI AND SMOKING, OMITTING ETH" _n 
		noi di _n "note - ignore that smoking var is still called smoke_nomiss - missing are omitted here" _n 
		estimates
		estimates save ./output/models/an_sens_ccbmismok_noeth, replace
		}
	else di "WARNING - cc analysis for bmi/smok, OMITTING ETH DID NOT SUCCESSFULLY FIT"


log close
