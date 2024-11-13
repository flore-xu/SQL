-- SUM and COUNT Tutorial from https://sqlzoo.net/wiki/SUM_and_COUNT

-- 1	Total world population
-- Show the total population of the world.
SELECT SUM(population)
FROM world;

-- 2	List of continents
-- List all the continents - just once each.
SELECT DISTINCT(continent)
FROM world;

-- 3	GDP of Africa
-- Give the total GDP of Africa
SELECT SUM(gdp) AS Total_gdp
FROM world
WHERE continent='Africa';

-- 4	Counting the countries of each continent
-- How many countries have an area of at least 1000000
SELECT COUNT(area) AS Count
FROM world
WHERE area >= 1000000;

-- 5	Baltic states population
-- What is the total population of ('Estonia', 'Latvia', 'Lithuania')
SELECT SUM(population) AS Total_pop
FROM world
WHERE name in ('Estonia', 'Latvia', 'Lithuania');

-- 6	Counting countries of each continent
-- For each continent show the continent and number of countries.
SELECT continent, COUNT(name) AS Count
FROM world
GROUP BY continent;

-- 7	Counting big countries in each continent
SELECT continent, COUNT(name) AS Count
FROM world
WHERE population >= 10000000
GROUP BY continent;

-- 8	Counting big continents
-- List the continents that have a total population of at least 100 million.
SELECT continent
FROM world
GROUP BY continent
HAVING SUM(population) >= 100000000;