import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Define paths
data_path = "data/sim_av_patient.csv"
results_path = "results/"

print(f"Loading data from {data_path}")
try:
    df = pd.read_csv(data_path)
except FileNotFoundError:
    print("File not found.")
    exit()

# --- 1. Gender Analysis ---
print("Analyzing Gender...")
if "GENDER" in df.columns:
    # Map gender codes
    gender_map = {0: "Not known", 1: "Male", 2: "Female", 9: "Not specified"}
    df['GENDER_LABEL'] = df['GENDER'].map(gender_map)
    
    # Filter out empty/unknown categories if they are effectively zero or redundant
    # The user requested removing "Ghost Categories"
    # Let's keep only Male and Female for the main comparison, or combine unknowns
    # But strictly following the user: "If the count is 0, remove the category."
    
    # Count
    gender_counts = df['GENDER_LABEL'].value_counts()
    
    # Remove zero counts (Strictly)
    gender_counts = gender_counts[gender_counts > 0]
    
    # Scale to Thousands
    gender_counts_scaled = gender_counts / 1000
    
    plt.figure(figsize=(8, 6))
    # Use simple colors
    colors = ['lightblue' if x == 'Male' else 'pink' if x == 'Female' else 'gray' for x in gender_counts_scaled.index]
    
    # FIX: Plot the SCALED values
    # FIX: Plot the SCALED values
    ax = sns.barplot(x=gender_counts_scaled.index, y=gender_counts_scaled.values, palette=colors)
    
    plt.title("Patient Gender Distribution", fontsize=14)
    plt.xlabel("Gender", fontsize=12)
    plt.ylabel("Count (Thousands)", fontsize=12)
    
    # Disable scientific notation is automatic in matplotlib for these scales usually, 
    # but scaling by 1000 ensures it.
    
    plt.tight_layout()
    plt.savefig(f"{results_path}gender_distribution.png")
    print("Gender plot saved.")

# --- 2. Vital Status Analysis ---
print("Analyzing Vital Status...")
if "VITALSTATUS" in df.columns:
    # Clean Data: Map D3, D4, etc. to D
    # "The Fix: You must aggregate your data."
    df['VITAL_CLEAN'] = df['VITALSTATUS'].apply(lambda x: 'D' if str(x).startswith('D') else ('A' if str(x) == 'A' else 'Other'))
    
    # Filter out 'Other' if it's junk (X, X2 etc) or map them if known. 
    # User said: "Map D3... into D... or filter them out".
    # Let's keep only A and D as they are the main ones.
    df_vital = df[df['VITAL_CLEAN'].isin(['A', 'D'])].copy()
    
    # Map to full names
    df_vital['STATUS_LABEL'] = df_vital['VITAL_CLEAN'].map({'A': 'Alive', 'D': 'Deceased'})
    
    vital_counts = df_vital['STATUS_LABEL'].value_counts()
    
    # Scale to Thousands
    vital_counts_scaled = vital_counts / 1000
    
    plt.figure(figsize=(8, 6))
    colors = ['lightgreen' if x == 'Alive' else 'salmon' for x in vital_counts_scaled.index]
    
    # FIX: Plot the SCALED values
    sns.barplot(x=vital_counts_scaled.index, y=vital_counts_scaled.values, palette=colors)
    
    plt.title("Patient Vital Status", fontsize=14)
    plt.xlabel("Status", fontsize=12)
    plt.ylabel("Count (Thousands)", fontsize=12)
    
    plt.tight_layout()
    plt.savefig(f"{results_path}vital_status_distribution.png")
    print("Vital status plot saved.")
