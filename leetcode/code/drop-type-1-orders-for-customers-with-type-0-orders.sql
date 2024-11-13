-- 2084. Drop Type 1 Orders for Customers With Type 0 Orders
WITH CTE AS(
    SELECT *,
        RANK() OVER(PARTITION BY customer_id ORDER BY order_type ASC) AS rk 
    FROM Orders
)
SELECT order_id, customer_id, order_type 
FROM CTE  
WHERE rk=1;