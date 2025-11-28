# Load necessary libraries
# We will use base R for simplicity as requested, or tidyverse if available. 
# Given the environment, we'll try to use standard plotting functions to be safe, 
# but if tidyverse is standard in this bioinfo environment, we can use it.
# Let's stick to base R for maximum compatibility unless we know otherwise.

# Define paths
data_path <- "data/sim_av_patient.csv"
results_path <- "results/"

# Load data
print(paste("Loading data from", data_path))
df <- read.csv(data_path)

# Inspect data
print("Data dimensions:")
print(dim(df))
print("First few rows:")
print(head(df))

# 1. Gender Analysis
# Assuming column name is 'GENDER' or similar. Let's check names first.
print("Column names:")
print(names(df))

# Based on Simulacrum schema, gender is usually 'GENDER' (0=Not known, 1=Male, 2=Female, 9=Not specified)
# Let's clean it up for plotting
if("GENDER" %in% names(df)) {
  df$GENDER_LABEL <- factor(df$GENDER, 
                            levels = c(0, 1, 2, 9), 
                            labels = c("Not known", "Male", "Female", "Not specified"))
  
  gender_counts <- table(df$GENDER_LABEL)
  print("Gender Counts:")
  print(gender_counts)
  
  png(paste0(results_path, "gender_distribution.png"))
  barplot(gender_counts, 
          main = "Patient Gender Distribution",
          xlab = "Gender",
          ylab = "Count",
          col = c("gray", "lightblue", "pink", "gray"))
  dev.off()
  print("Gender plot saved.")
} else {
  print("GENDER column not found.")
}

# 2. Vital Status Analysis
# Assuming 'VITALSTATUS' (A=Alive, D=Deceased)
if("VITALSTATUS" %in% names(df)) {
  vital_counts <- table(df$VITALSTATUS)
  print("Vital Status Counts:")
  print(vital_counts)
  
  png(paste0(results_path, "vital_status_distribution.png"))
  barplot(vital_counts, 
          main = "Patient Vital Status",
          xlab = "Status",
          ylab = "Count",
          col = c("lightgreen", "salmon"))
  dev.off()
  print("Vital status plot saved.")
} else {
  print("VITALSTATUS column not found.")
}

print("Analysis complete.")
