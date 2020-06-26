from cohortextractor import (
    codelist_from_csv,
    codelist,
)

### CODELISTS
hiv_codes = codelist_from_csv(
    "codelists/opensafely-hiv.csv", system="ctv3", column="CTV3ID",
)