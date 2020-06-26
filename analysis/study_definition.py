from cohortextractor import (
    StudyDefinition,
    patients,
    filter_codes_by_category,
    combine_codelists,
)

from codelists import *

study = StudyDefinition(
    # Configure the expectations framework
    default_expectations={
        "date": {"earliest": "1900-01-01", "latest": "today"},
        "rate": "uniform",
        "incidence": 0.5,
    },

    # STUDY POPULATION
    population=patients.satisfying(
        """
            has_follow_up AND
            hiv
        """,
        has_follow_up=patients.registered_with_one_practice_between(
                    "2019-02-28", "2020-02-29"
        ),
        hiv=patients.with_these_clinical_events(
            hiv_codes,
            on_or_before="2020-02-29",
        ),
    ),

    # BASIC DEMOGRAPHICS
    age=patients.age_as_of(
        "2020-03-01",
        return_expectations={
            "rate": "universal",
            "int": {"distribution": "population_ages"},
        },
    ),

    sex=patients.sex(
        return_expectations={
            "rate": "universal",
            "category": {"ratios": {"M": 0.49, "F": 0.51}},
        },
    ),
)