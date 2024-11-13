-- 1398. Customers Who Bought Products A and B but Not C
SELECT o.customer_id, c.customer_name
FROM Orders o 
    JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_id
HAVING GROUP_CONCAT(DISTINCT o.product_name ORDER BY o.product_name ASC SEPARATOR "") REGEXP '^AB([^C]|$)';


SELECT
    c.customer_id, c.customer_name
FROM Orders o 
    LEFT JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id
HAVING SUM(product_name = 'A') > 0 
    AND SUM(product_name = 'B') > 0
    AND SUM(product_name = 'C') = 0
ORDER BY c.customer_id;

