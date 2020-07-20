*KB 
*16/7/2020

*an_phcheck_cc
run global

cap log close
log using ./output/an_phcheck_cc, replace t

use "cr_create_analysis_dataset_STSET_onsdeath_fail1", clear

stcox 	i.hiv i.ethnicity $adjustmentlist , strata(stp)

estat phtest, d

estat phtest, plot(1.hiv)
graph export ./output/an_phcheck_cc_schoenplot.svg, as(svg) replace

stphplot, by(hiv) 
graph export ./output/an_phcheck_cc_lnlnplot.svg, as(svg) replace

log close
