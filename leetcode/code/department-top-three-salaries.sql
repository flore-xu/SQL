-- 185. Department Top Three Salaries
WITH CTE AS(
    SELECT departmentId, name, salary,
            DENSE_RANK() OVER (PARTITION BY departmentId ORDER BY salary DESC) AS rk 
    FROM Employee
)
SELECT d.name AS Department, c.name AS Employee, c.salary AS Salary 
FROM CTE c 
    JOIN Department d ON c.departmentId = d.id
WHERE c.rk<=3
ORDER BY Department;