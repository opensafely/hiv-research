
*cr_matches
*KB 9/7/2020

run global

set seed 485298

frames reset
use cr_create_analysis_dataset,clear

keep patient_id stp male age hiv

frame put if hiv==1, into(tomatch)
keep if hiv==0
frame rename default pool
for num 1/10 : frame tomatch: gen long matchedto_X=.
frame tomatch: gen u=uniform()
frame tomatch: sort u

frame tomatch: qui cou
local totaltomatch = r(N)

forvalues matchnum = 1/10{
noi di "Getting match number `matchnum's"

	forvalues i = 1/`totaltomatch' {
		if mod(`i',100)==0 noi di "." _cont
		if mod(`i',1000)==0 noi di "`i'" _cont

		frame tomatch: scalar idtomatch = patient_id[`i']
		frame tomatch: scalar TMmale = male[`i']
		frame tomatch: scalar TMage = age[`i']
		frame tomatch: scalar TMstp = stp[`i']

		cap frame drop eligiblematches
		frame put if male==TMmale & stp==TMstp & abs(age-TMage)<=3, into(eligiblematches)
		frame eligiblematches: cou
		if r(N)>=1{
			frame eligiblematches: gen u=uniform()
			frame eligiblematches: gen agediff=abs(age-TMage)
			frame eligiblematches: sort agediff u
			frame eligiblematches: scalar selectedmatch = patient_id[1]
		}
		else scalar selectedmatch = -999

		frame tomatch: replace matchedto_`matchnum' = selectedmatch in `i'
		drop if patient_id==selectedmatch

	}
}

frame change tomatch
keep patient_id matchedto*

save cr_matches, replace