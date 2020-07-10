*an_deschivdeaths_table
*KB 10/7/2020

run global

*******************************************************************************
*Generic code to output one row of table
cap prog drop generaterow
program define generaterow
syntax, variable(varname) condition(string) 
safecount if `variable' `condition'
file write descdeathstable ("`variable'") _tab ("`condition'") _tab (r(N)) (" (") %4.2f (100*(r(N))/_N) (")") _n
end

use "cr_create_analysis_dataset.dta_STSET_onsdeath_fail1" if hiv==1 & _d==1, clear

cap file close descdeathstable
file open descdeathstable using ./output/an_deschivdeaths_table.txt, write text replace

generaterow, variable(agegroup) condition(<4)
generaterow, variable(agegroup) condition(>=4)
file write descdeathstable _n _n
generaterow, variable(male) condition(==1)
generaterow, variable(male) condition(==0)
file write descdeathstable _n _n
generaterow, variable(obese4cat) condition(==1)
generaterow, variable(obese4cat) condition(>=2)
file write descdeathstable _n _n
generaterow, variable(ethnicity) condition(==4)
generaterow, variable(ethnicity) condition(!=4)
file write descdeathstable _n _n
generaterow, variable(hypertension) condition(==1)
generaterow, variable(diabetes) condition(==1)
generaterow, variable(reduced_kidney_function) condition(>=2)


file close descdeathstable


