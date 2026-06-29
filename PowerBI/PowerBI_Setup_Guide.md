# Power BI Dashboard Setup Guide
## Banking Business Intelligence Dashboard

---

## Step 1 — Import Data

1. Open Power BI Desktop
2. **Get Data → Text/CSV**
3. Select `Dataset/banking_cleaned.csv`
4. Click **Transform Data** to open Power Query

---

## Step 2 — Power Query Transformations

In Power Query Editor, verify these column types:

| Column | Type |
|--------|------|
| CustomerID | Text |
| Age | Whole Number |
| Gender | Text |
| Geography | Text |
| Branch | Text |
| Tenure | Whole Number |
| Balance | Decimal Number |
| NumOfProducts | Whole Number |
| HasCrCard | Whole Number |
| IsActiveMember | Whole Number |
| EstimatedSalary | Decimal Number |
| HasLoan | Whole Number |
| LoanAmount | Decimal Number |
| CreditScore | Whole Number |
| Exited | Whole Number |
| AgeGroup | Text |
| BalanceSegment | Text |
| SalarySegment | Text |
| CreditTier | Text |
| CustomerValueScore | Decimal Number |

Click **Close & Apply**

---

## Step 3 — DAX Measures

In the Data pane, create a **Measures Table** (enter data → blank table named "Measures").
Then create the following measures:

```dax
-- KPI 1: Total Customers
Total Customers = COUNTROWS(banking_customers)

-- KPI 2: Active Customers
Active Customers = CALCULATE(COUNTROWS(banking_customers), banking_customers[Exited] = 0)

-- KPI 3: Churned Customers
Churned Customers = CALCULATE(COUNTROWS(banking_customers), banking_customers[Exited] = 1)

-- KPI 4: Churn Rate
Churn Rate = DIVIDE([Churned Customers], [Total Customers])

-- KPI 5: Average Balance
Avg Balance = AVERAGE(banking_customers[Balance])

-- KPI 6: Total Deposits
Total Deposits = SUM(banking_customers[Balance])

-- KPI 7: Total Loan Portfolio
Total Loan Portfolio = SUM(banking_customers[LoanAmount])

-- KPI 8: Avg Loan Amount
Avg Loan Amount = CALCULATE(AVERAGE(banking_customers[LoanAmount]), banking_customers[HasLoan] = 1)

-- KPI 9: Credit Card %
Credit Card % = DIVIDE(
    CALCULATE(COUNTROWS(banking_customers), banking_customers[HasCrCard] = 1),
    [Total Customers]
)

-- KPI 10: Active Member %
Active Member % = DIVIDE(
    CALCULATE(COUNTROWS(banking_customers), banking_customers[IsActiveMember] = 1),
    [Total Customers]
)

-- KPI 11: Avg Salary
Avg Salary = AVERAGE(banking_customers[EstimatedSalary])

-- KPI 12: Loan Penetration Rate
Loan Penetration = DIVIDE(
    CALCULATE(COUNTROWS(banking_customers), banking_customers[HasLoan] = 1),
    [Total Customers]
)

-- KPI 13: Avg Credit Score
Avg Credit Score = AVERAGE(banking_customers[CreditScore])

-- KPI 14: Total Revenue Proxy (Balance + Loans)
Total AUM = SUM(banking_customers[Balance]) + SUM(banking_customers[LoanAmount])
```

---

## Step 4 — Dashboard Pages Layout

### PAGE 1: Executive Overview

**Title:** Banking BI — Executive Dashboard

**KPI Cards (Top Row):**
- Total Customers → `[Total Customers]` format: `#,0`
- Avg Balance → `[Avg Balance]` format: `£#,0.00`
- Churn Rate → `[Churn Rate]` format: `0.0%`
- Total Deposits → `[Total Deposits]` format: `£#,0`
- Loan Penetration → `[Loan Penetration]` format: `0.0%`
- Credit Card % → `[Credit Card %]` format: `0.0%`

**Charts:**
1. **Clustered Bar Chart** — Customers by Geography
   - Axis: Geography | Values: Total Customers

2. **Donut Chart** — Gender Distribution
   - Legend: Gender | Values: Total Customers

3. **Area Chart** — Avg Balance by Tenure
   - Axis: Tenure | Values: Avg Balance

4. **Stacked Bar** — Branch Performance
   - Axis: Branch | Values: Total Customers, Avg Balance

---

### PAGE 2: Customer Demographics

