*an_forestplot
*KB 9/7/2020

run global 

use ./output/an_outcomes_table_ESTIMATES, clear

replace desc = "<60" if desc == "interac_NOTageover60"
replace desc = "60+" if desc == "interac_ageover60"

replace desc = "Males" if desc == "interac_NOTfemale"
replace desc = "Females" if desc == "interac_female"

replace desc = "Black" if desc == "interac_NOTnonblack"
replace desc = "Not Black" if desc == "interac_nonblack"

replace desc = "None" if desc == "interac_NOTanycomorbidity"
replace desc = "1 or more" if desc == "interac_anycomorbidity"

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

local rangemax = _N+3

scatter revorder hr, mc(black) || rcap lci uci revorder, hor lc(black)  						///
|| scatter revorder modeltextpos if _n>3, m(i) mlab(desc) mlabsize(vsmall)	mlabcol(black)	///
|| scatter revorder headertextpos if _n<=3, m(i) mlab(desc) mlabsize(vsmall)	mlabcol(black)	///
|| scatter revorder headertextpos, m(i) mlab(header) mlabsize(vsmall) mlabcol(black)	///
||, xscale(log) xline(1, lp(dash)) xlab(.5 1 2 4) legend(off) ytitle("") ylab(none) yscale(r(-2 `rangemax')) ysize(8) ///
xtitle("Hazard ratio and 95% CI") yscale(off)

graph export ./output/an_forestplot.svg, as(svg)