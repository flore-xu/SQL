-- 2362. Generate the Invoice
WITH CTE1 AS(
    SELECT p1.*, p1.quantity*p2.price AS price 
    FROM Purchases p1 
        JOIN Products p2 USING(product_id)
), CTE2 AS(
    SELECT invoice_id
    FROM CTE1
    GROUP BY invoice_id
    ORDER BY SUM(price) DESC, invoice_id ASC
    LIMIT 1
)
SELECT product_id, quantity, price
FROM CTE2 
    JOIN CTE1 USING(invoice_id)