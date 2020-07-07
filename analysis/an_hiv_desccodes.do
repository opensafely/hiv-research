
clear
insheet using ../codelists/opensafely-hiv.csv
drop in 1
rename v1 hiv_code
rename v2 hiv_desc
keep hiv*
tempfile hivcodes
save `hivcodes'

use cr_create_analysis_dataset, clear

keep if hiv_code!=""

keep agegroup male hiv*

merge m:1 hiv_code using `hivcodes'

drop if _m==2

replace hiv_code = hiv_code + ": " + hiv_desc

preserve
table hiv_code male, replace
egen total = sum(table1)
bysort hiv_code: egen totalwithcode = sum(table1)
gen pctoftot = 100*totalwithcode/total
gen pctmale = 100*table1/totalwithcode
gsort -totalwithcode hiv_code
l hiv_code totalwithcode pctoftot if hiv_code!=hiv_code[_n-1]
reshape wide table1 pctmale totalwithcode pctoftot, i(hiv_code) j(male)
l hiv_code table10 pctmale0 table11 pctmale1 totalwithcode0
gen smalln = table10<=5|table11<=5
replace table10=. if smalln==1
replace table11=. if smalln==1
replace totalwithcode0=. if smalln==1

replace pctmale0=0 if pctmale0==.
replace pctmale1=0 if pctmale1==.


gsort -totalwithcode0

gen HIGHPCTFEMALE = pctmale0>=70

l hiv_code table10 pctmale0 table11 pctmale1 totalwithcode0 HIGH 

rename table10 WOMEN
rename table11 MEN
rename pctmale0 PCT_WOMEN
rename pctmale1 PCT_MEN

gen WOMEN_N_PCT = string(WOMEN, "%7.0f") + " (" + string(PCT_WOMEN, "%4.1f") + ")"
gen MEN_N_PCT = string(MEN, "%7.0f") + " (" + string(PCT_MEN, "%4.1f") + ")"

gen TOTAL_COLPCT = string(totalwithcode0, "%7.0f") + " (" + string(pctoftot0, "%4.1f") + ")"

log using ./output/an_hiv_desccodes, replace t
format %4.1f PCT*
noi l hiv_code WOMEN_N MEN_N  TOTAL_COL  

restore 


log close

*restore
