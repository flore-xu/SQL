-- 1303. Find the Team Size
WITH team_cte AS(
    SELECT team_id, COUNT(*) AS team_size 
    FROM Employee
    GROUP BY team_id
)
SELECT e.employee_id, t.team_size 
FROM Employee e 
    JOIN team_cte t ON e.team_id=t.team_id;