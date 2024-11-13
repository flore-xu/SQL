-- 1511. Customer Order Frequency
WITH cte AS(
    SELECT o.customer_id, 
            SUM(IF(DATE_FORMAT(order_date, '%Y-%m')='2020-06', o.quantity*p.price, 0)) AS june_2020,
            SUM(IF(DATE_FORMAT(order_date, '%Y-%m')='2020-07', o.quantity*p.price, 0)) AS july_2020

    FROM Orders o
        JOIN Product p ON p.product_id=o.product_id
    GROUP BY o.customer_id
)
SELECT c1.customer_id, c2.name
FROM cte c1
    JOIN Customers c2 ON c1.customer_id=c2.customer_id
WHERE c1.june_2020 >=100 AND c1.july_2020>=100;