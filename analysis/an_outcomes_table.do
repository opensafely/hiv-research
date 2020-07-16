*an_outcomes_table
*KB 9/7/2020

run global 

*Utility
cap prog drop writehrci
prog define writehrci
	file write outcometable ("HR (`0')") _tab (string(round(r(estimate), .01), "%4.2f")) (" (") (string(round(r(lb), .01), "%4.2f")) ("-") (string(round(r(ub), .01), "%4.2f")) (")") _n
	frame post estimates ("`0'") (r(estimate)) (r(lb)) (r(ub)) (.)
end

*Set up output file/frame
cap file close outcometable
file open outcometable using ./output/an_outcomes_table.txt, write text replace

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
	writehrci Age-sex adjusted
	}
	else file write outcometable ("AGESEX _tab MODEL NOT FOUND")

cap estimates use ./output/models/an_outcomes_adjdemographics_inceth
if _rc==0{
	lincom 1.hiv, eform
	writehrci + IMD/ethnicity
	}
	else file write outcometable ("AGESEX _tab MODEL NOT FOUND")
		
cap estimates use ./output/models/an_outcomes_adjfull_inceth
if _rc==0{
	lincom 1.hiv, eform
	writehrci + obesity/smoking/comorbidities
	}
	else file write outcometable ("AGESEX _tab MODEL NOT FOUND")

*Write interaction model results
foreach var of any ageover60 female nonblack anycomorbidity{
	cap estimates use ./output/models/an_interactions_`var'
	if _rc==0{
	file write outcometable _n _n
	lincom 1.hiv, eform
	writehrci interac_NOT`var'
	lincom 1.hiv + 1.hiv#1.`var', eform
	writehrci interac_`var'
	lincom 1.hiv#1.`var'
	frame post estimates ("int_`var'") (.) (.) (.) (r(p))
	}
	else file write outcometable _n _n ("`var'_interaction _tab MODEL NOT FOUND")
	}
	
file close outcometable

*Put p-int onto the right rows and tidy
frame estimates: replace pint = pint[_n+1] if pint==.
frame estimates: replace pint = pint[_n+1] if pint==.
frame estimates: drop if hr==.

frame estimates: save ./output/an_outcomes_table_ESTIMATES, replace

