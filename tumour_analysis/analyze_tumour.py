import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import re

# Define paths
data_path = "data/sim_av_tumour.csv"
results_path = "results/"

print(f"Loading data from {data_path}")
try:
    df = pd.read_csv(data_path)
except FileNotFoundError:
    print("File not found.")
    exit()

# --- 1. Top 10 Invasive Cancer Sites ---
print("Analyzing Cancer Sites...")

# Extract 3-char code
df['SITE_MAIN'] = df['SITE_ICD10_O2'].str[:3]

# Filter 1: Keep only Invasive (Starts with 'C')
# "The Fix: Filter your dataset to include only codes starting with 'C'"
df_invasive = df[df['SITE_MAIN'].str.startswith('C', na=False)].copy()

# Filter 2: Exclude C44 (NMSC)
# "The Fix: Filter out C44 before plotting."
df_final = df_invasive[df_invasive['SITE_MAIN'] != 'C44'].copy()

# Count
site_counts = df_final['SITE_MAIN'].value_counts().head(10)

# Map codes to names (Simplified map for demo)
icd10_map = {
    "C50": "Breast", "C61": "Prostate", "C34": "Lung",
    "C18": "Colon", "C19": "Rectosigmoid", "C20": "Rectum",
    "C43": "Melanoma", "C67": "Bladder", "C25": "Pancreas",
    "C64": "Kidney", "C90": "Mult. Myeloma", "C92": "Myeloid Leukemia",
    "C54": "Uterus"
}
labels = [f"{code} ({icd10_map.get(code, code)})" for code in site_counts.index]

# Scale to Thousands (Consistency with previous fixes)
site_counts_scaled = site_counts / 1000

plt.figure(figsize=(10, 6))
sns.barplot(x=site_counts_scaled.values, y=labels, color="steelblue")
plt.title("Top 10 Invasive Cancer Sites (Excl. NMSC)", fontsize=14)
plt.xlabel("Count (Thousands)", fontsize=12)
plt.ylabel("ICD-10 Site", fontsize=12)
plt.tight_layout()
plt.savefig(f"{results_path}top_10_cancer_sites.png")
print("Top 10 plot saved.")


# --- 2. Distribution of Cancer Stages ---
print("Analyzing Stages...")

# Helper to clean stage
def clean_stage(stage):
    stage = str(stage).upper().strip()
    if stage in ['?', 'U', 'NAN', 'nan']:
        return 'Unknown'
    # Aggregate 1A, 1B -> 1
    # Regex to grab the first digit if it starts with 1, 2, 3, 4
    match = re.match(r'^([1-4])', stage)
    if match:
        return match.group(1)
    return 'Unknown' # Treat anything else as unknown for this high-level chart

# Apply cleaning
# Check which column has stage. Usually 'QUIP_T_STAGE' or similar in Simulacrum, 
# but let's check columns or assume a standard name if we can't see them.
# Based on previous R script, it might be 'T_BEST', 'STAGE_BEST', or similar.
# Let's look for a likely column.
stage_cols = [c for c in df.columns if 'STAGE' in c]
if stage_cols:
    target_col = stage_cols[0] # Pick the first one found, likely 'STAGE_BEST' or 'T_BEST'
    print(f"Using column '{target_col}' for staging.")
    
    df['STAGE_CLEAN'] = df[target_col].apply(clean_stage)
    
    # Define Order: 1, 2, 3, 4, Unknown
    stage_order = ['1', '2', '3', '4', 'Unknown']
    
    # Count
    stage_counts = df['STAGE_CLEAN'].value_counts()
    
    # Reindex to enforce order (fill missing with 0)
    stage_counts = stage_counts.reindex(stage_order, fill_value=0)
    
    # Scale
    stage_counts_scaled = stage_counts / 1000
    
    plt.figure(figsize=(8, 6))
    sns.barplot(x=stage_counts_scaled.index, y=stage_counts_scaled.values, color="seagreen")
    
    plt.title("Distribution of Cancer Stages", fontsize=14)
    plt.xlabel("Stage", fontsize=12)
    plt.ylabel("Count (Thousands)", fontsize=12)
    plt.tight_layout()
    plt.savefig(f"{results_path}stage_distribution.png")
    print("Stage plot saved.")
    
else:
    print("No STAGE column found. Skipping stage plot.")
