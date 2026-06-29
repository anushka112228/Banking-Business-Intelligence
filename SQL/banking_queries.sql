-- ============================================================
-- BANKING BUSINESS INTELLIGENCE - SQL QUERIES
-- Database: Banking_BI
-- Table: banking_customers
-- ============================================================

-- ─────────────────────────────────────────────────────────────
-- SETUP: Create Table Schema
-- ─────────────────────────────────────────────────────────────

CREATE DATABASE IF NOT EXISTS Banking_BI;
USE Banking_BI;

CREATE TABLE IF NOT EXISTS banking_customers (
    CustomerID       VARCHAR(10)    PRIMARY KEY,
    Age              INT,
    Gender           VARCHAR(10),
    Geography        VARCHAR(20),
    Branch           VARCHAR(20),
    Tenure           INT,
    Balance          DECIMAL(15,2),
    NumOfProducts    INT,
    HasCrCard        TINYINT,
    IsActiveMember   TINYINT,
    EstimatedSalary  DECIMAL(15,2),
    HasLoan          TINYINT,
    LoanAmount       DECIMAL(15,2),
    CreditScore      INT,
    Exited           TINYINT,
    AgeGroup         VARCHAR(10),
    BalanceSegment   VARCHAR(25),
    SalarySegment    VARCHAR(15),
    CreditTier       VARCHAR(15),
    CustomerValueScore DECIMAL(6,2)
);

-- ─────────────────────────────────────────────────────────────
-- QUERY 1: Total Customers
-- ─────────────────────────────────────────────────────────────

SELECT
    COUNT(*)                        AS TotalCustomers,
    COUNT(CASE WHEN Exited = 0 THEN 1 END) AS ActiveCustomers,
    COUNT(CASE WHEN Exited = 1 THEN 1 END) AS ChurnedCustomers,
    ROUND(
        COUNT(CASE WHEN Exited = 1 THEN 1 END) * 100.0 / COUNT(*), 2
    )                               AS ChurnRate_Pct
FROM banking_customers;

/*
INSIGHT: Shows total customer base size with churn split.
KPI card in Power BI.
*/

-- ─────────────────────────────────────────────────────────────
-- QUERY 2: Average Balance (Overall + By Gender + By Geography)
-- ─────────────────────────────────────────────────────────────

SELECT
    'Overall'                       AS Category,
    'All'                           AS Segment,
    ROUND(AVG(Balance), 2)          AS AvgBalance,
    ROUND(MIN(Balance), 2)          AS MinBalance,
    ROUND(MAX(Balance), 2)          AS MaxBalance
FROM banking_customers

UNION ALL

SELECT
    'By Gender'                     AS Category,
    Gender                          AS Segment,
    ROUND(AVG(Balance), 2)          AS AvgBalance,
    ROUND(MIN(Balance), 2)          AS MinBalance,
    ROUND(MAX(Balance), 2)          AS MaxBalance
FROM banking_customers
GROUP BY Gender

UNION ALL

SELECT
    'By Country'                    AS Category,
    Geography                       AS Segment,
    ROUND(AVG(Balance), 2)          AS AvgBalance,
    ROUND(MIN(Balance), 2)          AS MinBalance,
    ROUND(MAX(Balance), 2)          AS MaxBalance
FROM banking_customers
GROUP BY Geography
ORDER BY Category, AvgBalance DESC;

/*
INSIGHT: Germany has highest avg balance, France largest customer base.
*/

-- ─────────────────────────────────────────────────────────────
-- QUERY 3: Loan Customer Analysis
-- ─────────────────────────────────────────────────────────────

SELECT
    COUNT(*)                              AS TotalLoanCustomers,
    ROUND(AVG(LoanAmount), 2)             AS AvgLoanAmount,
    ROUND(SUM(LoanAmount), 2)             AS TotalLoanPortfolio,
    ROUND(MIN(LoanAmount), 2)             AS MinLoan,
    ROUND(MAX(LoanAmount), 2)             AS MaxLoan,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM banking_customers), 2
    )                                     AS LoanPenetration_Pct
FROM banking_customers
WHERE HasLoan = 1;

/*
INSIGHT: ~45% of customers carry loans — significant revenue stream.
*/

-- ─────────────────────────────────────────────────────────────
-- QUERY 4: Average Estimated Salary by Segment
-- ─────────────────────────────────────────────────────────────

SELECT
    Geography,
    Gender,
    ROUND(AVG(EstimatedSalary), 2)  AS AvgSalary,
    ROUND(MAX(EstimatedSalary), 2)  AS MaxSalary,
    COUNT(*)                        AS CustomerCount
FROM banking_customers
GROUP BY Geography, Gender
ORDER BY AvgSalary DESC;

/*
INSIGHT: Salary is fairly uniform across geographies (~100K avg).
*/

-- ─────────────────────────────────────────────────────────────
-- QUERY 5: Customers by Age Group
-- ─────────────────────────────────────────────────────────────

