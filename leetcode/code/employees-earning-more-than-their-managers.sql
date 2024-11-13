-- 181. Employees Earning More Than Their Managers

-- solution1: self join
SELECT e1.name AS 'Employee'
FROM Employee e1, Employee e2
WHERE e1.managerId = e2.id AND e1.salary > e2.salary;

-- solution2: correlated subquery
SELECT name AS 'Employee'
FROM Employee e1
WHERE salary > (SELECT salary 
                FROM Employee e2
                WHERE e1.managerId = e2.id);