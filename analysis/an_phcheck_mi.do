*KB 
*16/7/2020

*an_phcheck_cc
run global

frames reset 

cap log close
log using ./output/an_phcheck_mi, replace t

use "an_impute_imputeddata", clear

// Declare imputed data as survival
mi stset stime_onsdeath, fail(onsdeath==1) enter(enter_date)	///
	origin(enter_date) id(patient_id)
	

foreach extract of numlist 1 5 10 {
	frame copy default extract
	frame change extract
	mi extract `extract'
	stcox i.hiv i.ethnicity age1 age2 age3 i.male i.imd , strata(stp)

	estat phtest, d

	estat phtest, plot(1.hiv) name(phtest`extract', replace) title("Schoenfeld residuals plot:" "imputation `extract'")

	stphplot, by(hiv) name(stphplot`extract', replace) title("Log-log plot:" "imputation `extract'")

	frame change default
	frame drop extract

}

graph combine phtest1 phtest5 phtest10
graph export ./output/an_phcheck_mi_schoenplot.svg, as(svg) replace

graph combine stphplot1 stphplot5 stphplot10
graph export ./output/an_phcheck_mi_lnlnplot.svg, as(svg) replace

log close