SELECT
    AgeGroup,
    COUNT(*)                              AS CustomerCount,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM banking_customers), 2) AS Pct_Share,
    ROUND(AVG(Balance), 2)                AS AvgBalance,
    ROUND(AVG(EstimatedSalary), 2)        AS AvgSalary,
    ROUND(AVG(CreditScore), 0)            AS AvgCreditScore,
    SUM(HasLoan)                          AS LoanHolders,
    SUM(Exited)                           AS ChurnedCount,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS ChurnRate_Pct
FROM banking_customers
GROUP BY AgeGroup
ORDER BY AgeGroup;

/*
INSIGHT: 46-55 age group has highest average balance.
Senior customers (55+) show higher churn risk.
*/

-- ─────────────────────────────────────────────────────────────
-- QUERY 6: Top 10 Customers by Balance
-- ─────────────────────────────────────────────────────────────

SELECT
    CustomerID,
    Age,
    Gender,
    Geography,
    Branch,
    ROUND(Balance, 2)               AS Balance,
    ROUND(EstimatedSalary, 2)       AS EstimatedSalary,
    ROUND(LoanAmount, 2)            AS LoanAmount,
    NumOfProducts,
    CreditTier,
    CASE WHEN Exited = 1 THEN 'Churned' ELSE 'Active' END AS Status
FROM banking_customers
ORDER BY Balance DESC
LIMIT 10;

/*
INSIGHT: Premium customers — retention focus list for relationship managers.
*/

-- ─────────────────────────────────────────────────────────────
-- QUERY 7: Gender Distribution & Financial Comparison
-- ─────────────────────────────────────────────────────────────

SELECT
    Gender,
    COUNT(*)                              AS CustomerCount,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM banking_customers), 2) AS Pct_Share,
    ROUND(AVG(Balance), 2)                AS AvgBalance,
    ROUND(SUM(Balance), 2)                AS TotalBalance,
    SUM(HasLoan)                          AS LoanHolders,
    SUM(HasCrCard)                        AS CreditCardHolders,
    ROUND(AVG(EstimatedSalary), 2)        AS AvgSalary,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS ChurnRate_Pct
FROM banking_customers
GROUP BY Gender;

/*
INSIGHT: Female customers show slightly higher churn despite similar balance levels.
*/

-- ─────────────────────────────────────────────────────────────
-- QUERY 8: Credit Card Holders Analysis
-- ─────────────────────────────────────────────────────────────

SELECT
    HasCrCard,
    CASE WHEN HasCrCard = 1 THEN 'Credit Card Holder' ELSE 'No Credit Card' END AS CardStatus,
    COUNT(*)                              AS CustomerCount,
    ROUND(AVG(Balance), 2)                AS AvgBalance,
    ROUND(AVG(EstimatedSalary), 2)        AS AvgSalary,
    ROUND(AVG(CreditScore), 0)            AS AvgCreditScore,
    ROUND(AVG(Tenure), 1)                 AS AvgTenure,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS ChurnRate_Pct
FROM banking_customers
GROUP BY HasCrCard;

/*
INSIGHT: Credit card holders have slightly lower churn — product stickiness effect.
*/

-- ─────────────────────────────────────────────────────────────
-- QUERY 9: Customer Segments by Balance Tier
-- ─────────────────────────────────────────────────────────────

SELECT
    BalanceSegment,
    COUNT(*)                              AS CustomerCount,
    ROUND(AVG(Balance), 2)                AS AvgBalance,
    ROUND(SUM(Balance), 2)                AS TotalBalance,
    ROUND(AVG(EstimatedSalary), 2)        AS AvgSalary,
    SUM(HasLoan)                          AS LoanHolders,
    ROUND(AVG(CustomerValueScore), 2)     AS AvgValueScore,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS ChurnRate_Pct
FROM banking_customers
GROUP BY BalanceSegment
ORDER BY AVG(Balance) DESC;

/*
INSIGHT: Premium segment (>150K) holds disproportionate share of total deposits.
*/

-- ─────────────────────────────────────────────────────────────
-- QUERY 10: Branch-wise Performance Summary
-- ─────────────────────────────────────────────────────────────

SELECT
    Branch,
    COUNT(*)                              AS TotalCustomers,
    ROUND(AVG(Balance), 2)                AS AvgBalance,
    ROUND(SUM(Balance), 2)                AS TotalDeposits,
    SUM(HasLoan)                          AS LoanCustomers,
    ROUND(SUM(LoanAmount), 2)             AS TotalLoanBook,
    SUM(HasCrCard)                        AS CreditCardHolders,
    ROUND(AVG(EstimatedSalary), 2)        AS AvgSalary,
    SUM(IsActiveMember)                   AS ActiveMembers,
    SUM(Exited)                           AS ChurnedCustomers,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS ChurnRate_Pct,
    ROUND(AVG(CustomerValueScore), 2)     AS AvgValueScore
FROM banking_customers
GROUP BY Branch
ORDER BY TotalDeposits DESC;

/*
INSIGHT: Branch comparison for resource allocation decisions.
*/

