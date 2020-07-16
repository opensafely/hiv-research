


use "cr_create_analysis_dataset_STSET_onsdeath_fail1", clear

*xi: stpm2 hiv i.ethnicity $adjustmentlist, df(3) scale(hazard) eform
xi i.ethnicity $adjustmentlist 
stpm2 hiv age1 age2 age3 _I*, df(3) scale(hazard) eform 

summ _t
local tmax=r(max)
local tmaxplus1=r(max)+1

range timevar 0 `tmax' `tmaxplus1'
stpm2_standsurv if hiv==1 & ethnicity<., at1(hiv 0) at2(hiv 1) timevar(timevar) ci contrast(difference) fail



*This replicates the knots generation (needed after mi estimate, which drops them)
gen lnt = ln(_t) 
local bhknots = word(e(ln_bhknots),1) + " " + word(e(ln_bhknots),2) + " " + word(e(ln_bhknots),3) + " " + word(e(ln_bhknots),4) 
rcsgen lnt , knots(`bhknots') gen(_rcs) dgen(_d_rcs) orthog 



*Replicate prediction of a single survival prediction
use "cr_create_analysis_dataset_STSET_onsdeath_fail1", clear
xi i.ethnicity $adjustmentlist 
stpm2 hiv age1 age2 age3 _I*, df(3) scale(hazard) eform 
stpm2_pred surv, s

*replicate prediction of s
predict xb, xb
gen double mys = exp(-exp(xb))

assert mys == surv