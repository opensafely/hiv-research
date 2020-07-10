*an_cumincidence
*KB 10/7/2020

run global

cap log close
log using an_cumincidence_MC, replace t

use "cr_matchedcohort_STSET_onsdeath_fail1", clear

*xi: stpm2 hiv i.ethnicity $adjustmentlist_MC, df(3) scale(hazard) eform
xi i.ethnicity $adjustmentlist_MC 
stpm2 hiv age1 age2 age3 male _I*, df(3) scale(hazard) eform 
/*nb adjusting for match factors [ex stp] directly here, rather than stratifying on setid*/

range timevar 0 114 100
stpm2_standsurv if hiv==1, at1(hiv 0) at2(hiv 1) timevar(timevar) ci contrast(difference) fail

gen date = d(1/2/2020)+ timevar
format date %tddd_Month

twoway  (rarea _at1_lci _at1_uci date, color(red%25)) ///
                 (rarea _at2_lci _at2_uci date, color(blue%25)) ///
                 (line _at1 date, sort lcolor(red)) ///
                 (line _at2  date, sort lcolor(blue)) ///
                 , legend(order(1 "No HIV" 2 "HIV") ring(0) cols(1) pos(1)) ///
                 ylabel(0(0.01)0.05,angle(h) format(%3.2f)) ///
                 ytitle("Cumulative mortality") ///
                 xtitle("Date in 2020")

graph export ./output/an_cumincidence_MC.svg, as(svg) replace
				 
log close