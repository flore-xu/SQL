/* 
SELF JOIN Tutorial on Edinburgh Buses database from https://sqlzoo.net/wiki/Self_join

Edinburgh Buses database description
https://sqlzoo.net/wiki/Edinburgh_Buses.

2 tables: stops, route
-------------------------------
Table stops
-------------------------------
Field	    Type	      Null	Key	   Description
id	      int(11)	    NO	  PRI		 unique stop id. e.g., 53
name	    varchar(30)	YES		       stop name,  e.g., 'Craiglockhart'
-------------------------------

-------------------------------
Table route
-------------------------------
Field	    Type	      Null	Key	    Description
num	      varchar(5)	NO	  PRI		  unique bus number. appears on the front of the vehicle., e.g., 1
company	  varchar(3)	NO	  PRI		  bus companies operate in Edinburgh. The main one is Lothian Region Transport - 'LRT'
pos	      int(11)	    NO	  PRI		  order of the stop within one route. Some routes may revisit a stop. Most buses go in both directions.
stop	    int(11)	    YES	  MUL		  stop id. This references the stops table
-------------------------------
*/
-- 1. How many stops are in the database.
SELECT COUNT(DISTINCT stop) AS stops
FROM route;

-- 2. Find the id value for the stop 'Craiglockhart'
SELECT id
FROM stops
WHERE name= 'Craiglockhart';

-- 3. Give the id and the name for the stops on the number '4' bus of 'LRT' service.
SELECT id, name
FROM stops
LEFT JOIN route ON stops.id=route.stop
WHERE company = 'LRT' AND num = '4';

-- 4. Routes and stops
-- The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53). 
-- Run the query and notice the two services that link these stops have a count of 2. 
-- Add a HAVING clause to restrict the output to these two routes.
SELECT company, num, COUNT(*) AS count
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num
HAVING COUNT(*) = 2;

-- 5. show services from Craiglockhart to London Road without changing routes

SELECT a.company, a.num, a.stop AS start_stop, b.stop AS end_stop
FROM route a 
JOIN route b ON (a.company=b.company AND a.num=b.num)
WHERE a.stop=53 AND b.stop=149;

-- 6. shoe services between 'Craiglockhart' and 'London Road' are shown.
-- The query shown is similar to the previous one, however by joining two copies of the stops table we can refer to stops by name rather than by number. 
SELECT a.company, a.num, stopa.name AS start_stop, stopb.name AS end_stop
FROM route a 
JOIN stops stopa ON (a.stop=stopa.id)
JOIN route b ON (a.company=b.company AND a.num=b.num)
JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND stopb.name= 'London Road';

-- 7. Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')
SELECT a.company, a.num
FROM route a JOIN route b ON (a.company=b.company AND a.num=b.num)
            JOIN stops stopa ON (a.stop=stopa.id)
            JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Haymarket' AND stopb.name= 'Leith'
GROUP BY a.company, a.num;

-- 8. Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'
SELECT a.company, a.num
FROM route a JOIN route b ON (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND stopb.name= 'Tollcross'
GROUP BY a.company, a.num;

-- 9. Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, including 'Craiglockhart' itself, offered by the LRT company. 
-- Include the company and bus no. of the relevant services.
SELECT DISTINCT sb.name, a.company, a.num
FROM stops sa
JOIN route a ON a.stop = sa.id
JOIN route b ON (a.company = b.company AND a.num = b.num)
JOIN stops sb ON b.stop = sb.id
WHERE sa.name = 'Craiglockhart';

-- 10. Find the routes involving two buses that can go from Craiglockhart to Lochend.
-- Show the bus no. and company for the first bus, the name of the stop for the transfer,
-- and the bus no. and company for the second bus.
SELECT a.num, a.company, stops.name, c.num, c.company
from route a join route b on a.company=b.company AND a.num=b.num
join stops on stops.id=b.stop
join route c on stops.id=c.stop
join route d on c.company=d.company AND c.num=d.num
where a.stop =(select id from stops where name= 'Craiglockhart')
and d.stop =(select id from stops where name= 'Lochend')