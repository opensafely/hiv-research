
use cr_create_analysis_dataset, clear

replace cancer_exhaem = 2 + (uniform()>0.5) if uniform()<.2
replace cancer_exhaem = 4 if cancer_exhaem ==1 & uniform()<.1
replace cancer_haem = 2 + (uniform()>0.5) if uniform()<.2

replace diabcat = uniform()<.8
replace diabcat = 2 + floor(3*uniform()) if diabcat!=1
replace asthmacat = 2 + (uniform()>.5) if uniform()<.2

replace ethnicity = 1+(floor(5*uniform())) 
replace ethnicity_16 = 1+(floor(16*uniform())) 

replace reduced_kidney_function_cat=.
replace reduced_kidney_function_cat  = 1 if uniform()<0.5
replace reduced_kidney_function_cat  = 2 if uniform()<0.5 & reduced_kidney_function_cat==.
replace reduced_kidney_function_cat  = 3 if reduced_kidney_function_cat==.

save cr_create_analysis_dataset, replace

* Save a version set on ONS covid death outcome
stset stime_onsdeath, fail(onsdeath=1) 				///
	id(patient_id) enter(enter_date) origin(enter_date)

save "cr_create_analysis_dataset.dta_STSET_onsdeath_fail1", replace
