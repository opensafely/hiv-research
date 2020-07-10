clear
import delimited `c(pwd)'/output/input.csv


set more off
cd  analysis


/*  Pre-analysis data manipulation  */

**********************************************
*IF PARALLEL WORKING - THIS MUST BE RUN FIRST*
**********************************************
do "cr_create_analysis_dataset.do"



do "an_hiv_desccodes"

*do "an_hiv"

do "an_desctable"

do "an_outcomes"

do "an_interactions"

do "an_outcomes_table"

do "an_forestplot"

do "an_deschivdeaths_table"

do "an_cumincidence"

*MI for ethnicity

/*Matched cohort version
run "cr_matches"
do "cr_matchedcohort"
do "an_desctable_MC"
do "an_outcomes_MC"
do "an_interactions_MC"
do "an_outcomes_table_MC"
do "an_forestplot_MC"
do "an_cumincidence_MC"
*/
