use dbbank;

-- What are the top factors influencing customer churn?
-- How does tenure impact credit score and financial product usage?
-- What percentage of customers have multiple products but are inactive members?
-- What trends can be observed in churn over different salary ranges?
-- What is the retention rate of customers who hold multiple financial products?

SELECT * FROM bank_churn;

-- top factors influencing customer churn
-- 1.1 Most FEMALE from GERMANY at the AGES of 41-60 are more tend to Exit.
SELECT 
	CASE
		WHEN Age >= 18 AND Age <= 25 THEN 'Young Adults (18-25)'
        WHEN Age >= 26 AND Age <= 40 THEN 'Mid-Age Adults (26-40)'
        WHEN Age >= 41 And Age <= 60 THEN 'Experienced Adults (41 - 60)'
        ELSE 'Senior Customers (61+)' 
	END AS age_group,
    Gender,
    Geography,
	ROUND(SUM(Exited) / COUNT(*) * 100, 2) as churn_rate
FROM bank_churn
GROUP BY age_group, Gender, Geography
ORDER BY churn_rate DESC;

-- 1.2 Customers with fair (600-699) and very poor (350-499) credit with high balance and low income has 100% churn rate 
WITH churn_factors AS (SELECT
	CASE
		WHEN CreditScore BETWEEN 350 AND 500 THEN 'Very Poor (350-500)'
        WHEN CreditScore BETWEEN 501 AND 600 THEN 'Poor (501-600)'
        WHEN CreditScore BETWEEN 601 AND  700 THEN 'Fair (601-700)'
        WHEN CreditScore BETWEEN 701 AND 800 THEN 'Good (701-800)'
        ELSE 'Excellent (801+)'
	END AS credit_score_range,
    CASE
		WHEN Balance BETWEEN 0 AND 50000 THEN 'Low Balance (0-50000)'
        WHEN Balance BETWEEN 50001 AND 150000 THEN 'Mid Balance (50001-150000)'
        ELSE 'High Balance (150001+)'
	END AS balance_range,
    CASE
		WHEN EstimatedSalary BETWEEN 10 AND 50000 THEN 'Low Income (10-50000)'
        WHEN EstimatedSalary BETWEEN 50001 AND 120000 THEN 'Middle Income (50001-120000)'
        ELSE 'High Income (120001+)'
	END AS salary_range,
    ROUND(SUM(Exited) / COUNT(*) * 100, 2) as churn_rate
FROM bank_churn
WHERE (Age BETWEEN 41 AND 60) AND Geography = 'Germany' AND Gender = 'Female'
GROUP BY credit_score_range, balance_range, salary_range
ORDER BY churn_rate DESC)

-- 1.3
SELECT
	b.NumOfProducts,
--    b.HasCrCard,
--   b.IsActiveMember,
    CASE 
		WHEN b.Tenure <= 2 THEN 'NewCustomer(0-2)'
        WHEN b.Tenure BETWEEN 3 AND 5 THEN  'EarlyEngagement(3-5)'
        WHEN b.Tenure BETWEEN 6 AND 8 THEN 'EstablishedCustomer(6-8)'
        ELSE 'LongTermLoyal(9-10)'
	END AS tenure_level,
    ROUND(SUM(Exited) / COUNT(*) * 100, 2) as churn_rate
FROM churn_factors as c
JOIN bank_churn as b
ON c.credit_score_range = (CASE
		WHEN b.CreditScore BETWEEN 350 AND 500 THEN 'Very Poor (350-500)'
        WHEN b.CreditScore BETWEEN 501 AND 600 THEN 'Poor (501-600)'
        WHEN b.CreditScore BETWEEN 601 AND  700 THEN 'Fair (601-700)'
        WHEN b.CreditScore BETWEEN 701 AND 800 THEN 'Good (701-800)'
        ELSE 'Excellent (801+)'
	END)
    AND
    c.balance_range = (CASE
		WHEN b.Balance BETWEEN 0 AND 50000 THEN 'Low Balance (0-50000)'
        WHEN b.Balance BETWEEN 50001 AND 150000 THEN 'Mid Balance (50001-150000)'
        ELSE 'High Balance (150001+)'
	END)
    AND
    c.salary_range = (CASE
		WHEN b.EstimatedSalary BETWEEN 10 AND 50000 THEN 'Low Income (10-50000)'
        WHEN b.EstimatedSalary BETWEEN 50001 AND 120000 THEN 'Middle Income (50001-120000)'
        ELSE 'High Income (120001+)'
	END)
-- GROUP BY b.NumOfProducts, b.HasCrCard, b.IsActiveMember, tenure_level
GROUP BY b.NumOfProducts, tenure_level
HAVING COUNT(*) > 5
ORDER BY churn_rate DESC;
    
    
    