*an_cumincidence
*KB 10/7/2020

run global

cap log close
log using ./output/an_cumincidence, replace t

use "cr_create_analysis_dataset_STSET_onsdeath_fail1", clear

*xi: stpm2 hiv i.ethnicity $adjustmentlist, df(3) scale(hazard) eform
xi i.ethnicity $adjustmentlist 
stpm2 hiv age1 age2 age3 _I*, df(3) scale(hazard) eform 

summ _t
local tmax=r(max)
local tmaxplus1=r(max)+1

range timevar 0 `tmax' `tmaxplus1'
stpm2_standsurv if hiv==1 & ethnicity<., at1(hiv 0) at2(hiv 1) timevar(timevar) ci contrast(difference) fail

gen date = d(1/2/2020)+ timevar
format date %tddd_Month

for var _at1 _at2 _at1_lci _at1_uci _at2_lci _at2_uci: replace X=100*X

l date timevar _at1 _at1_lci _at1_uci _at2 _at2_lci _at2_uci if timevar<.

twoway  (rarea _at1_lci _at1_uci date, color(red%25)) ///
                 (rarea _at2_lci _at2_uci date if _at2_uci<1, color(blue%25)) ///
                 (line _at1 date, sort lcolor(red)) ///
                 (line _at2  date, sort lcolor(blue)) ///
                 , legend(order(1 "No HIV" 2 "HIV") ring(0) cols(1) pos(1)) ///
                 ylabel(0(0.05)0.15,angle(h) format(%4.2f)) ///
                 ytitle("Cumulative mortality (%)") ///
                 xtitle("Date in 2020")

graph export ./output/an_cumincidence.svg, as(svg) replace
				 
log close