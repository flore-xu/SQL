
------------+------------+----------+------------+
-- table: salesman
+------------+------------+----------+------------+


-- 1. find the details of those salespeople who come from the 'Paris' City or 'Rome' City. Return salesman_id, name, city, commission.
SELECT salesman_id, name, city, commission
FROM salesman
WHERE city IN ('Paris', 'Rome');


-- 3. find the details of those salespeople who live in cities other than Paris and Rome. Return salesman_id, name, city, commission.
SELECT salesman_id, name, city, commission
FROM salesman
WHERE city NOT IN ('Paris', 'Rome');


-- 7. retrieve the details of the salespeople whose names begin with any letter between 'A' and 'L' (inclusive). Return salesman_id, name, city, commission.
SELECT salesman_id, name, city, commission
FROM salesman
WHERE name BETWEEN 'A' AND 'L';

-- 8. find the details of all salespeople except those whose names begin with any letter between 'A' and 'L' (inclusive). Return salesman_id, name, city, commission.
SELECT salesman_id, name, city, commission
FROM salesman
WHERE name NOT BETWEEN 'A' AND 'L';

-- 11. find the details of those salespeople whose names begin with ‘N’ and the fourth character is 'l'. Rests may be any character. Return salesman_id, name, city, commission.
SELECT salesman_id, name, city, commission
FROM salesman
WHERE name LIKE 'N__l%';




+------------+----------------+------------+-------+-------------+
-- table: customer
+------------+----------------+------------+-------+-------------+


-- 4. retrieve the details of all customers whose ID belongs to any of the values 3007, 3008 or 3009. 
-- Return customer_id, cust_name, city, grade, and salesman_id. 
SELECT customer_id, cust_name, city, grade, salesman_id
FROM customer
WHERE customer_id IN (3007, 3008, 3009);

-- 5. find salespeople who receive commissions between 0.12 and 0.14 (begin and end values are included). Return salesman_id, name, city, and commission.
SELECT salesman_id, name, city, commission
FROM salesman
WHERE commission BETWEEN 0.12 AND 0.14;


-- 9. retrieve the details of the customers whose names begins with the letter 'B'. Return customer_id, cust_name, city, grade, salesman_id
SELECT customer_id, cust_name, city, grade, salesman_id
FROM customer
WHERE cust_name LIKE 'B%';

-- 10. find the details of the customers whose names end with the letter 'n'. Return customer_id, cust_name, city, grade, salesman_id.
SELECT customer_id, cust_name, city, grade, salesman_id
FROM customer
WHERE cust_name LIKE '%n';


-- 20. find all those customers who does not have any grade. Return customer_id, cust_name, city, grade, salesman_id.
SELECT customer_id, cust_name, city, grade, salesman_id
FROM customer
WHERE grade IS NULL;


-- 21. locate all customers with a grade value. Return customer_id, cust_name,city, grade, salesman_id.
SELECT customer_id, cust_name, city, grade, salesman_id
FROM customer
WHERE grade IS NOT NULL;



+----------+-----------+----------+-------------+------------+
-- orders
+----------+-----------+----------+-------------+------------+


-- 6. select orders between 500 and 4000 (begin and end values are included). 
-- Exclude orders amount 948.50 and 1983.43. Return ord_no, purch_amt, ord_date, customer_id, and salesman_id.
SELECT ord_no, purch_amt, ord_date, customer_id, salesman_id
FROM orders
WHERE (purch_amt BETWEEN 500 AND 4000)
    AND (purch_amt NOT IN (948.50, 1983.43));




--------------------------
--  table: testtable
--------------------------


-- 12. find those rows where col1 contains the escape character underscore ( _ ). Return col1.
-- _ is a special character in SQL which need to escape using back slash
SELECT col1
FROM testtable
WHERE col1 LIKE '%\_%';


-- 13. identify those rows where col1 does not contain the escape character underscore ( _ ). Return col1.
SELECT col1
FROM testtable
WHERE col1 NOT LIKE '%\_%';

-- 14. find rows in which col1 contains the forward slash character ( / ). Return col1. 
-- forward slash is not a special character in SQL and does not need to be escaped when used in a string literal or pattern.
SELECT col1
FROM testtable
WHERE col1 LIKE '%/%';

-- 15. identify those rows where col1 does not contain the forward slash character ( / ). Return col1.
SELECT col1
FROM testtable
WHERE col1 NOT LIKE '%/%';


-- 16. find those rows where col1 contains the string ( _/ ). Return col1. 
SELECT col1 
FROM testtable
WHERE col1 LIKE '%\_/%';


-- 17. find those rows where col1 does not contain the string ( _/ ). Return col1. 
SELECT col1 
FROM testtable
WHERE col1 NOT LIKE '%\_/%';

-- 18. ind those rows where col1 contains the character percent ( % ). Return col1.
SELECT col1
FROM testtable
WHERE col1 LIKE '%\%%';

-- 19. find those rows where col1 does not contain the character percent ( % ). Return col1.

SELECT col1
FROM testtable
WHERE col1 NOT LIKE '%\%%';


+---------+---------------+---------------+----------+
-- table: emp_details
+---------+---------------+---------------+----------+


-- 22. locate the employees whose last name begins with the letter 'D'. Return emp_idno, emp_fname, emp_lname and emp_dept.
SELECT emp_idno, emp_fname, emp_lname, emp_dept
FROM emp_details
WHERE emp_lname LIKE 'D%';