-- ─────────────────────────────────────────────────────────────
-- QUERY 11: Churn Analysis — Key Drivers
-- ─────────────────────────────────────────────────────────────

SELECT
    Exited,
    CASE WHEN Exited = 1 THEN 'Churned' ELSE 'Retained' END AS CustomerStatus,
    COUNT(*)                              AS CustomerCount,
    ROUND(AVG(Age), 1)                    AS AvgAge,
    ROUND(AVG(Balance), 2)                AS AvgBalance,
    ROUND(AVG(CreditScore), 0)            AS AvgCreditScore,
    ROUND(AVG(Tenure), 1)                 AS AvgTenure,
    ROUND(AVG(NumOfProducts), 2)          AS AvgProducts,
    ROUND(AVG(EstimatedSalary), 2)        AS AvgSalary,
    ROUND(SUM(HasLoan) * 100.0 / COUNT(*), 2) AS LoanHolders_Pct,
    ROUND(SUM(IsActiveMember) * 100.0 / COUNT(*), 2) AS ActiveMember_Pct
FROM banking_customers
GROUP BY Exited;

/*
INSIGHT: Churned customers are older, less active, have fewer products.
*/

-- ─────────────────────────────────────────────────────────────
-- QUERY 12: Churn by Geography & Gender
-- ─────────────────────────────────────────────────────────────

SELECT
    Geography,
    Gender,
    COUNT(*)                              AS TotalCustomers,
    SUM(Exited)                           AS ChurnedCount,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS ChurnRate_Pct,
    ROUND(AVG(Balance), 2)                AS AvgBalance
FROM banking_customers
GROUP BY Geography, Gender
ORDER BY ChurnRate_Pct DESC;

/*
INSIGHT: Germany + Female shows highest churn concentration.
*/

-- ─────────────────────────────────────────────────────────────
-- QUERY 13: Product Holding Analysis
-- ─────────────────────────────────────────────────────────────

SELECT
    NumOfProducts,
    COUNT(*)                              AS CustomerCount,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM banking_customers), 2) AS Pct_Share,
    ROUND(AVG(Balance), 2)                AS AvgBalance,
    ROUND(AVG(EstimatedSalary), 2)        AS AvgSalary,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS ChurnRate_Pct
FROM banking_customers
GROUP BY NumOfProducts
ORDER BY NumOfProducts;

/*
INSIGHT: Customers with 3-4 products show paradoxically higher churn
(over-sold segment — potential mis-selling risk).
*/

-- ─────────────────────────────────────────────────────────────
-- QUERY 14: Credit Score Tier Distribution
-- ─────────────────────────────────────────────────────────────

SELECT
    CreditTier,
    COUNT(*)                              AS CustomerCount,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM banking_customers), 2) AS Pct_Share,
    ROUND(AVG(Balance), 2)                AS AvgBalance,
    ROUND(AVG(LoanAmount), 2)             AS AvgLoanAmount,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS ChurnRate_Pct,
    ROUND(AVG(EstimatedSalary), 2)        AS AvgSalary
FROM banking_customers
GROUP BY CreditTier
ORDER BY AVG(CreditScore) DESC;

/*
INSIGHT: "Poor" credit customers carry higher balances (possibly secured loans).
*/

-- ─────────────────────────────────────────────────────────────
-- QUERY 15: High-Value Customer Retention Risk
-- (Premium customers who are NOT active members)
-- ─────────────────────────────────────────────────────────────

SELECT
    CustomerID,
    Age,
    Gender,
    Geography,
    Branch,
    ROUND(Balance, 2)               AS Balance,
    CreditTier,
    Tenure,
    NumOfProducts,
    ROUND(CustomerValueScore, 2)    AS ValueScore,
    CASE WHEN Exited = 1 THEN 'CHURNED ⚠' ELSE 'At Risk' END AS RiskFlag
FROM banking_customers
WHERE
    BalanceSegment = 'Premium (>150K)'
    AND IsActiveMember = 0
ORDER BY Balance DESC
LIMIT 20;

/*
INSIGHT: These are your highest-priority retention targets.
Premium balance but inactive = flight risk. Flag for relationship manager outreach.
*/

-- ─────────────────────────────────────────────────────────────
-- QUERY 16: Monthly Tenure Cohort Performance
-- ─────────────────────────────────────────────────────────────

SELECT
    Tenure                                AS YearsWithBank,
    COUNT(*)                              AS CustomerCount,
    ROUND(AVG(Balance), 2)                AS AvgBalance,
    ROUND(AVG(NumOfProducts), 2)          AS AvgProducts,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS ChurnRate_Pct,
    SUM(HasLoan)                          AS LoanHolders,
    ROUND(SUM(LoanAmount), 2)             AS TotalLoanValue
FROM banking_customers
GROUP BY Tenure
ORDER BY Tenure;

/*
INSIGHT: Churn doesn't strongly correlate with tenure — even long-term customers leave.
Focus on engagement (products, activity) over relationship length.
*/

-- ============================================================
-- END OF SQL QUERIES
-- ============================================================
