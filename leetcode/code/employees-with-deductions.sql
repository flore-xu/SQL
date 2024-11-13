-- 2394. Employees With Deductions
SELECT e.employee_id
FROM Employees e
    LEFT JOIN Logs l USING(employee_id)
GROUP BY e.employee_id
HAVING MAX(e.needed_hours) > IFNULL(SUM(CEIL(TIMESTAMPDIFF(SECOND, l.in_time, l.out_time)/60))/60, 0);