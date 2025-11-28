# Dataset Description: sim_av_patient.csv
Date: 2025-11-12


## Overview
This dataset contains synthetic patient records from the Simulacrum v2.1.0. It represents the core demographic and vital status information for artificial cancer patients.

## Intent
We intend to perform a basic demographic analysis of this cohort. Specifically, we will:
1.  **Load the data** using R.
2.  **Clean the data** (check for missing values, convert data types).
3.  **Analyze Demographic Distribution**:
    -   Gender distribution (Male vs. Female).
    -   Vital status (Alive vs. Deceased).
4.  **Visualize** the findings using simple bar charts.

## Expected Results
-   **Gender**: We expect a roughly even split between males and females, though some cancers are gender-specific which might skew the total if the dataset is not perfectly balanced by design.
-   **Vital Status**: Given this is a cancer registry dataset, we expect a significant portion of patients to have a vital status of 'Deceased', reflecting the mortality associated with the disease.
