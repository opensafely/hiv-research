*an_forestplot
*KB 9/7/2020

run global 

use ./output/an_outcomes_MI_table_ESTIMATES, clear

replace desc = "Age-sex adjusted" if substr(desc,1,16) == "Age-sex_adjusted"
replace desc = "+ IMD/ethnicity" if substr(desc,1,14) == "+IMD/ethnicity"
replace desc = "+ obesity/smoking/comorbidities" if substr(desc,1,30) == "+obesity/smoking/comorbidities"

replace desc = "<60" if substr(desc,1,20) == "interac_NOTageover60"
replace desc = "60+" if substr(desc,1,17) == "interac_ageover60"

replace desc = "Males" if substr(desc,1,17) == "interac_NOTfemale"
replace desc = "Females" if substr(desc,1,14) == "interac_female"

replace desc = "Black" if substr(desc,1,19) == "interac_NOTnonblack"
replace desc = "Not Black" if substr(desc,1,16) == "interac_nonblack"

replace desc = "None" if substr(desc,1,25) == "interac_NOTanycomorbidity"
replace desc = "1 or more" if substr(desc,1,22) == "interac_anycomorbidity"

gen obsorder=_n
expand 2 if desc=="<60"|desc=="Males"|desc=="Black"|desc=="None", gen(expanded)
gen header = "By age" if expanded==1 & desc=="<60"
replace header = "By sex" if expanded==1 & desc=="Males"
replace header = "By ethnicity" if expanded==1 & desc=="Black"
replace header = "By comorbidities" if expanded==1 & desc=="None"
expand 2 if header!="", gen(expanded2)
replace header="" if expanded2==1
replace desc="" if expanded==1|expanded2==1
for var hr lci uci: replace X=. if expanded==1
gsort obsorder -expanded2 -expanded

gen revorder = _N-_n+1

gen modeltextpos = .125
gen headertextpos = .09
gen pinttextpos = 5
local rangemax = _N+3

gen pintstr = "p-interaction " + string(pint, "%4.2f")

scatter revorder hr, mc(black) || rcap lci uci revorder, hor lc(black)  						///
|| scatter revorder modeltextpos if _n>3, m(i) mlab(desc) mlabsize(vsmall)	mlabcol(black)	///
|| scatter revorder headertextpos if _n<=3, m(i) mlab(desc) mlabsize(vsmall)	mlabcol(black)	///
|| scatter revorder headertextpos, m(i) mlab(header) mlabsize(vsmall) mlabcol(black)	///
|| scatter revorder pinttextpos if header!="", m(i) mlab(pintstr) mlabcol(black) mlabsize(vsmall) ///
||, xscale(log r(16)) xline(1, lp(dash)) xlab(.5 1 2 4) legend(off) ytitle("") ylab(none) yscale(r(-2 `rangemax')) ysize(8) ///
xtitle("Hazard ratio and 95% CI") yscale(off)

graph export ./output/an_forestplot_MI.svg, as(svg) replace
