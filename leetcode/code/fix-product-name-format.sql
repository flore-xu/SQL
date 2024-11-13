-- 1543. Fix Product Name Format
WITH CTE AS(
SELECT TRIM(LOWER(product_name)) AS product_name,
        DATE_FORMAT(sale_date, '%Y-%m') AS sale_date
        
FROM Sales
)
SELECT product_name, sale_date, COUNT(*) AS total
FROM CTE
GROUP BY product_name, sale_date
ORDER BY product_name ASC, sale_date ASC;