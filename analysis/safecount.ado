
cap prog drop safecount
prog define safecount, byable(recall) rclass

marksample touse
local if " if `touse'"

local ifpos = strpos("`0'", "if ")
local inpos = strpos("`0'", "in ")

if `inpos'>0 & `ifpos'>1 {
	noi di in red "if cannot be combined with in"
	error 999
	}
	
if `ifpos'>0 local if "`0' & `touse'"

qui cou `if' `in'
if r(N)>5 {
count `if' `in'
scalar count = r(N)
}
else {
scalar count = .
noi di in yellow _n "** COUNT <=5 **"
}
return scalar N = count
end
