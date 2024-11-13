/*
White Christmas challenge from https://sqlzoo.net/wiki/White_Christmas


HadCET data description :

the longest available instrumental record of temperature in the world, currently available from the UK Met Office. 
It provides the daily mean temperature for the centre of England since 1772.
---------------------------------------------------------------------------
Field	  Type	    Null	  Key	  Description
yr	    int(11)  	NO	    PRI	  year 
dy	    int(11)	  NO	    PRI	  day of month	
m1	    int(11)	  YES	          daily mean temperature in January (unit 10th of a degree Celcius)
...                             next twelve columns are for January through to December.
m12                             daily mean temperature in December
---------------------------------------------------------------------------
*/

-- 1	Days, Months and Years
-- Show the average daily temperature for August 10th 1964
SELECT m8/10 
FROM hadcet
WHERE yr=1964 AND dy=10;

-- 2	preteen Dickens
-- Show the twelve temperatures.
-- Charles Dickens is said to be responsible for the tradition of expecting snow at Christmas Daily Telegraph. 
-- Show the temperature on Christmas day (25th December) for each year of his childhood. 
-- He was born in February 1812 - so he was 1 (more or less) in December 1812.
SELECT yr-1811 as age, m12/10 AS temp
FROM hadcet
WHERE yr BETWEEN 1812 and 1812+11 AND dy=25;

-- 3	Minimum Temperature Before Christmas

-- For each age 1-12 show which years were a White Christmas. Show 'White Christmas' or 'No snow' for each age.
-- We declare a White Christmas if there was a day with an average temperature below zero between 21st and 25th of December.
WITH temp1 AS (
  SELECT yr-1811 age, dy, m12 / 10 temp, IF(m12 < 0, 1, 0) snow
  FROM hadcet
  WHERE (dy BETWEEN 21 AND 25) AND (yr BETWEEN 1812 AND 1823)
), temp2 AS (
  SELECT age, SUM(snow) white_xmas
  FROM temp1
  GROUP BY age
)
SELECT age, IF(white_xmas > 0, 'White Christmas', 'No Snow') xmas_snow
FROM temp2;




-- 4	White Christmas Count
-- List all the years and the wcc for children born in each year of the data set. 
-- Only show years where the wcc was at least 7.
-- A person's White Christmas Count (wcc) is the number of White Christmases they were exposed to as a child (between 3 and 12 inclusive assuming they were born at the beginning of the year and were about 1 year old on their first Christmas).

-- Charles Dickens's wcc was 8.
WITH temp1 AS (
  SELECT yr, dy, m12 / 10 temp, IF(m12 < 0, 1, 0) snow
  FROM hadcet
  WHERE dy BETWEEN 21 AND 25
), temp2 AS (
  SELECT yr, SUM(snow) white_xmas_a
  FROM temp1
  GROUP BY yr
), temp3 AS (
  SELECT yr, IF(white_xmas_a > 0, 1, 0) white_xmas
  FROM temp2
), temp4 AS (
  SELECT yr, (SELECT SUM(white_xmas) FROM temp3 WHERE temp3.yr BETWEEN t.yr+2 AND t.yr+11) wcc
  FROM temp3 t
)
SELECT *
FROM temp4
WHERE wcc >= 7;

-- 5	Climate Change
-- average temperatures for August by decade. 
SELECT TRUNCATE(yr,-1) AS decade, 
  ROUND(AVG(NULLIF(m8,-999))/10,1) AS avg_temp
FROM hadcet
GROUP BY TRUNCATE(yr,-1)