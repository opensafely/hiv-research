# HIV infection and COVID-19 death: 

This is the code and configuration for a study _HIV infection and COVID-19 death: a population-based cohort analysis of UK primary care data and linked national death registrations within the OpenSAFELY platform_.


* The paper is publish in the December issue of Lancet HIV and is [available here](https://doi.org/10.1016/S2352-3018(20)30305-2)
* Raw model outputs, including charts, crosstabs, etc, are in `released_analysis_results/`
* If you are interested in how we defined our variables, take a look at the [study definition](analysis/study_definition.py); this is written in `python`, but non-programmers should be able to understand what is going on there
* If you are interested in how we defined our code lists, look in the [codelists folder](./codelists/).A new tool called OpenCodelists was developed to allow codelists to be versioned and all of the codelists hosted online at codelists.opensafely.org for open inspection and re-use by anyone.
* Developers and epidemiologists interested in the code should review
the [OpenSAFELY documentation](https://docs.opensafely.org/en/latest/)

# About the OpenSAFELY framework

The OpenSAFELY framework is a new secure analytics platform for
electronic health records research in the NHS.

Instead of requesting access for slices of patient data and
transporting them elsewhere for analysis, the framework supports
developing analytics against dummy data, and then running against the
real data *within the same infrastructure that the data is stored*.
Read more at [OpenSAFELY.org](https://opensafely.org).

The framework is under fast, active development to support rapid
analytics relating to COVID19; we're currently seeking funding to make
it easier for outside collaborators to work with our system.  You can
read our current roadmap [here](ROADMAP.md).
