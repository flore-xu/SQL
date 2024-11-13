
---------------------------------------------
-- table: salesman
---------------------------------------------


-- 1. displays all the information about all salespeople.
SELECT *
FROM salesman;

-- 2. display a string "This is SQL Exercise, Practice and Solution"
SELECT "This is SQL Exercise, Practice and Solution";

-- 3. display three numbers in three columns
SELECT 1, 2, 3;

-- 4. display the sum of two numbers 10 and 15 from the RDBMS server.
SELECT 10 + 15;

-- 5. display the result of an arithmetic expression.  
SELECT (23 + 45) * 2;

-- 6. display specific columns such as names and commissions for all salespeople. 
SELECT name, commission
FROM salesman;

-- 9. locate salespeople who live in the city of 'Paris'. Return salesperson's name, city.
SELECT name, city
FROM salesman
WHERE city = 'Paris';


---------------------------------------------
-- table: orders
---------------------------------------------


-- 7. display the columns in a specific order, such as order date, salesman ID, order number, and purchase amount for all orders.
SELECT order_no, purchase_amt, ord_date, salesman_id
FROM orders;

-- 8. identify the unique salespeople ID. Return salesman_id.
SELECT DISTINCT salesman_id
FROM orders;

-- 11. find orders that are delivered by a salesperson with ID 5001. Return ord_no, ord_date, purch_amt.
SELECT ord_no, ord_date, purch_amt
FROM orders
WHERE salesman_id = 5001;


---------------------------------------------
-- table: customer
---------------------------------------------


-- 10. find customers whose grade is 200. Return customer_id, cust_name, city, grade, salesman_id.
SELECT customer_id, cust_name, city, grade, salesman_id
FROM customer
WHERE grade = 200;


---------------------------------------------
-- table: nobel_win
---------------------------------------------


-- 12. find the Nobel Prize winner(s) for the year 1970. Return year, subject and winner. 
SELECT YEAR, SUBJECT, WINNER
FROM nobel_win
WHERE YEAR = 1970;

-- 13. find the Nobel Prize winner in ‘Literature’ for 1971. Return winner.  
SELECT WINNER
FROM nobel_win
WHERE YEAR = 1971 AND SUBJECT = 'Literature';

-- 14. locate the Nobel Prize winner ‘Dennis Gabor'. Return year, subject.
SELECT YEAR, SUBJECT
FROM nobel_win
WHERE WINNER = 'Dennis Gabor';

-- 15. find the Nobel Prize winners in the field of ‘Physics’ since 1950. Return winner. 
SELECT WINNER
FROM nobel_win
WHERE SUBJECT = 'Physics' AND YEAR >= 1950;

-- 16. find the Nobel Prize winners in ‘Chemistry’ between the years 1965 and 1975. 
-- Begin and end values are included. Return year, subject, winner, and country. 
SELECT YEAR, SUBJECT, WINNER, COUNTRY
FROM nobel_win
WHERE SUBJECT = 'Chemistry' AND YEAR BETWEEN 1965 AND 1975;

-- 17. display all details of the Prime Ministerial winners after 1972 of Menachem Begin and Yitzhak Rabin.
SELECT *
FROM nobel_win
WHERE SUBJECT = 'Prime Ministerial' AND YEAR > 1972 AND WINNER IN ('Menachem Begin', 'Yitzhak Rabin');

-- 18. retrieve the details of the winners whose first names match with the string ‘Louis’. Return year, subject, winner, country, and category.
SELECT YEAR, SUBJECT, WINNER, COUNTRY, CATEGORY
FROM nobel_win
WHERE WINNER LIKE 'Louis%';

-- 19. combines the winners in Physics, 1970 and in Economics, 1971. Return year, subject, winner, country, and category. 
SELECT YEAR, SUBJECT, WINNER, COUNTRY, CATEGORY
FROM nobel_win
WHERE (SUBJECT = 'Physics' AND YEAR = 1970) OR (SUBJECT = 'Economics' AND YEAR = 1971);

-- 20. find the Nobel Prize winners in 1970 excluding the subjects of Physiology and Economics. Return year, subject, winner, country, and category.
SELECT YEAR, SUBJECT, WINNER, COUNTRY, CATEGORY
FROM nobel_win
WHERE YEAR = 1970 AND SUBJECT NOT IN ('Physiology', 'Economics');

