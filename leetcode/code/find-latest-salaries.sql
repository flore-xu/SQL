-- 2668. Find Latest Salaries
WITH CTE AS (
    SELECT *, RANK() OVER(PARTITION BY emp_id ORDER BY salary DESC) AS rk 
    FROM Salary
)
SELECT emp_id, firstname, lastname, salary, department_id
FROM CTE 
WHERE rk=1
ORDER BY emp_id ASC;