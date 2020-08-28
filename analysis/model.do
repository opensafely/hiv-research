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

do "an_desctable" 

do "an_outcomes" rates_agesex 
do "an_outcomes" demog_cceth
do "an_outcomes" demog_noeth
do "an_outcomes" mv_cceth
do "an_outcomes" mv_noeth
do "an_outcomes" mv_addhepc

do "an_interactions" byage
do "an_interactions" bysex
do "an_interactions" byethnicity
do "an_interactions" byethnicity_wvsb
do "an_interactions" bycomorbidities


do "an_deschivdeaths_table" 

do "an_cumincidence" 

*MI for ethnicity
do "an_impute" 
do "an_imputed" demog
do "an_imputed" full
do "an_imputed" fullplushepc
do "an_imputed" byage
do "an_imputed" bysex
do "an_imputed" byethnicity
do "an_imputed" bycomorbidities
do "an_imputed" bycomorbidities_exht
do "an_imputed" cuminc

do "an_phcheck_cc"
*do "an_phcheck_mi"

*posthoc
do an_phcheck_addtimeinteractions_cc

do "an_sens_ccbmismok"
*posthoc
do "an_sens_furtherexploration_bmismok" omitbmismok
do "an_sens_furtherexploration_bmismok" omitbmismokinccpop
do "an_sens_furtherexploration_bmismok" ccbmismok
do "an_sens_furtherexploration_bmismok" ccbmionly
do "an_sens_furtherexploration_bmismok" ccsmokonly


do "an_outcomes_table"
do "an_outcomes_MI_table"
do "an_forestplot_MI"

