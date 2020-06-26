import delimited `c(pwd)'/output/input.csv

* open log file *
cap log close
log using ./output/feasibility_count, replace t

* count number of rows *
count

log close
