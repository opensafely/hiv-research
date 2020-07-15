*an_outcomes_table
*KB 9/7/2020

run global 

*Utility
cap prog drop writehrci
prog define writehrci
syntax anything, estimate(real) lci(real) uci(real)
	file write outcometable ("HR (`1')") _tab (string(round(`estimate', .01), "%4.2f")) (" (") (string(round(`lci', .01), "%4.2f")) ("-") (string(round(`uci', .01), "%4.2f")) (")") _n
	frame post estimates ("`0'") (`estimate') (`lci') (`uci') (.)
end

*Set up output file/frame
cap file close outcometable
file open outcometable using ./output/an_outcomes_MI_table.txt, write text replace

frames reset
frame create estimates str40 desc hr lci uci pint

*Get rates ready
use ./output/an_outcomes_RATES, clear
gen str12 ev_py = string(_D) + " / " + string(round(_Y, 0.01), "%4.2f")
gen rateci = string(_Rate, "%4.2f") + " (" + string(_Lower, "%4.2f") + "-" + string(_Upper, "%4.2f") + ")"
sort hiv 

*Write ev/py/rates
foreach hivlevel of numlist 1 0{
	local hivlevelobs = `hivlevel'+1
	file write outcometable ("HIV=`hivlevel' Events/1000py") _tab  (ev_py[`hivlevelobs']) _n
	file write outcometable ("HIV=`hivlevel' Rate/1000py") _tab (rateci[`hivlevelobs']) _n
	file write outcometable _n _n
	}
	
*Write non-interaction model results
cap estimates use ./output/models/an_outcomes_agesex
if _rc==0{
	lincom 1.hiv, eform
	local estimate = r(estimate)
	local lci = r(lb)
	local uci = r(ub)
	writehrci Age-sex_adjusted, estimate(`estimate') lci(`lci') uci(`uci')
	}
	else file write outcometable ("AGESEX _tab MODEL NOT FOUND")

cap estimates use ./output/models/an_imputed_demog
if _rc==0{
	local estimate = exp( el(e(b_mi),1,2) )
	local lci = exp( el(e(b_mi),1,2)  - 1.96*  sqrt(el(e(V_mi),2,2))  )
	local uci = exp( el(e(b_mi),1,2)  + 1.96*  sqrt(el(e(V_mi),2,2))  )
	writehrci +IMD/ethnicity, estimate(`estimate') lci(`lci') uci(`uci')
	}
	else file write outcometable ("AGESEX _tab MODEL NOT FOUND")
		
cap estimates use ./output/models/an_imputed_full
if _rc==0{
	local estimate = exp( el(e(b_mi),1,2) )
	local lci = exp( el(e(b_mi),1,2)  - 1.96*  sqrt(el(e(V_mi),2,2))  )
	local uci = exp( el(e(b_mi),1,2)  + 1.96*  sqrt(el(e(V_mi),2,2))  )
	writehrci +obesity/smoking/comorbidities, estimate(`estimate') lci(`lci') uci(`uci')
	}
	else file write outcometable ("AGESEX _tab MODEL NOT FOUND")

*Write interaction model results
foreach var of any ageover60 female nonblack anycomorbidity{
	if "`var'"=="ageover60" local filesuffix "age"
	if "`var'"=="female" local filesuffix "sex"
	if "`var'"=="nonblack" local filesuffix "ethnicity"
	if "`var'"=="anycomorbidity" local filesuffix "comorbidities"
	cap estimates use ./output/models/an_imputed_by`filesuffix'
	if _rc==0{
	file write outcometable _n _n
	local estimate = exp( el(e(b_mi),1,2) )
	local lci = exp( el(e(b_mi),1,2)  - 1.96*  sqrt(el(e(V_mi),2,2))  )
	local uci = exp( el(e(b_mi),1,2)  + 1.96*  sqrt(el(e(V_mi),2,2))  )
	writehrci interac_NOT`var', estimate(`estimate') lci(`lci') uci(`uci')
	local estimate = exp( el(e(b_Q_mi),1,1) )
	local lci = exp( el(e(b_Q_mi),1,1) - 1.96* sqrt(el(e(V_Q_mi),1,1)) )
	local uci = exp( el(e(b_Q_mi),1,1) + 1.96* sqrt(el(e(V_Q_mi),1,1)) )
	writehrci interac_`var', estimate(`estimate') lci(`lci') uci(`uci')
	local pint = 2*(1-normal( abs(el ( e(b_mi), 1, colsof(e(b_mi))))/ sqrt( el ( e(V_mi), colsof(e(V_mi)), colsof(e(V_mi))) )))
	frame post estimates ("int_`var'") (.) (.) (.) (`pint')
	}
	else file write outcometable _n _n ("`var'_interaction _tab MODEL NOT FOUND")
	}
	
file close outcometable

frame estimates: replace pint = pint[_n+1] if pint==.
frame estimates: replace pint = pint[_n+1] if pint==.
frame estimates: drop if hr==.

frame estimates: save ./output/an_outcomes_MI_table_ESTIMATES, replace

