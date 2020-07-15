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
do "an_impute" 
do "an_imputed" demog
do "an_imputed" full
do "an_imputed" byage
do "an_imputed" bysex
do "an_imputed" byethnicity
do "an_imputed" bycomorbidities
do "an_imputed" cuminc

do "an_outcomes_table"
do "an_outcomes_mi_table"
do "an_foresplot_MI"

