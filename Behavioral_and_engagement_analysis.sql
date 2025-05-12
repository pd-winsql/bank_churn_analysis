use dbbank;

-- What is the total number of customers, and how many are active members?
-- How does the churn rate compare between active and inactive members?
-- What is the average credit score of customers who have exited?
-- How does the average balance vary between active and inactive customers?
-- What is the distribution of customer tenure, and how does it correlate with churn?


-- Percentage of active members
SELECT 
	COUNT(*) as number_of_clients,
	SUM(IsActiveMember) number_of_active,
    ROUND(SUM(IsActiveMember)  * 100.0 /COUNT(*), 2) as Percentage
FROM bank_churn;
-- Out of 9943 clients, only 5122 are active with a percentage of 51.51%

-- Churn rate between active and inactive member
SELECT 
	IsActiveMember,
    SUM(Exited) * 100 /COUNT(*) as Churn_rate
FROM bank_churn
GROUP BY IsActiveMember;

-- Average credit score of exited members
SELECT 
	ROUND(AVG(CreditScore), 2) as AverageCreditScore
FROM bank_churn
WHERE Exited = 1;

-- Average balance comparison between active and inactive
SELECT 
	IsActiveMember,
	ROUND(AVG(Balance), 2) as AverageBalance
FROM bank_churn
GROUP BY IsActiveMember;

-- Distribution of tenure and its relationship with churn
SELECT
	CASE 
		WHEN Tenure >= 0 AND Tenure <= 2 THEN 'NewCustomer(0-2)'
        WHEN Tenure >=3 AND Tenure <= 5 THEN  'EarlyEngagement(3-5)'
        WHEN Tenure >= 6 AND Tenure <= 8 THEN 'EstablishedCustomer(6-8)'
        ELSE 'LongTermLoyal(9-10)'
	END AS TenureLevel,
    ROUND(SUM(Exited) * 100 /COUNT(*), 2) as Churn_rate
FROM bank_churn
GROUP BY TenureLevel;