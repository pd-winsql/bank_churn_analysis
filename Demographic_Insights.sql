USE dbbank;

-- How does churn rate vary across different geographical regions?
-- What is the gender distribution among customers, and does gender influence churn?
-- Which age group has the highest churn rate?
-- What is the average estimated salary for each age group?
-- Do older customers tend to hold more financial products than younger ones?

-- Churn rate percentage distribution by geographical region
SELECT
	Geography,
    ROUND(SUM(exited)/COUNT(*) * 100, 2) as churn_rate
FROM bank_churn
GROUP BY Geography;

-- Gender distibution and churn rate
SELECT
	Gender,
    COUNT(*) as num_of_customers,
    ROUND(SUM(Exited)/COUNT(*) * 100, 2) as churn_rate
FROM bank_churn
GROUP BY Gender;

-- Age group with the highest churn rate
SELECT 
	DISTINCT(Age),
    COUNT(*) as number_of_customers,
    ROUND(SUM(Exited)/COUNT(*) * 100, 2) as churn_rate
FROM bank_churn
GROUP BY Age
-- HAVING COUNT(*) > 10
ORDER BY churn_rate DESC
LIMIT 10;

-- estimated average salary for each age group
SELECT
	Age,
	ROUND(AVG(EstimatedSalary), 2) AS avg_salary
FROM bank_churn
GROUP BY Age
ORDER BY avg_salary DESC;

-- age group holds number of financial products
SELECT
	CASE
		WHEN Age >= 18 AND Age <= 25 THEN 'Young Adults (18-25)'
        WHEN Age >= 26 AND Age <= 40 THEN 'Mid-Age Adults (26-40)'
        WHEN Age >= 41 And Age <= 60 THEN 'Experienced Adults (41 - 60)'
        ELSE 'Senior Customers (61+)' 
	END AS age_group,
	SUM(NumOfProducts) AS num_products
FROM bank_churn
GROUP BY age_group
ORDER BY
	CASE
		WHEN age_group = 'Young Adults (18-25)' THEN 1
        WHEN age_group = 'Mig-Age Adults (26-40)' THEN 2
        WHEN age_group = 'Experienced Adults (41 - 60)' THEN 3
        ELSE 4
	END;