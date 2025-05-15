Use dbbank;

SELECT * FROM bank_churn;
SET SQL_SAFE_UPDATES = 0;

DELETE FROM bank_churn
WHERE Surname LIKE "_?";

SET SQL_SAFE_UPDATES = 1;

SELECT * FROM bank_churn;