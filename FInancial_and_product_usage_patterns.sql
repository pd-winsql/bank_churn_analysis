use dbbank;

-- What is the average balance across different credit score ranges?
-- How many customers own a credit card, and what percentage of them have exited?
-- What is the churn rate for customers based on the number of products they use?
-- How many customers have a zero balance, and what is their churn rate?
-- Do customers with higher estimated salaries tend to exit at a lower rate?

-- average balance acroess different credit score ranges
SELECT 
	CASE
		WHEN CreditScore >= 350 AND CreditScore < 500 THEN 'Very Poor (350-499)'
        WHEN CreditScore >= 500 AND CreditScore < 600 THEN 'Poor (500-599)'
        WHEN CreditScore >= 600 AND CreditScore < 700 THEN 'Fair (600-699)'
        WHEN CreditScore >= 700 AND CreditScore < 800 THEN 'Good (700-800)'
        ELSE 'Excellent (800+)'
	END AS credit_score_range,
    ROUND(AVG(Balance), 2) as avg_balance
FROM bank_churn
GROUP BY credit_score_range
ORDER BY 
	CASE
		WHEN credit_score_range = 'Very Poor (350-499)' THEN 1
        WHEN credit_score_range = 'Poor (500-599)'THEN 2
        WHEN credit_score_range = 'Fair (600-699)' THEN 3
        WHEN credit_score_range = 'Good (700-800)' THEN 4
        ELSE 5 END;

-- percentage of customers who exited with credit card
SELECT
	SUM(HasCrCard) as with_crcard,
    SUM(Exited) / SUM(HasCrCard)  * 100 as percentage_exited
FROM bank_churn;

-- churn rate of customers based on the products they used
SELECT
	NumOfProducts,
    SUM(Exited) as num_customers,
    ROUND(SUM(Exited) / COUNT(*) * 100, 2) as churn_rate
FROM bank_churn
GROUP BY NumOfProducts
ORDER BY NumOfProducts;
 
 -- churn rate of customers with 0 balance 
SELECT 
	COUNT(Balance) as customers_with_zero_balance,
    ROUND(SUM(Exited) / COUNT(*) * 100, 2) as churn_rate
FROM bank_churn
WHERE Balance = 0;
 
 
 -- Rate of customers exiting based on their income
SELECT
	CASE
		WHEN EstimatedSalary BETWEEN 10 AND 50000 THEN 'Low Income (10-50000)'
        WHEN EstimatedSalary BETWEEN 50001 AND 120000 THEN 'Middle Income (50001-120000)'
        ELSE 'High Income (120001+)'
	END AS salary_range,
        ROUND(SUM(Exited) / COUNT(*) * 100, 2) as churn_rate
FROM bank_churn
GROUP BY salary_range
ORDER BY
	CASE
		WHEN salary_range = 'Low Income (10-50000)' THEN 1
        WHEN salary_range = 'Middle Income (50001-120000)' THEN 2
        ELSE 3 END;
