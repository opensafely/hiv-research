*KB 
*20/7/2020

*an_phcheck_addtimeinteractions_cc

run global

cap log close
log using ./output/an_phcheck_addtimeinteractions_cc, replace t

use "cr_create_analysis_dataset_STSET_onsdeath_fail1", clear

stsplit timeperiod, at(60)

gen anyreduced_kidney_function = reduced_kidney_function_cat>=2
gen anyobesity = obese4cat>=2
gen highimd = imd>=3


stcox 	i.hiv i.ethnicity $adjustmentlist 60.timeperiod#3.ethnicity  	///
	60.timeperiod#3.ethnicity											///
	60.timeperiod#1.male												///
	60.timeperiod#2.anyobesity											///
	60.timeperiod#3.smoke_nomiss										///
	60.timeperiod#2.highimd												///			
	60.timeperiod#1.chronic_respiratory_disease							///
	60.timeperiod#1.diabetes											///
	60.timeperiod#1.chronic_liver_disease								///
	60.timeperiod#1.stroke_dementia										///
	60.timeperiod#1.other_neuro											///
	60.timeperiod#1.anyreduced_kidney_function							///
	, strata(stp)


estat phtest, d

log close
