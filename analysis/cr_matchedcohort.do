*cr_matchedcohort
*KB 9/7/2020

run global

use "cr_matches", clear

reshape long matchedto_, i(patient_id)

rename patient_id setid
rename matchedto patient_id

expand 2 if setid!=setid[_n-1], gen(expanded)
replace patient_id=setid if expanded==1
drop expanded

replace patient_id = -_n if patient_id==-999

merge 1:1 patient_id using "cr_create_analysis_dataset.dta", keep(match master)

sort setid patient_id
safecount if setid!=setid[_n+1] & patient_id<0
noi di r(N) " patients could not be matched at all"

drop if patient_id<0

stset stime_onsdeath, fail(onsdeath=1) 				///
	id(patient_id) enter(enter_date) origin(enter_date)

gsort setid -hiv patient_id

save cr_matchedcohort_STSET_onsdeath_fail1, replace 
