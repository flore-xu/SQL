-- 579. Find Cumulative Salary of an Employee

WITH CTE1 AS(
    SELECT *,
            ROW_NUMBER() OVER(PARTITION BY id ORDER BY month DESC) AS rk
    FROM Employee
)
SELECT id, month, 
       SUM(salary) OVER(PARTITION BY id ORDER BY month DESC RANGE BETWEEN CURRENT ROW AND 2 FOLLOWING) AS Salary
FROM CTE1 
WHERE rk <> 1
ORDER BY id ASC, month DESC