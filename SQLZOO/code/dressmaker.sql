/*
Dressmaker database exercise from https://sqlzoo.net/wiki/Dressmaker


database description from https://db.grussell.org/erdressmaker.html

8 tables: dress_order, order_line, quantities, garment, jmcust, material, dressmaker, construction

---------------------------------------------------------------
Table dress_order
---------------------------------------------------------------
Customers place orders - each order contains many lines - each line of the order refers to a garment
each order has an unique order number, a customer number, date, whether completed


Field	      Type	    Null	  Key	    Description
order_no	  int   	  NO	    PRI		  unique order number. link to the order_line table on order_ref, link to construction table on order_ref 
cust_no	    int   	  YES			        customer number. link to jmcust table on c_no
order_date	date	    NO			
completed	  char(1)	  YES	            either 'Y' or 'N'. Once all the items in the order have been completed, set to Y, otherwise it is N. 
---------------------------------------------------------------


---------------------------------------------------------------
Table order_line
---------------------------------------------------------------
The "central" table in this database
Each order that a customer places is made up of 1 or more garments.
Each garment in an order takes one line in this table. 


Field	      Type	    Null	  Key	    Description
order_ref	  int   	  NO	    PRI		  order number. order number, link to the dress_order table on order_no, link to construction table on order_ref 
line_no	    int   	  NO	    PRI		  line number. link to construction table on line_ref
ol_style	  int   	  YES	    MUL		  style number. link to garments table on style_no
ol_size	    int   	  NO			        size. (10,12,etc). link to quantities table on both ol_style = style_q AND ol_size  = size_q
ol_material	int   	  YES		          material number. link to material table on material_no
---------------------------------------------------------------



---------------------------------------------------------------
Table jmcust
---------------------------------------------------------------
each customer in dressmaker company has a record for their information

Field	      Type	    Null	Key	  Description
c_no	      int   	  NO	  PRI		unique customer number. link to dress_order table on cust_no
c_name	    char(20)	NO			    customer name
c_house_no	int   	  NO			    house number
c_post_code	char(9)	  NO			
---------------------------------------------------------------


---------------------------------------------------------------
Table quantities
---------------------------------------------------------------
tells how much material is needed to build a particular garment of certain style and size.

Field	    Type	    Null	Key	    Description
style_q	  int   	  NO	  PRI		  style number. link to order_line table on ol_style
size_q	  int   	  NO	  PRI		  size number. link to order_line table on ol_size.
quantity	double	  NO		        unit is feet. e.g., style 4 in size 16 requires 1.5 linear feet of material. Material is sold in a roll, and so someone needs to measure 1.5 feet off the roll and give that to a dressmaker to make the garment.
---------------------------------------------------------------

---------------------------------------------------------------
Table garment
---------------------------------------------------------------
Each garment has a style number, a description (e.g. trousers), a labour cost and some notes

Field	      Type	    Null	  Key	    Description
style_no	  int   	  NO	    PRI		  unique style number. link to quantities table on style_q, or order_line table on ol_style
description	char(20)	NO			        garment description, e.g., 'Trousers', 'Long Skirt', 'Shorts', 'Short Skirt', 'Sundress', 'Suntop'
labour_cost	double	  NO			        money for dressmaker, e.g., '18'. The dressmakers are all freelance, and thus get paid only on completion of a garment.
notions   	char(50)	  YES			      notes, e.g., 'Zip/2 off 1.5cm buttons/ hem tape/ waist band'
---------------------------------------------------------------

---------------------------------------------------------------
Table material
---------------------------------------------------------------
each material has diffrent properties, fabric, color, pattern and cost

Field	        Type	      Null	  Key	    Description
material_no	  int   	    NO	    PRI		  unique material number. link to order_line table on ol_material
fabric	      char(20)	  NO			        fabric name (e.g. 'Silk', 'Cotton')
colour	      char(20)	  NO			        fabric colours  (e.g., 'Red Abstract', 'Black')
pattern	      char(20)	  NO			        fabric patterns (e.g. 'Stripes', 'Plain')
cost	        double	    NO			        price of the material in linear feet
---------------------------------------------------------------


---------------------------------------------------------------
construction
---------------------------------------------------------------
each garment in an order was assigned to a dressmaker

Field	      Type	    Null	Key	  Description
maker	      int   	  NO	  PRI		dressmaker number. link to dressmaker table on d_no
order_ref	  int   	  NO	  PRI		link to dress_order table on order_no
line_ref	  int   	  NO	  PRI		link to order_line table on line_no
start_date	date	    NO			    when a dressmaker was allocated
finish_date	date	    YES			    when the item was completed. NULL when it is not finished
---------------------------------------------------------------

---------------------------------------------------------------
dressmaker
---------------------------------------------------------------
Each dressmaker who works for the company has a record  

Field	      Type	    Null	Key	  Description 
d_no	      int   	  NO	  PRI		unique dressmaker number. link to construction table on maker
d_name	    char(20)	NO			
d_house_no	int   	  NO			
d_post_code	char(8)	  NO		
---------------------------------------------------------------


*/


