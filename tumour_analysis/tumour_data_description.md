# Dataset Description: sim_av_tumour.csv

## Overview
This dataset contains synthetic tumour records from the Simulacrum v2.1.0. It provides detailed information about cancer diagnoses, including the site of the tumour (ICD-10 code), morphology, stage, and diagnosis date.

## Intent
We intend to perform a biostatistical analysis of cancer characteristics in this cohort. Specifically, we will:
1.  **Load the data** using R.
2.  **Clean the data** (handle missing values, format dates).
3.  **Analyze Cancer Types**:
    -   Identify the most common cancer sites (using `SITE_ICD10_O2` or similar columns).
    -   Visualize the top 10 cancer types.
4.  **Analyze Staging**:
    -   Examine the distribution of cancer stages (e.g., Stage 1-4) at diagnosis.
    -   This is crucial for understanding early detection rates.

## Expected Results
-   **Cancer Types**: We expect to see common cancers like Breast (C50), Prostate (C61), Lung (C34), and Colorectal (C18-C20) dominating the counts.
-   **Staging**: We anticipate a distribution across all stages, with a significant proportion of "Unknown" or "Not Staged" entries, which is typical in real-world cancer registry data.
