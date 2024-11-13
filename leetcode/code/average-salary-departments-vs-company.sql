-- 615. Average Salary: Departments VS Company
WITH CTE AS (
SELECT DATE_FORMAT(s.pay_date, '%Y-%m') AS pay_month,
        e.department_id, 
        AVG(s.amount) OVER(PARTITION BY e.department_id, DATE_FORMAT(s.pay_date, '%Y-%m')) AS depart_avg,
        AVG(s.amount) OVER(PARTITION BY DATE_FORMAT(s.pay_date, '%Y-%m')) AS company_avg
FROM Salary s 
    JOIN Employee e USING(employee_id)
)
SELECT DISTINCT pay_month, department_id,
        CASE WHEN depart_avg>company_avg THEN 'higher'
             WHEN depart_avg=company_avg THEN 'same'
             ELSE 'lower'
        END AS comparison
FROM CTE 
ORDER BY department_id, pay_month