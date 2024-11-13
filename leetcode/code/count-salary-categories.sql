-- 1907. Count Salary Categories
SELECT 'Low Salary' AS category, COUNT(*) AS accounts_count
    FROM Accounts
    WHERE income < 20000
UNION 
SELECT 'Average Salary', COUNT(*) AS accounts_count
    FROM Accounts
    WHERE income BETWEEN 20000 AND 50000
UNION 
SELECT 'High Salary', COUNT(*) AS accounts_count
    FROM Accounts
    WHERE income > 50000;