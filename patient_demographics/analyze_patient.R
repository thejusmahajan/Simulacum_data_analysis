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
# Assuming column name is 'GENDER'
if("GENDER" %in% names(df)) {
  df$GENDER_LABEL <- factor(df$GENDER, 
                            levels = c(0, 1, 2, 9), 
                            labels = c("Not known", "Male", "Female", "Not specified"))
  
  # Drop unused levels (Ghost Categories)
  df$GENDER_LABEL <- droplevels(df$GENDER_LABEL)
  
  gender_counts <- table(df$GENDER_LABEL)
  
  # Scale to Thousands
  gender_counts_scaled <- gender_counts / 1000
  
  print("Gender Counts (Thousands):")
  print(gender_counts_scaled)
  
  png(paste0(results_path, "gender_distribution.png"))
  # Disable scientific notation
  options(scipen=999)
  
  barplot(gender_counts_scaled, 
          main = "Patient Gender Distribution",
          xlab = "Gender",
          ylab = "Count (Thousands)",
          col = c("gray", "lightblue", "pink", "gray"))
  dev.off()
  print("Gender plot saved.")
} else {
  print("GENDER column not found.")
}

# 2. Vital Status Analysis
# Assuming 'VITALSTATUS'
if("VITALSTATUS" %in% names(df)) {
  
  # Clean Data: Aggregate D3, D4 etc. into 'D'
  # We treat anything starting with 'D' as Deceased, 'A' as Alive.
  # Filter out noise (X, etc.)
  df$VITAL_CLEAN <- ifelse(substr(df$VITALSTATUS, 1, 1) == "D", "Deceased",
                           ifelse(df$VITALSTATUS == "A", "Alive", NA))
  
  # Remove NAs (the noise codes)
  df_clean <- df[!is.na(df$VITAL_CLEAN), ]
  
  vital_counts <- table(df_clean$VITAL_CLEAN)
  
  # Scale to Thousands
  vital_counts_scaled <- vital_counts / 1000
  
  print("Vital Status Counts (Thousands):")
  print(vital_counts_scaled)
  
  png(paste0(results_path, "vital_status_distribution.png"))
  barplot(vital_counts_scaled, 
          main = "Patient Vital Status",
          xlab = "Status",
          ylab = "Count (Thousands)",
          col = c("lightgreen", "salmon"))
  dev.off()
  print("Vital status plot saved.")
} else {
  print("VITALSTATUS column not found.")
}

print("Analysis complete.")
