-- UNION exercises

-- 1. display all salesmen and customer located in London.
SELECT salesman_id, name, "Salesman"
    FROM Salesman
    WHERE city = 'London'
UNION ALL
SELECT customer_id, cust_name, "Customer"   
	FROM Customer
	WHERE city = 'London';

-- 2. display distinct salesman and their cities.
-- Return salesperson ID and city
SELECT salesman_id, city    
    FROM Salesman
UNION
SELECT salesman_id, city        
	FROM Customer;

-- 3. display all the salesmen and customer involved in this inventory management system.
SELECT salesman_id, customer_id             
    FROM customer
UNION
SELECT salesman_id, customer_id          
	FROM orders;

-- 4.5. find the salespersons who generated the largest and smallest orders on each date. 
-- Sort the result-set on third field. 
-- Return salesperson ID, name, order no., highest on/lowest on, order date.
SELECT s.salesman_id, s.name, o1.order_no, "Highest on", o1.order_date
    FROM salesman s 
    INNER JOIN orders o1 ON s.salesman_id = o1.salesman_id
    WHERE o1.order_amt = (SELECT MAX(order_amt) 
                        FROM orders o2
                        WHERE o1.order_date = o2.order_date)
UNION
SELECT s.salesman_id, s.name, o1.order_no, "Lowest on", o1.order_date
    FROM salesman s 
    INNER JOIN orders o1 ON s.salesman_id = o1.salesman_id
    WHERE o1.order_amt = (SELECT MIN(order_amt) 
                        FROM orders o2
                        WHERE o1.order_date = o2.order_date)
ORDER BY 3;


-- 6. find those salespeople who live in the same city where the customer lives 
-- as well as those who do not have customers in their cities by indicating 'NO MATCH'. 
-- Sort the result set on 2nd column (i.e. name) in descending order. 
-- Return salesperson ID, name, customer name, commission. 
SELECT s.salesman_id, s.name, COALESCE(c.cust_name, 'NO MATCH'), s.commission
FROM salesman s
    LEFT JOIN customer c ON s.city = c.city AND s.salesman_id = c.salesman_id
ORDER BY 2 DESC;


-- 7. appends strings to the selected fields, indicating whether or not a specified salesman was matched to a customer in his city. 
-- Return salesperson ID, name, city, MATCHED/NO MATCH. 
SELECT s.salesman_id, s.name, s.city,
    CASE WHEN s.city=c.city THEN 'MATCHED'
        ELSE 'MATCHED'
    END AS "MATCHED/NO MATCH"
FROM salesman s, customer c;

-- 8. Create a union of two queries that shows the names, cities, and ratings of all customers.
-- Those with a grade of 300 or greater will also have the words "High Rating", while the others will have the words "Low Rating".
SELECT cust_name, city, grade, 
    CASE WHEN grade >= 300 THEN 'High Rating'
        ELSE 'Low Rating'
    END AS "Rating"
FROM customer;

-- 9.find those salespersons and customers who have placed more than one order. 
-- Return ID, name.
SELECT customer_id AS ID, cust_name AS NAME 
	FROM customer a
    GROUP BY customer_id, cust_name
    HAVING COUNT(*) > 1
UNION
SELECT salesman_id, name
    FROM salesman b
    GROUP BY salesman_id, name
    HAVING COUNT(*) > 1;


