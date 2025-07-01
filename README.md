Unified Synthea Dataset EUnified Synthea Dataset ETL Pipeline
This repository contains an ETL (Extract, Transform, Load) prototype developed to process and unify data from the Synthea synthetic healthcare dataset. Although the initial project scope changed, the implemented pipeline performs the following key steps:

Extraction: Selects and loads the main variables from multiple Synthea CSV datasets, including patient demographics, encounters, conditions, medications, procedures, claims, and others as needed.

Transformation: Filters and processes each dataset individually to retain the most relevant features for the intended analysis.

Unification: Merges the filtered datasets into a single consolidated DataFrame (df_unificado), enabling integrated analysis across different healthcare data domains.

- Dataset
The source data is based on the Synthea synthetic patient data generator, which exports multiple CSV files representing various healthcare entities such as allergies, care plans, claims, conditions, devices, encounters, medications, observations, providers, and more. Each CSV file contains detailed clinical and administrative data with standardized coding systems like SNOMED-CT and RxNorm.

- Purpose
This ETL process aims to create a unified view of patient healthcare data by combining key variables from diverse datasets. This consolidated dataset can be used for prototyping, exploratory data analysis, or as a foundation for building predictive healthcare models.

- Usage
Load individual CSV files from the Synthea output.

Join datasets in a an unified one, facilating future exploratory analysis studies.

Notes
The pipeline is adaptable to changes in project scope or data requirements.

The current implementation focuses on the main variables relevants to the original objective but can be extended to include additional fields or datasets as needed.

Dictionary:
https://github.com/synthetichealth/synthea/wiki/CSV-File-Data-Dictionary
