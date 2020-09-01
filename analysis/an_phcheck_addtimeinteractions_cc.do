*KB 
*20/7/2020

*an_phcheck_addtimeinteractions_cc

run global

cap log close
log using ./output/an_phcheck_addtimeinteractions_cc, replace t

use "cr_create_analysis_dataset_STSET_onsdeath_fail1", clear

stsplit timeperiod, at(60)

*gen anyreduced_kidney_function = reduced_kidney_function_cat>=2
*gen anyobesity = obese4cat>=2
gen highimd = imd>=3
gen anyobese = obese4cat>=2
gen currsmok= smoke_nomiss==3

stcox 	i.hiv i.ethnicity age1 age2 age3 i.male i.imd i.smoke_nomiss i.obese4cat 60.timeperiod#2.ethnicity  	///
	60.timeperiod#3.ethnicity											///
	60.timeperiod#4.ethnicity											///
	60.timeperiod#5.ethnicity											///
	60.timeperiod#1.male												///
	60.timeperiod#1.highimd												///		
	60.timeperiod#1.anyobese											///		
	60.timeperiod#1.currsmok 											///		
	, strata(stp)


estat phtest, d

log close
