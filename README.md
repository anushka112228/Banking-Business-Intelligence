
# 🏦 Banking Business Intelligence Dashboard

> **Developed a Banking Business Intelligence Dashboard using SQL, Python, and Power BI to analyze customer demographics, account balances, loan distribution, and business KPIs, generating actionable insights through interactive visualizations.**

---

## 📌 Project Overview

This end-to-end BI project analyzes a **10,000-customer banking dataset** to surface actionable insights across customer demographics, account balances, loan portfolios, and churn behavior. The deliverable is a multi-page interactive Power BI dashboard backed by clean data (Python) and analytical queries (SQL).

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|------|---------|
| **Python (Pandas)** | Data cleaning, preprocessing, feature engineering |
| **SQL** | Business queries, KPI aggregations, segment analysis |
| **Power BI** | Interactive dashboard, DAX measures, visual storytelling |
| **Excel/CSV** | Raw and cleaned dataset storage |

---

## 📁 Project Structure

```
Banking-Business-Intelligence/
│
├── Dataset/
│   ├── banking_raw.csv           ← Raw dataset (with missing values & duplicates)
│   └── banking_cleaned.csv       ← Cleaned, enriched dataset (Python output)
│
├── Python/
│   ├── generate_dataset.py       ← Dataset generation script
│   └── data_cleaning.py          ← Phase 3: cleaning pipeline
│
├── SQL/
│   └── banking_queries.sql       ← 16 business intelligence queries
│
├── PowerBI/
│   ├── Banking_BI_Dashboard.pbix ← Main Power BI file
│   └── PowerBI_Setup_Guide.md    ← DAX measures + page layout guide
│
├── Report/
│   └── Business_Insights_Report.md ← Phase 6 written insights
│
└── README.md
```

---

## 📊 Dataset Features

| Column | Description |
|--------|-------------|
| CustomerID | Unique customer identifier |
| Age | Customer age (18–74) |
| Gender | Male / Female |
| Geography | France / Spain / Germany |
| Branch | North / South / East / West / Central |
| Tenure | Years with bank (0–10) |
| Balance | Account balance (£) |
| NumOfProducts | Number of bank products held |
| HasCrCard | Credit card holder (0/1) |
| IsActiveMember | Active customer (0/1) |
| EstimatedSalary | Annual salary estimate (£) |
| HasLoan | Loan customer (0/1) |
| LoanAmount | Outstanding loan (£) |
| CreditScore | Credit score (300–850) |
| Exited | Churned (1) / Retained (0) |
| AgeGroup | Derived age bucket |
| BalanceSegment | Zero / Low / Medium / High / Premium |
| SalarySegment | Salary quartile band |
| CreditTier | Poor / Fair / Good / Very Good / Exceptional |
| CustomerValueScore | Composite value score (0–100) |

---

## 🐍 Phase 3 — Python Data Cleaning

**Script:** `Python/data_cleaning.py`

Steps performed:
- ✅ Loaded raw dataset (10,030 rows with injected issues)
- ✅ Identified 330 missing values across Balance, Salary, CreditScore
- ✅ Filled missing values with column medians (appropriate for skewed distributions)
- ✅ Removed 30 duplicate rows → **clean 10,000-row dataset**
- ✅ Created 5 engineered features (AgeGroup, BalanceSegment, SalarySegment, CreditTier, CustomerValueScore)
- ✅ Fixed data types across all columns
- ✅ Exported `banking_cleaned.csv`

```bash
cd Python/
python data_cleaning.py
```

---

## 🗄️ Phase 4 — SQL Queries (16 Queries)

**File:** `SQL/banking_queries.sql`

| # | Query | Business Purpose |
|---|-------|-----------------|
| 1 | Total Customers + Churn Split | Executive KPI |
| 2 | Avg Balance by Gender & Geography | Balance benchmarking |
| 3 | Loan Customer Analysis | Loan portfolio KPI |
| 4 | Avg Salary by Segment | Income profiling |
| 5 | Customers by Age Group | Demographic breakdown |
| 6 | Top 10 Balance Customers | Premium client list |
| 7 | Gender Distribution & Financials | Gender-based analysis |
| 8 | Credit Card Holder Analysis | Product penetration |
| 9 | Customer Segments by Balance Tier | Segmentation |
| 10 | Branch-wise Performance Summary | Branch comparison |
| 11 | Churn Analysis — Key Drivers | Retention intelligence |
| 12 | Churn by Geography & Gender | Demographic churn risk |
| 13 | Product Holding Analysis | Cross-sell opportunity |
| 14 | Credit Score Tier Distribution | Risk profiling |
| 15 | High-Value Retention Risk List | Priority outreach |
| 16 | Tenure Cohort Performance | Loyalty analysis |

---

## 📈 Phase 5 — Power BI Dashboard

**File:** `PowerBI/Banking_BI_Dashboard.pbix`

**4-Page Dashboard:**

| Page | Content |
|------|---------|
| **Executive Overview** | KPI cards, Geography split, Gender donut, Branch performance |
| **Customer Demographics** | Age groups, Balance segments, Credit tier heatmap |
| **Financial Analytics** | Balance distribution, Loan funnel, Balance vs Salary scatter |
| **Churn Intelligence** | Churn donut, Churn by age/geography/tenure, Risk matrix |

**Slicers:** Gender · Age Group · Geography · Branch · Credit Tier · Active Status

**DAX Measures (14):** Total Customers, Avg Balance, Churn Rate, Loan Penetration, Credit Card %, Active Member %, Total AUM, and more.

---

## 💡 Phase 6 — Key Business Insights

1. **Most Profitable Group:** Customers aged 46–55 with Premium balances (>£150K) — top 10% of customers by value
2. **Highest Balance:** Age group 46–55 holds the highest average account balance
3. **Loan Trends:** 45.2% loan penetration; 36–55 age group drives loan uptake; loan holders churn less
4. **Churn Rate:** 20.4% overall — above industry benchmark. Inactive members churn at 3–4× the rate of active ones
5. **Germany Risk:** Highest churn rate despite highest average balances — competitor pressure signal
6. **Credit Card Stickiness:** Card holders show measurably lower churn — product cross-sell has retention value

## 🚀 Project Highlights

- 📊 Analyzed 10,000 customer records
- 🐍 Cleaned and transformed data using Python (Pandas)
- 🗄️ Wrote 16 SQL business intelligence queries
- 📈 Built an interactive Power BI dashboard using DAX
- 🎯 Identified customer churn patterns and financial KPIs

## 📸 Dashboard Preview

### Executive Dashboard

![Dashboard](Images/dashboard.png)   

---

