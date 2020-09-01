
winexec "c:\program files\stata16\statamp-64.exe" do "an_interactions" byethnicity_wvsb

winexec "c:\program files\stata16\statamp-64.exe" do "an_cumincidence" 

*MI for ethnicity
winexec "c:\program files\stata16\statamp-64.exe" do "an_imputed" demog_smokob
winexec "c:\program files\stata16\statamp-64.exe" do "an_imputed" byage
winexec "c:\program files\stata16\statamp-64.exe" do "an_imputed" bysex
winexec "c:\program files\stata16\statamp-64.exe" do "an_imputed" byethnicity
winexec "c:\program files\stata16\statamp-64.exe" do "an_imputed" bycomorbidities
winexec "c:\program files\stata16\statamp-64.exe" do "an_imputed" bycomorbidities_exht
winexec "c:\program files\stata16\statamp-64.exe" do "an_imputed" cuminc

winexec "c:\program files\stata16\statamp-64.exe" do "an_phcheck_cc"
*do "an_phcheck_mi"

*posthoc
winexec "c:\program files\stata16\statamp-64.exe" do an_phcheck_addtimeinteractions_cc

winexec "c:\program files\stata16\statamp-64.exe" do "an_sens_furtherexploration_bmismok" ccbmismok
winexec "c:\program files\stata16\statamp-64.exe" do "an_sens_furtherexploration_bmismok" ccbmionly
winexec "c:\program files\stata16\statamp-64.exe" do "an_sens_furtherexploration_bmismok" ccsmokonly

/*
do "an_outcomes_table"
do "an_outcomes_MI_table"
do "an_forestplot_MI"

