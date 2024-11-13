-- 1875. Group Employees of the Same Salary

-- solution1: JOIN
WITH CTE AS(
    SELECT row_number() OVER(ORDER BY salary ASC) AS team_id, salary
    FROM Employees
    GROUP BY salary
    HAVING COUNT(*) > 1
)
SELECT e.*, c.team_id
FROM Employees e 
    JOIN CTE c ON c.salary=e.salary
ORDER BY c.team_id ASC, e.employee_id ASC;


-- solution2: count() over() + dense_rank()
with t1 as(
    select *, count(*) over(partition by salary) AS cnt
    from Employees
    )
select employee_id,name,salary,
        dense_rank() over(order by salary) AS team_id
from t1
where cnt > 1
order by team_id,employee_id;
