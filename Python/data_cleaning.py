"""
Banking Business Intelligence - Data Cleaning Script
Phase 3: Data Preprocessing with Pandas
Author: Portfolio Project
"""

import pandas as pd
import numpy as np

# ─────────────────────────────────────────────
# 1. IMPORT DATASET
# ─────────────────────────────────────────────
print("=" * 55)
print("   BANKING BI - DATA CLEANING PIPELINE")
print("=" * 55)

df = pd.read_csv("../Dataset/banking_raw.csv")

print(f"\n[1] Dataset Loaded")
print(f"    Rows    : {df.shape[0]:,}")
print(f"    Columns : {df.shape[1]}")
print(f"\n    Columns : {list(df.columns)}")

# ─────────────────────────────────────────────
# 2. BASIC STATISTICS (Before Cleaning)
# ─────────────────────────────────────────────
print("\n" + "─" * 55)
print("[2] Basic Statistics (Raw Dataset)")
print("─" * 55)

print("\n  Data Types:")
print(df.dtypes.to_string())

print("\n  Descriptive Statistics:")
print(df.describe(include="all").T.to_string())

print("\n  Missing Values (Before Cleaning):")
missing = df.isnull().sum()
missing_pct = (missing / len(df) * 100).round(2)
missing_df = pd.DataFrame({
    "Missing Count": missing,
    "Missing %": missing_pct
})
print(missing_df[missing_df["Missing Count"] > 0].to_string())

print(f"\n  Duplicate Rows: {df.duplicated().sum()}")

# ─────────────────────────────────────────────
# 3. HANDLE MISSING VALUES
# ─────────────────────────────────────────────
print("\n" + "─" * 55)
print("[3] Handling Missing Values")
print("─" * 55)

# Balance: fill with median (skewed distribution)
median_balance = df["Balance"].median()
df["Balance"] = df["Balance"].fillna(median_balance)
print(f"  Balance  → filled with median: {median_balance:,.2f}")

# EstimatedSalary: fill with median
median_salary = df["EstimatedSalary"].median()
df["EstimatedSalary"] = df["EstimatedSalary"].fillna(median_salary)
print(f"  Salary   → filled with median: {median_salary:,.2f}")

# CreditScore: fill with median
median_credit = df["CreditScore"].median()
df["CreditScore"] = df["CreditScore"].fillna(median_credit)
print(f"  Credit   → filled with median: {median_credit:,.0f}")

print(f"\n  Missing after treatment: {df.isnull().sum().sum()}")

# ─────────────────────────────────────────────
# 4. REMOVE DUPLICATES
# ─────────────────────────────────────────────
print("\n" + "─" * 55)
print("[4] Removing Duplicates")
print("─" * 55)

before = len(df)
df = df.drop_duplicates()
after = len(df)
print(f"  Removed : {before - after} duplicate rows")
print(f"  Rows remaining: {after:,}")

# ─────────────────────────────────────────────
# 5. FEATURE ENGINEERING
# ─────────────────────────────────────────────
print("\n" + "─" * 55)
print("[5] Feature Engineering")
print("─" * 55)

# Age Group
bins = [0, 25, 35, 45, 55, 65, 100]
labels = ["18-25", "26-35", "36-45", "46-55", "56-65", "65+"]
df["AgeGroup"] = pd.cut(df["Age"], bins=bins, labels=labels, right=True)
print("  AgeGroup  → created (18-25, 26-35, 36-45, 46-55, 56-65, 65+)")

# Balance Segment
def balance_segment(bal):
    if bal == 0:
        return "Zero Balance"
    elif bal < 50000:
        return "Low (<50K)"
    elif bal < 100000:
        return "Medium (50K-100K)"
    elif bal < 150000:
        return "High (100K-150K)"
    else:
        return "Premium (>150K)"

df["BalanceSegment"] = df["Balance"].apply(balance_segment)
print("  BalanceSegment → created (Zero/Low/Medium/High/Premium)")

# Salary Segment
df["SalarySegment"] = pd.cut(
    df["EstimatedSalary"],
    bins=[0, 50000, 100000, 150000, 200001],
    labels=["<50K", "50K-100K", "100K-150K", ">150K"]
)
print("  SalarySegment → created")

