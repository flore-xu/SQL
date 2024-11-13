-- 2372. Calculate the Influence of Each Salesperson
SELECT s.salesperson_id, s.name, IFNULL(SUM(s2.price), 0) AS total
FROM Salesperson s
    LEFT JOIN Customer c USING(salesperson_id)
    LEFT JOIN Sales s2 USING(customer_id)
GROUP BY s.salesperson_id