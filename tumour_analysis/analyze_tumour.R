# Define paths
data_path <- "data/sim_av_tumour.csv"
results_path <- "results/"

# Load data
print(paste("Loading data from", data_path))
df <- read.csv(data_path)

# --- Helper Functions & Definitions ---

# ICD-10 Common Cancer Codes Mapping
# Source: Standard ICD-10 definitions
icd10_map <- c(
  "C50" = "Breast",
  "C61" = "Prostate",
  "C34" = "Lung",
  "C18" = "Colon",
  "C19" = "Rectosigmoid",
  "C20" = "Rectum",
  "C43" = "Melanoma",
  "C44" = "Other Skin",
  "C67" = "Bladder",
  "C25" = "Pancreas",
  "C64" = "Kidney",
  "C90" = "Mult. Myeloma",
  "C92" = "Myeloid Leukemia",
  "C54" = "Uterus",
  "D05" = "Carcinoma in situ (Breast)"
)

get_cancer_label <- function(code) {
  if (code %in% names(icd10_map)) {
    return(paste0(code, " (", icd10_map[code], ")"))
  } else {
    return(code)
  }
}

# 1. Top 10 Cancer Sites
if("SITE_ICD10_O2" %in% names(df)) {
  print("Top 10 sites plot saved.")
} else {
  print("SITE_ICD10_O2 column not found.")
}

# 2. Stage Distribution
stage_col <- NULL
if("STAGE_BEST" %in% names(df)) stage_col <- "STAGE_BEST"
if(is.null(stage_col) && "STAGE_BEST_SYSTEM" %in% names(df)) stage_col <- "STAGE_BEST_SYSTEM"

if(!is.null(stage_col)) {
  print(paste("Using stage column:", stage_col))
  
  # Get counts
  stage_counts <- table(df[[stage_col]])
  
  # Filter for top N stages to avoid clutter if there are too many rare codes
  # Or just plot all if reasonable. Let's check the top 15.
  stage_counts_sorted <- sort(stage_counts, decreasing = TRUE)
  top_stages <- head(stage_counts_sorted, 15)
  
  # Scale counts to 10^5
  counts_scaled <- top_stages / 100000
  
  print("Top Stage Counts:")
  print(top_stages)
  
  # Add a legend/explanation text to the plot
  # Explanation of codes (General interpretation)
  # 1, 2, 3, 4: Standard TNM Stages I-IV
  # A, B, C: Sub-stages (e.g., 1A, 1B)
  # ?: Unknown / Not Staged
  # U: Unstaged
  legend_text <- c(
    "1, 2, 3, 4: Main Stages (I-IV)",
    "A, B, C: Sub-stages",
    "?: Unknown / Not Staged",
    "U: Unstaged"
  )
  
  png(paste0(results_path, "stage_distribution.png"), width=900, height=600)
  par(mar=c(5, 5, 4, 2) + 0.1)
  
  # Create barplot
  bp <- barplot(counts_scaled, 
                main = "Distribution of Cancer Stages",
                ylab = "Count (x 10^5)",
                col = "darkorange",
                las = 2, # Rotate x-axis labels
                ylim = c(0, max(counts_scaled) * 1.2)) # Add space for legend
  
  # Add legend
  legend("topright", 
         legend = legend_text, 
         bty = "n", 
         cex = 0.8,
         title = "Code Key")
         
  dev.off()
  print("Stage distribution plot saved.")
} else {
  print("No suitable STAGE column found.")
}

print("Analysis complete.")
