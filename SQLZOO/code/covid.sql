/*
Window Function tutorial

https://sqlzoo.net/wiki/Window_LAG

COVID-19 Database description

covid table
------------------------------------
name: country name	
whn:  date
confirmed: number of confirmed cases	
deaths: number of deaths	
recovered: number of recovered

*/

-- 1. Introducing the covid table 
-- show the cases in 'Spain' in March 2020.
SELECT name, DAY(whn), confirmed, deaths, recovered
FROM covid
WHERE name = 'Italy'
AND MONTH(whn) = 3 AND YEAR(whn) = 2020
ORDER BY whn;

-- 2. Introducing the LAG function
-- show confirmed for the day before.
SELECT name, DAY(whn), confirmed,
        LAG(whn, 1) OVER (PARTITION BY name ORDER BY whn)
FROM covid
WHERE name = 'Italy'
AND MONTH(whn) = 3 AND YEAR(whn) = 2020
ORDER BY whn;

-- 3. Number of new cases 
-- Show the number of new cases for each day, for Italy, for March
SELECT name, DAY(whn), confirmed-LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY whn) AS new_cases
FROM covid
WHERE name = 'Italy' AND MONTH(whn) = 3 AND YEAR(whn) = 2020
ORDER BY whn

-- 4. Weekly changes
-- Show the number of new cases in Italy for each week in 2020 - show Monday only.
SELECT name, 
        DATE_FORMAT(whn,'%Y-%m-%d') AS date, 
        confirmed-LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY whn) AS new_cases
FROM covid
WHERE name = 'Italy'
AND WEEKDAY(whn) = 0 AND YEAR(whn) = 2020
ORDER BY whn;

-- 5. LAG using a JOIN 
-- Show the number of new cases in Italy for each week - show Monday only.
SELECT tw.name,
       DATE_FORMAT(tw.whn,'%Y-%m-%d') AS date,
       tw.confirmed - lw.confirmed AS new_cases
FROM covid tw
LEFT JOIN covid lw ON (DATE_ADD(lw.whn, INTERVAL 1 WEEK) = tw.whn) AND (tw.name = lw.name)
WHERE tw.name = 'Italy' AND WEEKDAY(tw.whn) = 0
ORDER BY tw.whn;

-- 6. RANK()
-- shows the number of confirmed cases together with the world ranking for cases for the date '2020-04-20'.
-- and the ranking for the number of deaths due to COVID.
SELECT name, 
       confirmed, RANK() OVER (ORDER BY confirmed DESC) rc, 
       deaths, RANK() OVER (ORDER BY deaths DESC) rc
FROM covid
WHERE whn = '2020-04-20'
ORDER BY confirmed DESC;

-- 7. Infection rate
-- Show the infection rate ranking for each country. Only include countries with a population of at least 10 million.
SELECT
   world.name,
   ROUND(100000*confirmed/population,2) AS IR,
   RANK() OVER (ORDER BY 100000*confirmed/population) AS rank
FROM covid JOIN world ON covid.name=world.name
WHERE whn = '2020-04-20' AND population > 10000000
ORDER BY population DESC;

-- 8. Turning the corner
-- For each country that has had at last 1000 new cases in a single day, show the date of the peak number of new cases.
SELECT name,
       DATE_FORMAT(whn,'%Y-%m-%d') AS date,
       new_cases AS peakNewCases
FROM (
        SELECT name, new_cases, whn,
                RANK() OVER (PARTITION BY name ORDER BY new_cases DESC) AS rc
        FROM (
                SELECT name, whn,
                confirmed - LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY whn) AS new_cases
                FROM covid
                ) AS tab
        WHERE tab.new_cases >= 1000
        ) AS tab2
WHERE tab2.rc=1
ORDER BY date;