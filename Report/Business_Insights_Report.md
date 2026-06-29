# Banking Business Intelligence
## Business Insights Report

**Dataset:** 10,000 Banking Customers | **Tool Stack:** Python · SQL · Power BI

---

## 1. Most Profitable Customer Group

**Finding:** The **Premium Balance segment (>£150K)** with customers aged **46–55** represents the most profitable cohort.

- Only **~10% of customers** hold balances above £150K
- This group accounts for a **disproportionate share of total deposits**
- They have the **highest Customer Value Scores** (composite of balance, salary, tenure, products)
- Average credit score in this group falls in the "Good–Very Good" tier, indicating low default risk

**Recommendation:** Assign dedicated relationship managers to Premium segment customers. Introduce tailored wealth management products. Even a **1% improvement in retention** in this segment preserves millions in deposits.

---

## 2. Which Age Group Has the Highest Balance?

**Finding:** Customers aged **46–55** hold the highest average balances, followed closely by the **56–65** group.

| Age Group | Avg Balance | % of Total Customers |
|-----------|-------------|----------------------|
| 18–25     | Lowest      | 13.6%                |
| 26–35     | Low–Medium  | 17.4%                |
| 36–45     | Medium      | 18.1%                |
| **46–55** | **Highest** | **17.4%**            |
| 56–65     | High        | 17.3%                |
| 65+       | Medium–High | 16.2%                |

**Insight:** This is the classic wealth accumulation curve — customers in peak earning years (46–55) have had time to save but haven't yet drawn down retirement funds. Products like high-interest savings, investment accounts, and estate planning services should be targeted at this segment.

---

## 3. Loan Trends

**Finding:** **~45.2% of customers** hold active loans, representing a significant revenue stream.

Key observations:
- **Average loan amount:** ~£29,300
- Loan customers are distributed fairly evenly across geographies and age groups
- The **36–55 age band** shows the highest loan uptake (peak career stage, major life purchases)
- **Loan customers show slightly lower churn** than non-loan customers — the loan creates a "lock-in" effect
- Germany shows the highest average loan balances despite smaller customer count

**Trend Alert:** Customers with **3–4 products** (including loans) paradoxically show higher churn — possible sign of over-selling or product mis-match. Audit product bundles for this segment.

---

## 4. Customer Distribution

**Geographical Split:**
- **France:** 50.4% of customers (largest market)
- **Spain:** 24.8%
- **Germany:** 24.8%

**Gender Split:**
- **Male:** 51.7% | **Female:** 48.3%
- Female customers hold slightly lower average balances but show **higher churn rates** — a retention gap requiring investigation

**Activity:**
- Only **52.4% of customers are active members** — nearly half are disengaged
- Inactive customers in high-balance segments are the single biggest retention risk

**Branch Performance:**
- All 5 branches (North, South, East, West, Central) show roughly equal customer distribution
- Total deposits and loan books vary — branch-level performance tracking recommended

---

## 5. Churn Insights

**Overall Churn Rate: 20.4%** — this is significantly above the industry benchmark of ~10–15% and requires strategic intervention.

### Who Is Churning?

| Factor | Churned Customers | Retained Customers |
|--------|-----------------|------------------|
| Avg Age | Higher (older) | Lower |
| Avg Balance | Lower | Higher |
| Active Members % | Very low (~15%) | ~65%+ |
| Avg Products | ~1.5 | ~1.7 |
| Tenure | Similar | Similar |

**Key Churn Drivers (in order of impact):**

1. **Inactive membership** — Biggest single predictor. Inactive customers churn at 3–4× the rate of active members
2. **Zero balance accounts** — Customers with £0 balance have very high exit probability
3. **Age 55+** — Senior customers are more likely to consolidate finances elsewhere
4. **Single product holding** — Customers with only 1 product lack cross-sell stickiness
5. **Germany geography** — Shows structurally higher churn than France/Spain

### High-Value Churn Risk (Priority Action List)

**Segment: Premium Balance (>£150K) + Inactive Member**
- These are customers the bank CANNOT afford to lose
- Recommend immediate outreach: personal calls, preferential rate offers, dedicated advisor assignment

### Churn by Geography

| Geography | Churn Rate |
|-----------|-----------|
| Germany   | Highest   |
| France    | Medium    |
| Spain     | Lowest    |

**Germany insight:** Despite having the highest average balances, Germany shows the highest churn — a classic sign of **competitor pressure or poor local engagement**. Consider market-specific retention campaigns.

---

## 6. Strategic Recommendations Summary

| Priority | Action | Target Segment |
|----------|--------|----------------|
| 🔴 HIGH | Activate inactive Premium customers | Balance >£150K + IsActive=0 |
| 🔴 HIGH | Germany retention campaign | Germany + Exited risk |
| 🟡 MED | Cross-sell products to single-product holders | NumOfProducts = 1 |
| 🟡 MED | Loan product push for 36–55 age group | Age 36–55, HasLoan=0 |
| 🟢 LOW | Credit card penetration drive | HasCrCard=0 (29% of base) |
| 🟢 LOW | Senior customer advisory service | Age 55+, AgeGroup=65+ |

---

## 7. KPI Summary Dashboard Values

| KPI | Value |
|-----|-------|
| Total Customers | 10,000 |
| Avg Balance | £52,152 |
| Total Deposits | £521.5M |
| Total Loan Portfolio | £238.9M |
| Churn Rate | 20.4% |
| Credit Card Penetration | 71.0% |
| Loan Penetration | 45.2% |
| Active Member Rate | 52.4% |
| Avg Credit Score | 575 |
| Avg Estimated Salary | £99,159 |

---

*Report generated from Python-cleaned dataset. Visualized in Power BI. SQL queries available in `/SQL/banking_queries.sql`.*
