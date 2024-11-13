-- 1821. Find Customers With Positive Revenue this Year
SELECT customer_id
FROM Customers
WHERE revenue>0 AND year=2021;