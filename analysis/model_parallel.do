clear
import delimited `c(pwd)'/output/input.csv


set more off
cd  analysis


/*  Pre-analysis data manipulation  */

**********************************************
*IF PARALLEL WORKING - THIS MUST BE RUN FIRST*
**********************************************
do "cr_create_analysis_dataset.do" 

winexec "c:\program files\stata16\statamp-64.exe" do "an_outcomes" rates_agesex 
winexec "c:\program files\stata16\statamp-64.exe" do "an_outcomes" demog_cceth
winexec "c:\program files\stata16\statamp-64.exe" do "an_outcomes" demog_noeth
winexec "c:\program files\stata16\statamp-64.exe" do "an_outcomes" mv_cceth
winexec "c:\program files\stata16\statamp-64.exe" do "an_outcomes" mv_noeth
winexec "c:\program files\stata16\statamp-64.exe" do "an_outcomes" mv_addhepc

winexec "c:\program files\stata16\statamp-64.exe" do "an_interactions" byage
winexec "c:\program files\stata16\statamp-64.exe" do "an_interactions" bysex
winexec "c:\program files\stata16\statamp-64.exe" do "an_interactions" byethnicity
winexec "c:\program files\stata16\statamp-64.exe" do "an_interactions" byethnicity_wvsb
winexec "c:\program files\stata16\statamp-64.exe" do "an_interactions" bycomorbidities

winexec "c:\program files\stata16\statamp-64.exe" do "an_cumincidence" 

winexec "c:\program files\stata16\statamp-64.exe" do "an_phcheck_cc"
winexec "c:\program files\stata16\statamp-64.exe" do "an_sens_ccbmismok"
winexec "c:\program files\stata16\statamp-64.exe" do "an_impute" 

do "an_hiv_desccodes" 
do "an_desctable"
do "an_deschivdeaths_table" 


*MI for ethnicity

*wait for imputations to generate
forvalues i = 1/120{
sleep 60000
}

winexec "c:\program files\stata16\statamp-64.exe" do "an_imputed" demog
winexec "c:\program files\stata16\statamp-64.exe" do "an_imputed" full
winexec "c:\program files\stata16\statamp-64.exe" do "an_imputed" byage
winexec "c:\program files\stata16\statamp-64.exe" do "an_imputed" bysex
winexec "c:\program files\stata16\statamp-64.exe" do "an_imputed" byethnicity
winexec "c:\program files\stata16\statamp-64.exe" do "an_imputed" bycomorbidities
winexec "c:\program files\stata16\statamp-64.exe" do "an_imputed" bycomorbidities_exht
winexec "c:\program files\stata16\statamp-64.exe" do "an_imputed" cuminc

winexec "c:\program files\stata16\statamp-64.exe" do "an_phcheck_mi"

/*collate results once everything else has run
do "an_outcomes_table"
do "an_outcomes_MI_table"
do "an_forestplot_MI"
*/

