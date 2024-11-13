-- JOIN on Inventory Database



-- 1. find the salespeople and customers who live in the same city. Return customer name, salesperson name and salesperson city. 
SELECT c.cust_name, s.name, s.city
FROM salesman s
    INNER JOIN customer c ON s.city = c.city;


-- 2. locate all the customers and the salesperson who works for them. Return customer name, and salesperson name.
SELECT c.cust_name, s.name
FROM salesman s
    INNER JOIN customer c ON s.salesman_id = c.salesman_id;

-- 3. find those salespeople who generated orders for their customers but are not located in the same city. Return ord_no, cust_name, customer_id (orders table), salesman_id (orders table).
SELECT o.ord_no, c.cust_name, o.customer_id, o.salesman_id
FROM orders o
    INNER JOIN customer c ON o.customer_id = c.customer_id
    INNER JOIN salesman s ON o.salesman_id = s.salesman_id
WHERE c.city <> s.city;


-- 4. locate the orders made by customers. Return order number, customer name.
SELECT o.ord_no, c.cust_name
FROM orders o
    INNER JOIN customer c ON o.customer_id = c.customer_id;

-- 5. find those customers where each customer has a grade and is served by a salesperson who belongs to a city. Return cust_name as "Customer", grade as "Grade".
SELECT c.cust_name AS Customer, c.grade AS Grade
FROM customer c
    INNER JOIN salesman s ON c.salesman_id = s.salesman_id
WHERE c.grade IS NOT NULL AND s.city IS NOT NULL;

-- 6. find those customers who are served by a salesperson and the salesperson earns commission in the range of 12% to 14% (Begin and end values are included.). Return cust_name AS "Customer", city AS "City".
SELECT c.cust_name AS Customer, s.city AS City, s.name AS Salesman, s.commission
FROM customer c
    INNER JOIN salesman s ON c.salesman_id = s.salesman_id
WHERE s.commission BETWEEN 0.12 AND 0.14;

-- 7. find all orders executed by the salesperson and ordered by the customer whose grade is greater than or equal to 200. 
-- Compute purch_amt*commission as “Commission”. Return customer name, commission as “Commission%” and Commission.
SELECT c.cust_name AS Customer, o.purch_amt * s.commission AS Commission
FROM customer c
    INNER JOIN salesman s ON c.salesman_id = s.salesman_id
    INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE c.grade >= 200;

-- 8. find those customers who placed orders on October 5, 2012. Return customer_id, cust_name, city, grade, salesman_id, ord_no, purch_amt, ord_date, customer_id and salesman_id.
SELECT c.customer_id, c.cust_name, c.city, c.grade, s.salesman_id, o.ord_no, o.purch_amt, o.ord_date, o.customer_id, o.salesman_id
FROM customer c
    INNER JOIN salesman s ON c.salesman_id = s.salesman_id
    INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.ord_date = '2012-10-05';
