-- 1613. Find the Missing IDs
-- recursive CTE 
WITH RECURSIVE t AS 
(
    SELECT 1 AS n
    UNION ALL
    SELECT n+1 
        FROM t 
        WHERE n < (SELECT MAX(customer_id) FROM Customers)
)

SELECT t.n AS ids 
FROM t 
WHERE n NOT IN (SELECT customer_id FROM Customers)