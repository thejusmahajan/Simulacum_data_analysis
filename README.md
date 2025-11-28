# Simulacrum Data Analysis

## Data Access
**Note:** The raw data files (`.csv`) are **not included** in this repository due to their size.
To run the analysis, you must have the Simulacrum data files stored locally in the appropriate `data/` subdirectories:
- `patient_demographics/data/sim_av_patient.csv`
- `tumour_analysis/data/sim_av_tumour.csv`

## Analysis

## Project Overview
This project involves the analysis of the Simulacrum dataset using R. The Simulacrum is a synthetic dataset that mimics the structure and statistical properties of cancer data held by the National Disease Registration Service (NDRS) in England, without containing any real patient information.

## Data Source & Citation
**Source:** [Background on the Simulacrum](https://simulacrum.healthdatainsight.org.uk/background-on-the-simulacrum/)

**Citation:**
> The Simulacrum is a collection of synthetic datasets that imitates patient records held by the National Disease Registration Service (NDRS), NHS England. It was developed by our synthetic data team at Health Data Insight CiC (HDI), with support from AstraZeneca (AZ) and IQVIA.

## Data Location
The raw data for this analysis is located at:
`/scratch/local1/bioinformatics_project/data/unprocessed`

## Objectives
- Perform exploratory data analysis (EDA) on the synthetic cancer records.
- Investigate tumor diagnoses, treatments, and genetic information.
- Use R for data cleaning, processing, and visualization.

## Tools
- **Language:** R
- **Libraries:** TBD (likely `tidyverse`, `ggplot2`, etc.)
