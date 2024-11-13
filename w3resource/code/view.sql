-- VIEW exercises from https://www.w3resource.com/sql-exercises/view/sql-view.php


-- 1. create a view for those salesmen belongs to the city New York. 
CREATE VIEW newyorkstaff AS (
    SELECT *
    FROM salesman
    WHERE city = 'New York');

-- 2. create a view for all salesmen with columns salesman_id, name, and city. 
CREATE VIEW salesown AS(
    SELECT salesman_id, name, and city.
    FROM salesman);

-- 3. create a view to find the salesmen of the city New York who achieved the commission more than 13%. 
CREATE VIEW newyorkstaff AS (
    SELECT *
    FROM salesman
    WHERE city = 'New York' AND commission > 0.13);


-- 4. create a view that counts the number of customers in each grade.   
CREATE VIEW gradecount AS (
    SELECT grade, COUNT(*)
    FROM customer
    GROUP BY grade);

-- 5. create a view to count the number of unique customers, compute the average and the total purchase amount of customer orders by each date.
CREATE VIEW totalforday AS(
    SELECT ord_date, COUNT(DISTINCT customer_id), AVG(purch_amt), SUM(purch_amt)
    FROM orders
    GROUP BY ord_date);



-- 6. create a view that for each order, shows order name, purchase amount, salesperson ID, name, customer name. 
CREATE VIEW nameorders AS(
    SELECT o.ord_no, o.purch_amt, o.salesman_id, s.name, c.cust_name 
    FROM orders o 
        INNER JOIN salesman s ON o.salesman_id = s.salesman_id
        INNER JOIN customer c ON o.customer_id = c.customer_id
    );

	


-- 7. create a view that finds the salesman who has the customer with the highest order of a day. 
-- Return order date, salesperson ID, name.
CREATE VIEW elitsalesman AS(
    SELECT o.ord_date, s.salesman_id, s.name 
    FROM salesman s
        INNER JOIN orders o ON s.salesman_id = o.salesman_id  
    WHERE o.purch_amt = (SELECT MAX(o2.purch_amt)
                        FROM orders o2
                        WHERE o.ord_date = o2.ord_date)
    );
					


-- 8. create a view that finds the salesman who has the customer with the highest order at least 3 times on a day. 					
-- Return salesperson ID and name.
CREATE VIEW incentive AS(
    SELECT s.salesman_id, s.name 
    FROM salesman s
        INNER JOIN orders o ON s.salesman_id = o.salesman_id  
    WHERE o.purch_amt = (SELECT MAX(o2.purch_amt)
                        FROM orders o2
                        WHERE o.ord_date = o2.ord_date)
    GROUP BY o.ord_date, s.salesman_id, s.name
    HAVING COUNT(*) >= 3
    );

-- 9. create a view that shows all of the customers who have the highest grade.
-- Return all the fields of customer.
CREATE VIEW highgrade AS (
    SELECT * 
    FROM customer
    WHERE grade = (SELECT MAX(grade)
                FROM customer)
    );
			  


-- 10. create a view that shows the number of the salesman in each city.
CREATE VIEW citynum AS (
    SELECT city, COUNT(salesman_id)
    FROM salesman
    GROUP BY city
    );


-- 11. create a view to compute the average purchase amount and total purchase amount for each salesperson. 
-- Return name, average purchase and total purchase amount. (Assume all names are unique.)

CREATE VIEW norders AS (
    SELECT s.name, AVG(o.purch_amt), SUM(o.purch_amt)    
    FROM salesman s
    INNER JOIN orders o ON s.salesman_id = o.salesman_id 
    GROUP BY s.name
    );


-- 12. create a view that shows each salesman who work with multiple customers.
-- Return all the fields of salesperson
CREATE VIEW mcustomer AS (SELECT *
    FROM salesman s
        INNER JOIN customer c ON  s.salesman_id = c.salesman_id
    GROUP BY s.salesman_id
    HAVING COUNT(*) > 1
    );



-- 13. create a view that shows cities of all matches of customers with salesman 		
CREATE VIEW citymatch(custcity, salescity) AS (
    SELECT DISTINCT a.city, b.city
    FROM customer a, salesman b
    WHERE a.salesman_id = b.salesman_id
    );



-- 14. create a view that shows the number of orders in each day.
-- Return order date and number of orders.
CREATE VIEW dateord AS (
    SELECT ord_date, COUNT(*)   
    FROM orders
    GROUP BY ord_date
    );


-- 15. create a view that finds the salesmen who issued orders on October 10th, 2012.
-- Return all the fields of salesperson
CREATE VIEW salesmanonoct AS (
    SELECT s.*
    FROM salesman s
        INNER JOIN orders o ON s.salesman_id = o.salesman_id
    WHERE o.ord_date = '2012-10-10'
    );


-- 16. create a view that finds the salesmen who issued orders on either August 17th, 2012 or October 10th, 2012.
-- Return salesperson ID, order number and customer ID.
CREATE VIEW sorder AS (
    SELECT s.salesman_id, o.ord_no, o.customer_id
    FROM salesman s
        INNER JOIN orders o ON s.salesman_id = o.salesman_id
    WHERE o.ord_date IN ('2012-10-10', '2012-08-17')
    );

