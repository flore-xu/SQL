-- 2474. Customers With Strictly Increasing Purchases

-- consecutive increasing: diff is same within same customer group    yr - RANK() over(partition by customer_id order by yearly_price) AS diff
WITH CTE1 AS(
    SELECT customer_id, YEAR(order_date) AS yr, SUM(price) AS yearly_price
    FROM Orders
    GROUP BY 1, 2
), CTE2 AS (
    SELECT customer_id, 
            yr - RANK() over(partition by customer_id order by yearly_price) AS diff
    FROM CTE1
)
SELECT customer_id
FROM CTE2 
GROUP BY customer_id
HAVING COUNT(DISTINCT diff)=1;