clear
import delimited `c(pwd)'/output/input.csv


set more off
cd  analysis


/*  Pre-analysis data manipulation  */

**********************************************
*IF PARALLEL WORKING - THIS MUST BE RUN FIRST*
**********************************************
do "cr_create_analysis_dataset.do"

do "an_covidevidencebytime.do"

noi run "an_describetestingvariables"

noi run "an_describetestingvariables_overlap"

do "an_mortality_by_evtype.do"

noi run "an_sankeynumbers"

do "an_factors_assoc_with_pos_ev"
*do "an_factors_assoc_with_pos_ev_QUICKVERSION"

do "an_table_fp_ofFAWcovpos"

do "an_univariate_amongtested.do"

do "an_multivariate_amongtested.do"

do "an_tablecontent_HRtable_HRforest_among_infected"




