import pandas as pd
import numpy as np
import random

np.random.seed(42)
random.seed(42)

n = 10000

# Customer IDs
customer_ids = [f"CUST{str(i).zfill(5)}" for i in range(1, n + 1)]

# Demographics
ages = np.random.randint(18, 75, n)
genders = np.random.choice(["Male", "Female"], n, p=[0.52, 0.48])
countries = np.random.choice(["France", "Spain", "Germany"], n, p=[0.50, 0.25, 0.25])
branches = np.random.choice(["North", "South", "East", "West", "Central"], n)

# Financial
tenures = np.random.randint(0, 11, n)
balances = np.round(np.where(
    np.random.rand(n) < 0.30, 0,
    np.random.exponential(scale=80000, size=n)
), 2)
balances = np.clip(balances, 0, 250000)

num_products = np.random.choice([1, 2, 3, 4], n, p=[0.50, 0.35, 0.12, 0.03])
has_credit_card = np.random.choice([0, 1], n, p=[0.29, 0.71])
is_active = np.random.choice([0, 1], n, p=[0.48, 0.52])
estimated_salary = np.round(np.random.uniform(11.58, 199992.48, n), 2)

# Loan amount (only for customers with loans)
has_loan = np.random.choice([0, 1], n, p=[0.55, 0.45])
loan_amount = np.where(
    has_loan == 1,
    np.round(np.random.uniform(5000, 100000, n), 2),
    0
)

# Churn - influenced by age, balance, activity
churn_prob = (
    0.10
    + (ages > 55) * 0.05
    + (balances == 0) * 0.10
    + (is_active == 0) * 0.15
    + (num_products > 2) * 0.10
    - (has_credit_card) * 0.03
)
churn_prob = np.clip(churn_prob, 0, 1)
churn = np.random.binomial(1, churn_prob, n)

# Credit score
credit_scores = np.random.randint(300, 850, n)

# Introduce some missing values
balance_missing = balances.copy().astype(object)
salary_missing = estimated_salary.copy().astype(object)
credit_missing = credit_scores.copy().astype(object)

missing_idx_balance = np.random.choice(n, 150, replace=False)
missing_idx_salary = np.random.choice(n, 100, replace=False)
missing_idx_credit = np.random.choice(n, 80, replace=False)

for i in missing_idx_balance:
    balance_missing[i] = np.nan
for i in missing_idx_salary:
    salary_missing[i] = np.nan
for i in missing_idx_credit:
    credit_missing[i] = np.nan

df = pd.DataFrame({
    "CustomerID": customer_ids,
    "Age": ages,
    "Gender": genders,
    "Geography": countries,
    "Branch": branches,
    "Tenure": tenures,
    "Balance": balance_missing,
    "NumOfProducts": num_products,
    "HasCrCard": has_credit_card,
    "IsActiveMember": is_active,
    "EstimatedSalary": salary_missing,
    "HasLoan": has_loan,
    "LoanAmount": loan_amount,
    "CreditScore": credit_missing,
    "Exited": churn
})

# Introduce duplicates (30 rows)
dup_rows = df.sample(30, random_state=1)
df = pd.concat([df, dup_rows], ignore_index=True)
df = df.sample(frac=1, random_state=99).reset_index(drop=True)

df.to_csv("/home/claude/Banking-Business-Intelligence/Dataset/banking_raw.csv", index=False)
print(f"Dataset created: {len(df)} rows, {df.shape[1]} columns")
print(df.head())