-- 21. combine the winners in 'Physiology' before 1971 and winners in 'Peace' on or after 1974. Return year, subject, winner, country, and category. 
SELECT YEAR, SUBJECT, WINNER, COUNTRY, CATEGORY
FROM nobel_win
WHERE (SUBJECT = 'Physiology' AND YEAR < 1971) OR (SUBJECT = 'Peace' AND YEAR >= 1974);

-- 22. find the details of the Nobel Prize winner 'Johannes Georg Bednorz'. Return year, subject, winner, country, and category.
SELECT YEAR, SUBJECT, WINNER, COUNTRY, CATEGORY
FROM nobel_win
WHERE WINNER = 'Johannes Georg Bednorz';

-- 23. find Nobel Prize winners for the subject that does not begin with the letter 'P'. Return year, subject, winner, country, and category. 
-- Order the result by year, descending and winner in ascending. 
SELECT YEAR, SUBJECT, WINNER, COUNTRY, CATEGORY
FROM nobel_win
WHERE SUBJECT NOT LIKE 'P%'
ORDER BY YEAR DESC, WINNER ASC;

-- 24. find the details of 1970 Nobel Prize winners. 
-- Order the results by subject, ascending except for 'Chemistry' and ‘Economics’ which will come at the end of the result set. Return year, subject, winner, country, and category.
SELECT YEAR, SUBJECT, WINNER, COUNTRY, CATEGORY
FROM nobel_win
WHERE YEAR = 1970
ORDER BY CASE WHEN SUBJECT IN ('Chemistry', 'Economics') THEN 1 ELSE 0 END, SUBJECT ASC;


---------------------------------------------
-- table: item_mast
---------------------------------------------


-- 25. select a range of products whose price is in the range Rs.200 to Rs.600. Begin and end values are included. Return pro_id, pro_name, pro_price, and pro_com.
-- “Rs” is an abbreviation for “rupees,” which is the currency of several countries in South Asia, including India, Pakistan, Nepal, Sri Lanka
SELECT PRO_ID, PRO_NAME, PRO_PRICE, PRO_COM
FROM item_mast
WHERE PRO_PRICE BETWEEN 200 AND 600;

-- 26. calculate the average price for a manufacturer code of 16. Return avg.
SELECT AVG(PRO_PRICE)
FROM item_mast
WHERE PRO_COM = 16;

-- 27. display the pro_name as 'Item Name' and pro_priceas 'Price in Rs.' 
SELECT PRO_NAME AS 'Item Name', PRO_PRICE AS 'Price in Rs.'
FROM item_mast;

-- 28. find the items whose prices are higher than or equal to $250. Order the result by product price in descending, then product name in ascending. Return pro_name and pro_price.
SELECT PRO_NAME, PRO_PRICE
FROM item_mast
WHERE PRO_PRICE >= 250
ORDER BY PRO_PRICE DESC, PRO_NAME ASC;

-- 29. calculate average price of the items for each company. Return average price and company code.
SELECT AVG(PRO_PRICE), PRO_COM
FROM item_mast
GROUP BY PRO_COM;

-- 30. find the cheapest item(s). Return pro_name and, pro_price.
SELECT PRO_NAME, PRO_PRICE
FROM item_mast
WHERE PRO_PRICE = (SELECT MIN(PRO_PRICE) FROM item_mast);


---------------------------------------------
-- table: emp_details
---------------------------------------------


-- 31. find the unique last name of all employees. Return emp_lname.
SELECT DISTINCT EMP_LNAME
FROM emp_details;

-- 32. find the details of employees whose last name is 'Snares'. Return emp_idno, emp_fname, emp_lname, and emp_dept.
SELECT EMP_IDNO, EMP_FNAME, EMP_LNAME, EMP_DEPT
FROM emp_details
WHERE EMP_LNAME = 'Snares';

-- 33. retrieve the details of the employees who work in the department 57. Return emp_idno, emp_fname, emp_lname and emp_dept.
SELECT EMP_IDNO, EMP_FNAME, EMP_LNAME, EMP_DEPT
FROM emp_details
WHERE EMP_DEPT = 57;







