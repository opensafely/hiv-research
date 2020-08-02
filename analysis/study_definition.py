from cohortextractor2 import (
    StudyDefinition,
    patients,
    codelist_from_csv,
    codelist,
    filter_codes_by_category,
)


## CODE LISTS
# All codelist are held within the codelist/ folder.
from codelists import *

## STUDY POPULATION
# Defines both the study population and points to the important covariates

study = StudyDefinition(
    default_expectations={
        "date": {"earliest": "1970-01-01", "latest": "today"},
        "rate": "uniform",
        "incidence": 0.2,
    },
    # This line defines the study population
    population=patients.registered_with_one_practice_between(
        "2019-02-01", "2020-02-01"
    ),
    # Outcomeshiv
    cpns_died_date=patients.with_death_recorded_in_cpns(
        returning="date_of_death",
        include_month=True,
        include_day=True,
        return_expectations={"date": {"earliest": "2020-03-01"}},
    ),

    died_ons_covid_flag_any=patients.with_these_codes_on_death_certificate(
        covid_codelist,
        on_or_before="2020-07-01",
        match_only_underlying_cause=False,
        return_expectations={"date": {"earliest": "2020-03-01"}},
    ),
    died_ons_covid_flag_underlying=patients.with_these_codes_on_death_certificate(
        covid_codelist,
        on_or_before="2020-07-01",
        match_only_underlying_cause=True,
        return_expectations={"date": {"earliest": "2020-03-01"}},
    ),
    ons_died_date_=patients.died_from_any_cause(
        on_or_before="2020-07-01",
        returning="date_of_death",
        include_month=True,
        include_day=True,
        return_expectations={"date": {"earliest": "2020-03-01"}},
    ),
    
    covid_admission_date=patients.admitted_to_hospital(
        returning= "date_admitted" ,  # defaults to "binary_flag"
        with_these_diagnoses=covid_codelist,  # optional
        on_or_after="2020-02-01",
        find_first_match_in_period=True,  
        date_format="YYYY-MM-DD",  
        return_expectations={"date": {"earliest": "2020-03-01"}},
   ),

    covid_admission_primary_diagnosis=patients.admitted_to_hospital(
        returning="primary_diagnosis",
        with_these_diagnoses=covid_codelist,  # optional
        on_or_after="2020-02-01",
        find_first_match_in_period=True,  
        date_format="YYYY-MM-DD", 
        return_expectations={
            "date": {"earliest": "2020-03-01"},
            "category": {"ratios": {"I21":0.5, "C34":0.5}},
        },
   ),

    covid_admission_discharge_date=patients.admitted_to_hospital(
        returning= "date_admitted" ,  # defaults to "binary_flag"
        with_these_diagnoses=covid_codelist,  # optional
        on_or_after="2020-02-01",
        find_first_match_in_period=True,  
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "2020-03-01"}},
   ),

    covid_confirmed_admission_date=patients.admitted_to_hospital(
        returning= "date_admitted" ,  # defaults to "binary_flag"
        with_these_diagnoses=covidconf_codelist,  # optional
        on_or_after="2020-02-01",
        find_first_match_in_period=True,  
        date_format="YYYY-MM-DD",  
        return_expectations={"date": {"earliest": "2020-03-01"}},
    ),  
    
    any_admission_primary_diagnosis = patients.admitted_to_hospital(
    returning="primary_diagnosis", 
    on_or_after="2002-02-01",  
    find_first_match_in_period=True,  
    date_format="YYYY-MM-DD",  
    return_expectations={
            "date": {"earliest": "2020-03-01"},
            "category": {"ratios": {"I21":0.5, "C34":0.5}},
        },
    ),

    any_admission_date = patients.admitted_to_hospital(
    returning="date_admitted", 
    on_or_after="2002-02-01",  
    find_first_match_in_period=True,  
    date_format="YYYY-MM-DD",  
    return_expectations={
            "date": {"earliest": "2020-03-01"},
            "category": {"ratios": {"I21":0.5, "C34":0.5}},
        },
    ),

    
    sgss_first_positive_test_date=patients.with_test_result_in_sgss(
        pathogen="SARS-CoV-2",
        test_result="positive",
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "2020-03-01"}},
    ),  
    covid_clinical_or_nos=patients.with_these_clinical_events(
        covid_clinical_or_nos_codes,
        returning="category",
        find_first_match_in_period=True,
        include_date_of_match=True,
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {"earliest": "2020-03-01"},
            "category": {"ratios": {"A795.":0.5, "Y22aa":0.5}},
            },
    ),   
    covid_positive_test=patients.with_these_clinical_events(
        covid_positive_test_codes,
        returning="category",
        find_first_match_in_period=True,
        include_date_of_match=True,
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {"earliest": "2020-03-01"},
            "category": {"ratios": {"XaLTE":0.5, "Y20d1":0.5}},
            },
    ),     
    covid_sequelae=patients.with_these_clinical_events(
        covid_sequelae_codes,
        returning="category",
        find_first_match_in_period=True,
        include_date_of_match=True,
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {"earliest": "2020-03-01"},
            "category": {"ratios": {"Y20fb":0.5, "Y20fc":0.5}},
            },
    ),
    

    
    # The rest of the lines define the covariates with associated GitHub issues
    # https://github.com/ebmdatalab/tpp-sql-notebook/issues/33
    age=patients.age_as_of(
        "2020-02-01",
        return_expectations={
            "rate": "universal",
            "int": {"distribution": "population_ages"},
        },
    ),
    # https://github.com/ebmdatalab/tpp-sql-notebook/issues/46
    sex=patients.sex(
        return_expectations={
            "rate": "universal",
            "category": {"ratios": {"M": 0.49, "F": 0.51}},
        }
    ),
    # https://github.com/ebmdatalab/tpp-sql-notebook/issues/52
    imd=patients.address_as_of(
        "2020-02-01",
        returning="index_of_multiple_deprivation",
        round_to_nearest=100,
        return_expectations={
            "rate": "universal",
            "category": {"ratios": {"100": 0.1, "200": 0.2, "300": 0.7}},
        },
    ),
    # https://github.com/ebmdatalab/tpp-sql-notebook/issues/54
    stp=patients.registered_practice_as_of(
        "2020-02-01",
        returning="stp_code",
        return_expectations={
            "rate": "universal",
            "category": {
                "ratios": {
                    "STP1": 0.1,
                    "STP2": 0.1,
                    "STP3": 0.1,
                    "STP4": 0.1,
                    "STP5": 0.1,
                    "STP6": 0.1,
                    "STP7": 0.1,
                    "STP8": 0.1,
                    "STP9": 0.1,
                    "STP10": 0.1,
                }
            },
        },
    ),
    # region - one of NHS England 9 regions
    region=patients.registered_practice_as_of(
        "2020-02-01",
        returning="nuts1_region_name",
        return_expectations={
            "rate": "universal",
            "category": {
                "ratios": {
                    "North East": 0.1,
                    "North West": 0.1,
                    "Yorkshire and the Humber": 0.1,
                    "East Midlands": 0.1,
                    "West Midlands": 0.1,
                    "East of England": 0.1,
                    "London": 0.2,
                    "South East": 0.2,
                },
            },
        },
    ),

    # https://github.com/ebmdatalab/tpp-sql-notebook/issues/10
    bmi=patients.most_recent_bmi(
        on_or_after="2010-02-01",
        minimum_age_at_measurement=16,
        include_measurement_date=True,
        include_month=True,
        return_expectations={
            "date": {},
            "float": {"distribution": "normal", "mean": 35, "stddev": 10},
            "incidence": 0.95,
        },
    ),
    # https://github.com/ebmdatalab/tpp-sql-notebook/issues/6
    smoking_status=patients.categorised_as(
        {
            "S": "most_recent_smoking_code = 'S'",
            "E": """
                 most_recent_smoking_code = 'E' OR (
                   most_recent_smoking_code = 'N' AND ever_smoked
                 )
            """,
            "N": "most_recent_smoking_code = 'N' AND NOT ever_smoked",
            "M": "DEFAULT",
        },
        return_expectations={
            "category": {"ratios": {"S": 0.6, "E": 0.1, "N": 0.2, "M": 0.1}}
        },
        most_recent_smoking_code=patients.with_these_clinical_events(
            clear_smoking_codes,
            find_last_match_in_period=True,
            on_or_before="2020-02-01",
            returning="category",
        ),
        ever_smoked=patients.with_these_clinical_events(
            filter_codes_by_category(clear_smoking_codes, include=["S", "E"]),
            on_or_before="2020-02-01",
        ),
    ),

    # https://github.com/ebmdatalab/tpp-sql-notebook/issues/27
    ethnicity=patients.with_these_clinical_events(
        ethnicity_codes,
        returning="category",
        find_last_match_in_period=True,
        include_date_of_match=True,
        return_expectations={
            "category": {"ratios": {"1": 0.8, "2":0.05, "3":0.05, "4":0.05, "5": 0.05}},
            "incidence": 0.75,
        },
    ),
    ethnicity_16=patients.with_these_clinical_events(
        ethnicity_codes_16,
        returning="category",
        find_last_match_in_period=True,
        include_date_of_match=True,
        return_expectations={
            "category": {"ratios": {"1": 0.8, "5": 0.1, "3": 0.1}},
            "incidence": 0.75,
        },
    ),
    # https://github.com/ebmdatalab/tpp-sql-notebook/issues/21
    chronic_resp_disease_date=patients.with_these_clinical_events(
        chronic_respiratory_disease_codes,
        return_first_date_in_period=True,
        include_month=True,
    ),
    # https://github.com/ebmdatalab/tpp-sql-notebook/issues/55
    asthma=patients.categorised_as(
        {
            "0": "DEFAULT",
            "1": """
                (
                  recent_asthma_code OR (
                    asthma_code_ever AND NOT
                    copd_code_ever
                  )
                ) AND (
                  prednisolone_last_year = 0 OR 
                  prednisolone_last_year > 4
                )
            """,
            "2": """
                (
                  recent_asthma_code OR (
                    asthma_code_ever AND NOT
                    copd_code_ever
                  )
                ) AND
                prednisolone_last_year > 0 AND
                prednisolone_last_year < 5
                
            """,
        },
        return_expectations={"category": {"ratios": {"0": 0.8, "1": 0.1, "2": 0.1}}, "incidence": 1.00,},
        recent_asthma_code=patients.with_these_clinical_events(
            asthma_codes, between=["2017-02-01", "2020-02-01"],
        ),
        asthma_code_ever=patients.with_these_clinical_events(asthma_codes),
        copd_code_ever=patients.with_these_clinical_events(
            chronic_respiratory_disease_codes
        ),
        prednisolone_last_year=patients.with_these_medications(
            pred_codes,
            between=["2019-02-01", "2020-02-01"],
            returning="number_of_matches_in_period",
        ),
    ),
    # https://github.com/ebmdatalab/tpp-sql-notebook/issues/7
    chronic_cardiac_disease_date=patients.with_these_clinical_events(
        chronic_cardiac_disease_codes,
        return_first_date_in_period=True,
        include_month=True,
    ),
    # https://github.com/ebmdatalab/tpp-sql-notebook/issues/30
    diabetes_date=patients.with_these_clinical_events(
        diabetes_codes, return_first_date_in_period=True, include_month=True,
    ),
    # https://github.com/ebmdatalab/tpp-sql-notebook/issues/32
    lung_cancer_date=patients.with_these_clinical_events(
        lung_cancer_codes, return_first_date_in_period=True, include_month=True,
    ),
    haem_cancer_date=patients.with_these_clinical_events(
        haem_cancer_codes, return_first_date_in_period=True, include_month=True,
        return_expectations={
           "date": {"earliest": "2010-01-01", "latest": "2020-02-01"},
        },
    ),
    other_cancer_date=patients.with_these_clinical_events(
        other_cancer_codes, return_first_date_in_period=True, include_month=True,
        return_expectations={
           "date": {"earliest": "2010-01-01", "latest": "2020-02-01"},
        },
    ),

    # # https://github.com/ebmdatalab/tpp-sql-notebook/issues/12
    chronic_liver_disease_date=patients.with_these_clinical_events(
        chronic_liver_disease_codes,
        return_first_date_in_period=True,
        include_month=True,
    ),
    # # https://github.com/ebmdatalab/tpp-sql-notebook/issues/14
    other_neuro_date=patients.with_these_clinical_events(
        other_neuro, return_first_date_in_period=True, include_month=True,
    ),
    stroke_date=patients.with_these_clinical_events(
        stroke, return_first_date_in_period=True, include_month=True,
    ),
    dementia_date=patients.with_these_clinical_events(
        dementia, return_first_date_in_period=True, include_month=True,
    ),
    # # Chronic kidney disease
    # https://github.com/ebmdatalab/tpp-sql-notebook/issues/17
    creatinine=patients.with_these_clinical_events(
        creatinine_codes,
        find_last_match_in_period=True,
        on_or_before="2020-02-01",
        returning="numeric_value",
        include_date_of_match=True,
        include_month=True,
        return_expectations={
            "float": {"distribution": "normal", "mean": 60.0, "stddev": 60},
            "date": {"earliest": "2019-02-28", "latest": "2020-02-29"},
            "incidence": 0.95,
        },
    ),
    dialysis_date=patients.with_these_clinical_events(
        dialysis_codes, return_first_date_in_period=True, include_month=True,
    ),
    # https://github.com/ebmdatalab/tpp-sql-notebook/issues/31
    organ_transplant_date=patients.with_these_clinical_events(
        organ_transplant_codes, return_first_date_in_period=True, include_month=True,
    ),
    # https://github.com/ebmdatalab/tpp-sql-notebook/issues/13
    dysplenia_date=patients.with_these_clinical_events(
        spleen_codes, return_first_date_in_period=True, include_month=True,
    ),
    sickle_cell_date=patients.with_these_clinical_events(
        sickle_cell_codes, return_first_date_in_period=True, include_month=True,
    ),
    # https://github.com/ebmdatalab/tpp-sql-notebook/issues/36
    aplastic_anaemia_date=patients.with_these_clinical_events(
        aplastic_codes, return_last_date_in_period=True, include_month=True,
    ),
    hiv=patients.with_these_clinical_events(
        hiv_codes,
        returning="category",
        on_or_before="2020-02-01",
        find_first_match_in_period=True, 
        include_date_of_match=True,
        include_month=True,
        return_expectations={
            "category": {"ratios": {"Xa0ye": 0.8, "43C3.": 0.2}},
            },
    ),   
    hepc=patients.with_these_clinical_events(
        hepc_codes,
        returning="category",
        find_first_match_in_period=True,
        include_date_of_match=True,
        include_month=True,
        return_expectations={
            "category": {"ratios": {"A70z0": 0.8, "X306e": 0.2}},
            },
    ),   
    permanent_immunodeficiency_date=patients.with_these_clinical_events(
        permanent_immune_codes, return_first_date_in_period=True, include_month=True,
    ),
    temporary_immunodeficiency_date=patients.with_these_clinical_events(
        temp_immune_codes, return_last_date_in_period=True, include_month=True,
    ),
    # https://github.com/ebmdatalab/tpp-sql-notebook/issues/23
    # immunosuppressant_med=
    # hypertension
    hypertension_date=patients.with_these_clinical_events(
        hypertension_codes, return_first_date_in_period=True, include_month=True,
    ),
    # Blood pressure
    # https://github.com/ebmdatalab/tpp-sql-notebook/issues/35
    bp_sys=patients.mean_recorded_value(
        systolic_blood_pressure_codes,
        on_most_recent_day_of_measurement=True,
        on_or_before="2020-02-01",
        include_measurement_date=True,
        include_month=True,
        return_expectations={
            "float": {"distribution": "normal", "mean": 80, "stddev": 10},
            "date": {"latest": "2020-02-29"},
            "incidence": 0.95,
        },
    ),
    bp_dias=patients.mean_recorded_value(
        diastolic_blood_pressure_codes,
        on_most_recent_day_of_measurement=True,
        on_or_before="2020-02-01",
        include_measurement_date=True,
        include_month=True,
        return_expectations={
            "float": {"distribution": "normal", "mean": 120, "stddev": 10},
            "date": {"latest": "2020-02-29"},
            "incidence": 0.95,
        },
    ),
    hba1c_mmol_per_mol=patients.with_these_clinical_events(
        hba1c_new_codes,
        find_last_match_in_period=True,
        on_or_before="2020-02-01",
        returning="numeric_value",
        include_date_of_match=True,
        include_month=True,
        return_expectations={
            "date": {"earliest": "2019-01-01", "latest": "2020-02-01"},
            "float": {"distribution": "normal", "mean": 40.0, "stddev": 20},
            "incidence": 0.70,
        },
    ),
    hba1c_percentage=patients.with_these_clinical_events(
        hba1c_old_codes,
        find_last_match_in_period=True,
        on_or_before="2020-02-01",
        returning="numeric_value",
        include_date_of_match=True,
        include_month=True,
        return_expectations={
            "date": {"earliest": "2019-01-01", "latest": "2020-02-01"},
            "float": {"distribution": "normal", "mean": 5, "stddev": 2},
            "incidence": 0.70,
        },
    ),
    # # https://github.com/ebmdatalab/tpp-sql-notebook/issues/49
    ra_sle_psoriasis_date=patients.with_these_clinical_events(
        ra_sle_psoriasis_codes, return_first_date_in_period=True, include_month=True,
    ),

)