-- Easy questions 1-5

-- 1. List the post code, order number, order date and garment descriptions for all items associated with Ms Brown.
*/

SELECT j.c_post_code, d.order_no, d.order_date, g.description
FROM dress_order d
   JOIN order_line o ON d.order_no = o.order_ref
   JOIN jmcust j ON j.c_no = d.cust_no
   JOIN garment g ON g.style_no = o.ol_style
WHERE j.c_name = 'Ms Brown'



-- 2. List the customer name, postal information, order date and order number of all orders that have been completed.

SELECT j.c_name, j.c_post_code, d.order_date, d.order_no
FROM dress_order d
   JOIN jmcust j ON j.c_no = d.cust_no
WHERE d.completed = 'Y';


-- 3. Which garments have been made or are being made from 'red abstract' or 'blue abstract' coloured materials.

SELECT DISTINCT g.description
FROM order_line o
    JOIN garment g ON g.style_no = o.ol_style
    JOIN material m ON m.material_no = o.ol_material
WHERE m.colour IN ('Red Abstract', 'Blue Abstract')


-- 4. How many garments has each dressmaker constructed?
--    You should give the number of garments and the name and postal information of each dressmaker.

SELECT d.d_name, d.d_post_code, COUNT(*) AS garment_count
FROM construction c
LEFT JOIN dressmaker d ON c.maker=d.d_no
GROUP BY d.d_name, d.d_post_code;



-- 5. Give the names of those dressmakers who have finished items made from silk for completed orders.
SELECT DISTINCT d.d_name AS dressmaker
FROM dress_order d2
    LEFT JOIN order_line o ON d2.order_no = o.order_ref
    LEFT JOIN construction c ON c.order_ref = d2.order_no
    LEFT JOIN dressmaker d ON c.maker=d.d_no
    LEFT JOIN material m ON m.material_no = o.ol_material
WHERE d2.completed = 'Y' AND m.fabric='Silk';


-- Medium Questions 1-5

-- 1. Assuming that any garment could be made in any of the available materials,
--    list the garments (description, fabric, colour and pattern) which are expensive to make,
--    that is, those for which the labour costs are 80% or more of the total cost.
-- use cross join

WITH temp1 AS (
  SELECT DISTINCT description, labour_cost, quantity
  FROM garment g 
    JOIN quantities q ON g.style_no = q.style_q
), temp2 AS (
  SELECT DISTINCT fabric, colour, pattern, cost
  FROM material
)
SELECT description, fabric, colour, pattern
FROM temp1 
    CROSS JOIN temp2
WHERE labour_cost >= 0.8* (labour_cost + cost*quantity);



-- 2. List the descriptions and the number of orders of the less popular garments,
--      that is those for which less than the average number of orders per garment have been placed.
--    Also print    out the average number of orders per garment.
--    When calculating the average, ignore any garments for which no orders have been made.