# Credit Score Tier
def credit_tier(score):
    if score < 580:
        return "Poor"
    elif score < 670:
        return "Fair"
    elif score < 740:
        return "Good"
    elif score < 800:
        return "Very Good"
    else:
        return "Exceptional"

df["CreditTier"] = df["CreditScore"].apply(credit_tier)
print("  CreditTier → created (Poor/Fair/Good/Very Good/Exceptional)")

# Customer Value Score (composite)
df["Balance"] = df["Balance"].astype(float)
df["EstimatedSalary"] = df["EstimatedSalary"].astype(float)

df["CustomerValueScore"] = (
    (df["Balance"] / df["Balance"].max() * 40) +
    (df["EstimatedSalary"] / df["EstimatedSalary"].max() * 30) +
    (df["Tenure"] / df["Tenure"].max() * 15) +
    (df["NumOfProducts"] / df["NumOfProducts"].max() * 10) +
    (df["IsActiveMember"] * 5)
).round(2)
print("  CustomerValueScore → composite score (0-100)")

# ─────────────────────────────────────────────
# 6. DATA TYPE FIXES
# ─────────────────────────────────────────────
print("\n" + "─" * 55)
print("[6] Fixing Data Types")
print("─" * 55)

df["HasCrCard"] = df["HasCrCard"].astype(int)
df["IsActiveMember"] = df["IsActiveMember"].astype(int)
df["HasLoan"] = df["HasLoan"].astype(int)
df["Exited"] = df["Exited"].astype(int)
df["CreditScore"] = df["CreditScore"].astype(int)
df["Balance"] = df["Balance"].round(2)
df["LoanAmount"] = df["LoanAmount"].round(2)
df["EstimatedSalary"] = df["EstimatedSalary"].round(2)
print("  All numeric columns cast correctly.")

# ─────────────────────────────────────────────
# 7. FINAL STATISTICS (After Cleaning)
# ─────────────────────────────────────────────
print("\n" + "─" * 55)
print("[7] Final Dataset Statistics")
print("─" * 55)

print(f"  Total Customers  : {len(df):,}")
print(f"  Total Columns    : {df.shape[1]}")
print(f"  Missing Values   : {df.isnull().sum().sum()}")
print(f"  Duplicates       : {df.duplicated().sum()}")
print(f"\n  Churn Rate       : {df['Exited'].mean()*100:.1f}%")
print(f"  Avg Balance      : £{df['Balance'].mean():,.2f}")
print(f"  Avg Salary       : £{df['EstimatedSalary'].mean():,.2f}")
print(f"  Loan Holders     : {df['HasLoan'].sum():,} ({df['HasLoan'].mean()*100:.1f}%)")
print(f"  Credit Card Hold : {df['HasCrCard'].sum():,} ({df['HasCrCard'].mean()*100:.1f}%)")
print(f"  Active Members   : {df['IsActiveMember'].sum():,} ({df['IsActiveMember'].mean()*100:.1f}%)")

print(f"\n  Gender Distribution:")
print(df["Gender"].value_counts().to_string())

print(f"\n  Geography:")
print(df["Geography"].value_counts().to_string())

print(f"\n  Age Group:")
print(df["AgeGroup"].value_counts().sort_index().to_string())

print(f"\n  Balance Segment:")
print(df["BalanceSegment"].value_counts().to_string())

# ─────────────────────────────────────────────
# 8. EXPORT CLEANED CSV
# ─────────────────────────────────────────────
print("\n" + "─" * 55)
print("[8] Exporting Cleaned Dataset")
print("─" * 55)

output_path = "../Dataset/banking_cleaned.csv"
df.to_csv(output_path, index=False)
print(f"  Saved → {output_path}")
print(f"  Rows  : {len(df):,}")
print(f"  Cols  : {df.shape[1]}")
print("\n  Column List:")
for i, col in enumerate(df.columns, 1):
    print(f"    {i:2}. {col}")

print("\n" + "=" * 55)
print("  DATA CLEANING COMPLETE ✓")
print("=" * 55)