**Title:** Customer Demographics & Segmentation

**Charts:**
1. **Column Chart** — Customers by Age Group
   - Axis: AgeGroup | Values: Total Customers
   - Sort AgeGroup: 18-25, 26-35, 36-45, 46-55, 56-65, 65+

2. **Clustered Column** — Avg Balance by Age Group
   - Axis: AgeGroup | Values: Avg Balance

3. **Treemap** — Balance Segment Distribution
   - Group: BalanceSegment | Values: Total Customers

4. **100% Stacked Bar** — Credit Tier by Geography
   - Axis: Geography | Legend: CreditTier | Values: Total Customers

5. **Matrix Table** — AgeGroup × Geography
   - Rows: AgeGroup | Columns: Geography | Values: Total Customers

---

### PAGE 3: Financial Analytics

**Title:** Balance, Loans & Salary Analysis

**Charts:**
1. **Histogram (Column)** — Balance Distribution
   - Group Balance into bins using a calculated column:
     ```dax
     Balance Bin =
     SWITCH(TRUE(),
         banking_customers[Balance] = 0, "Zero",
         banking_customers[Balance] < 25000, "0-25K",
         banking_customers[Balance] < 50000, "25K-50K",
         banking_customers[Balance] < 75000, "50K-75K",
         banking_customers[Balance] < 100000, "75K-100K",
         banking_customers[Balance] < 150000, "100K-150K",
         "150K+"
     )
     ```

2. **Funnel Chart** — Loan Portfolio by Branch
   - Values: Total Loan Portfolio | Group: Branch

3. **Scatter Plot** — Balance vs Salary (Colored by Churn)
   - X: Avg Balance | Y: Avg Salary | Legend: Exited

4. **Column Chart** — Avg Salary by Salary Segment
   - Axis: SalarySegment | Values: Total Customers

5. **KPI Card Row:**
   - Total Loan Portfolio
   - Avg Loan Amount
   - Avg Credit Score
   - Total AUM

---

### PAGE 4: Churn Analysis

**Title:** Customer Churn Intelligence

**Charts:**
1. **Donut Chart** — Churned vs Retained
   - Legend: Status (Exited = 0/1) | Values: Total Customers

2. **Column Chart** — Churn Rate by Age Group
   - Axis: AgeGroup | Values: Churn Rate (as %)

3. **Clustered Bar** — Churn Rate by Geography
   - Axis: Geography | Values: Churn Rate

4. **Matrix** — Churn Heatmap: Geography × Gender
   - Rows: Geography | Columns: Gender | Values: Churn Rate (conditional formatting — red high, green low)

5. **Line Chart** — Churn Rate by Tenure
   - Axis: Tenure | Values: Churn Rate

6. **Clustered Column** — Active vs Inactive by Segment
   - Axis: BalanceSegment | Values: Active Customers, Churned Customers

---

## Step 5 — Slicers / Filters Panel

Add these slicers (use Slicer visual, set to vertical list or dropdown):

| Slicer | Field | Style |
|--------|-------|-------|
| Gender | Gender | Button/List |
| Age Group | AgeGroup | Dropdown |
| Geography | Geography | List |
| Branch | Branch | Dropdown |
| Active Status | IsActiveMember | Toggle (0/1) |
| Credit Tier | CreditTier | List |

**Tip:** Pin all slicers to a right-side panel using a bookmark "Filters Open/Close" for a professional feel.

---

## Step 6 — Formatting & Design

**Color Theme:**
- Primary: `#1B3A6B` (Dark Navy)
- Accent: `#F0A500` (Gold/Amber)
- Positive: `#27AE60` (Green)
- Negative/Churn: `#E74C3C` (Red)
- Background: `#F4F6F9` (Light Grey)
- Card Background: `#FFFFFF`

**Font:**
- Titles: Segoe UI Semibold, 14pt
- Labels: Segoe UI, 10pt
- KPI Numbers: Segoe UI Bold, 24pt+

**Best Practices:**
- Add page navigation buttons on each page
- Use conditional formatting on Balance and Churn Rate columns
- Add tooltips to scatter charts showing CustomerID on hover
- Use bookmarks for filter reset button
- Add last refresh date text box: `"Data as of: " & NOW()`

---

## Step 7 — Export

- Save as: `Banking_BI_Dashboard.pbix`
- Export PDF: File → Export → Export to PDF
- Publish to Power BI Service for web sharing

---