WITH temp1 AS (SELECT g.description, COUNT(*) AS count
FROM order_line o
LEFT JOIN garment g ON o.ol_style = g.style_no
GROUP BY g.description), temp2 AS (
SELECT AVG(count) AS avg
FROM temp1)

SELECT temp1.description, count, temp2.avg
FROM temp1, temp2
WHERE temp1.count < temp2.avg
;



-- 3. Which is the most popular line, that is, the garment with the highest number of orders.
--    Bearing in mind the fact that there may be several such garments, list the garment description(s) and number(s) of orders.

WITH temp AS (
  SELECT description, COUNT(*) line_count
  FROM garment g JOIN order_line ol ON g.style_no = ol.ol_style
  GROUP BY description
)
SELECT *
FROM temp
WHERE order_cnt = (SELECT MAX(order_cnt) FROM temp);



-- 4. List the descriptions, color, pattern and costs of the more expensive garments which might be ordered,
    --  than the average cost (labour costs + material costs) to make a size 8 and Cotton garment.

WITH temp AS (
    SELECT  g.description, m.colour, m.pattern, 
        ROUND(g.labour_cost + m.cost* q.quantity, 2) AS total_cost 
    FROM garment g 
        JOIN quantities q ON g.style_no = q.style_q
        CROSS JOIN material m
    WHERE q.size_q = 8 AND m.fabric = 'Cotton'
)
SELECT *
FROM temp
WHERE total_cost > (SELECT AVG(total_cost) FROM temp)
ORDER BY total_cost DESC;


/*
#5) Dressmaker Medium Questions

Q. What is the most common size ordered for each garment type?
   List description, size and number of orders, assuming that there could be several equally popular sizes for each type.
*/
WITH temp AS (
    SELECT 
        description, 
        ol_size, 
        COUNT(*) AS cnt,
        MAX(COUNT(*)) OVER (PARTITION BY description) AS max_cnt
    FROM garment g 
        JOIN order_line ol ON g.style_no = ol.ol_style
    GROUP BY description, ol_size
)
SELECT description, ol_size, cnt
FROM temp
WHERE max_cnt = cnt
ORDER BY description, ol_size, cnt;


-- Dressmaker Hard Questions 1-5

-- 1. It is decided to review the materials stock. How much did each material contribute to turnover in 2002?

SELECT material_no, fabric, colour, pattern, ROUND(SUM(quantity) * m.cost, 2) AS cost
FROM order_line ol 
    JOIN material m ON ol.ol_material = m.material_no
    JOIN quantities q ON (ol.ol_style = q.style_q) AND (ol.ol_size = size_q)
    JOIN dress_order do ON ol.order_ref = do.order_no
WHERE YEAR(order_date) = 2002
GROUP BY material_no, fabric, colour, pattern, m.cost;



-- 2.  An order for shorts has just been placed and the work is to be distributed amongst the workforce,
    --   and we wish to know how busy the shorts makers are.
    -- For each of the workers who have experience of making shorts show the number of hours work that she is currently committed to,
    --   assuming a meagre wage of £4.50 per hour.


SELECT d_name, 
        COALESCE(ROUND(SUM(labour_cost / 4.5), 1), 0) AS hours
FROM dressmaker d 
    JOIN construction c ON d.d_no = c.maker
    JOIN order_line ol ON (c.order_ref = ol.order_ref AND c.line_ref = ol.line_no)
    JOIN dress_order do ON ol.order_ref = do.order_no
    JOIN garment g ON ol.ol_style = g.style_no
WHERE finish_date IS NULL 
    AND d.d_no IN (SELECT DISTINCT d.d_no
        FROM dressmaker d JOIN construction c ON d.d_no = c.maker
        JOIN order_line ol ON (c.order_ref = ol.order_ref AND c.line_ref = ol.line_no)
        JOIN garment g ON ol.ol_style = g.style_no
        WHERE description LIKE '%shorts%')
