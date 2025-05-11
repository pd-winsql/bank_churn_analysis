Use dbbank;

SELECT * FROM bank_churn;
SET SQL_SAFE_UPDATES = 0;

DELETE FROM bank_churn
WHERE Surname LIKE "_?";

SET SQL_SAFE_UPDATES = 1;

SELECT 
	Geography,
    COUNT(CustomerId) AS number_of_clients,
    SUM(CASE WHEN Balance > 0 THEN 1 ELSE 0 END) AS client_with_balance
FROM bank_churn
GROUP BY Geography
ORDER BY Number_of_Clients DESC;