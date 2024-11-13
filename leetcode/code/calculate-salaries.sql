-- 1468. Calculate Salaries
WITH CTE AS(
    SELECT *,
        MAX(salary) OVER(PARTITION BY company_id) AS max_salary
    FROM Salaries
)
SELECT company_id, employee_id, employee_name,
    CASE WHEN max_salary < 1000 THEN salary 
         WHEN max_salary <=10000 THEN ROUND(salary*(1-0.24), 0)
         ELSE ROUND(salary*(1-0.49), 0)
    END AS salary
FROM CTE;