GROUP BY d_name;



-- 3.  "Big spender of the year" is the customer who spends the most on high value items.
--     Identify the "Big spender of the year 2002" if the "high value" threshold is set at £30.
--     Also who would it be if the threshold was £20 or £50?

WITH tempa AS (
  SELECT c_name, order_ref, line_no, ROUND((labour_cost + quantity * cost), 2) dress_cost
  FROM order_line ol JOIN garment g ON ol.ol_style = g.style_no
  JOIN quantities q ON (ol.ol_style = q.style_q AND ol.ol_size = size_q)
  JOIN material m ON ol.ol_material = m.material_no
  JOIN dress_order do ON ol.order_ref = do.order_no
  JOIN jmcust j ON do.cust_no = j.c_no
  WHERE YEAR(order_date) = 2002
), temp30a AS (
  SELECT c_name big_spender, SUM(dress_cost) total_spent
  FROM tempa
  WHERE dress_cost >= 30
  GROUP BY c_name
  ORDER BY total_spent DESC
), temp30 AS (
  SELECT *, '£30' Threshold
  FROM temp30a
  WHERE total_spent = (SELECT MAX(total_spent) FROM temp30a)
), temp20a AS (
  SELECT c_name big_spender, SUM(dress_cost) total_spent
  FROM tempa
  WHERE dress_cost >= 20
  GROUP BY c_name
  ORDER BY total_spent DESC
), temp20 AS (
  SELECT *, '£20' Threshold
  FROM temp20a
  WHERE total_spent = (SELECT MAX(total_spent) FROM temp20a)
), temp50a AS (
  SELECT c_name big_spender, SUM(dress_cost) total_spent
  FROM tempa
  WHERE dress_cost >= 50
  GROUP BY c_name
  ORDER BY total_spent DESC
), temp50 AS (
  SELECT *, '£50' Threshold
  FROM temp50a
  WHERE total_spent = (SELECT MAX(total_spent) FROM temp50a)
)
(SELECT * FROM temp30) UNION ALL
(SELECT * FROM temp20) UNION ALL
(SELECT * FROM temp50);



-- 4.  Who is the fastest at making trousers?

WITH temp AS (
  SELECT d_name, DATEDIFF(finish_date, start_date) day_per_trouser
  FROM order_line ol 
    JOIN garment g ON ol.ol_style = g.style_no
    JOIN construction c ON (ol.order_ref = c.order_ref AND ol.line_no = c.line_ref)
    JOIN dressmaker d ON c.maker = d.d_no
  WHERE (description LIKE '%trousers%') AND (finish_date IS NOT NULL)
)
SELECT d_name, day_per_trouser
FROM temp
WHERE day_per_trouser = (SELECT MIN(day_per_trouser) FROM temp);



-- 5.  "Employee of the month" is the seamstress who completes the greatest value of clothes.
    -- Show the "employees of the month" for months in 2002.

WITH temp1 AS (
  SELECT d_name, DATE_FORMAT(finish_date, '%b') month_, SUM(ROUND((labour_cost + quantity * cost), 2)) month_value
  FROM order_line ol JOIN garment g ON ol.ol_style = g.style_no
  JOIN quantities q ON (ol.ol_style = q.style_q AND ol.ol_size = size_q)
  JOIN material m ON ol.ol_material = m.material_no
  JOIN dress_order do ON ol.order_ref = do.order_no
  JOIN construction c ON (ol.order_ref = c.order_ref AND ol.line_no = c.line_ref)
  JOIN dressmaker d ON c.maker = d.d_no
  WHERE (YEAR(order_date) = 2002) AND (finish_date IS NOT NULL)
  GROUP BY d_name, month_
), temp2 AS (
  SELECT *, MAX(month_value) OVER (PARTITION BY month_) month_max_val
  FROM temp1
)
SELECT d_name EmpOfTheMnth, month_, month_value
FROM temp2
WHERE month_value = month_max_val;