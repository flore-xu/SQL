/* 
JOIN tutorial from https://sqlzoo.net/wiki/More_JOIN_operations

Movie data description

table movie
---------------------------
id: Unique movie id. PK
title: title of movie	
yr: year of movie	
director: name of director	
budget: budget in dollars	
gross: profit in dollars

table actor
---------------------------
id: unique actor id	
name: name of actor 

table casting
---------------------------
movieid: PK. movie id	
actorid: actor id
ord: position of the actor. If ord=1 then this actor is in the starring role
*/


-- 1	1962 movies
-- List the films where the yr is 1962 [Show id, title]
SELECT id, title
FROM movie
WHERE yr=1962;

-- 2	When was Citizen Kane released?
SELECT yr
FROM movie
WHERE title = 'Citizen Kane';

-- 3	Star Trek movies
-- List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). 
-- Order results by year.
SELECT id, title, yr
FROM movie
WHERE title LIKE '%Star Trek%'
ORDER BY yr;

-- 4	id for actor Glenn Close
SELECT id
FROM actor
WHERE name='Glenn Close';

-- 5	id for movie Casablanca
SELECT id
FROM movie
WHERE title='Casablanca';

-- 6	Cast list for movie Casablanca
-- The cast list is the names of the actors who were in the movie.
SELECT actor.name
FROM movie
LEFT JOIN casting ON movie.id = casting.movieid
LEFT JOIN actor ON actor.id = casting.actorid
WHERE title='Casablanca';

-- 7	Alien cast list
SELECT actor.name
FROM movie
LEFT JOIN casting ON movie.id = casting.movieid
LEFT JOIN actor ON actor.id = casting.actorid
WHERE title='Alien';

-- 8	Harrison Ford movies
-- List the films in which actor 'Harrison Ford' has appeared
SELECT movie.title
FROM movie
LEFT JOIN casting ON movie.id = casting.movieid
LEFT JOIN actor ON actor.id = casting.actorid
WHERE actor.name= 'Harrison Ford' ;

-- 9	Harrison Ford as a supporting actor
-- List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. 
-- If ord=1 then this actor is in the starring role]
SELECT movie.title
FROM movie
LEFT JOIN casting ON movie.id = casting.movieid
LEFT JOIN actor ON actor.id = casting.actorid
WHERE actor.name= 'Harrison Ford' AND casting.ord <> 1;


-- 10	Lead actors in 1962 movies
SELECT movie.title, actor.name
FROM movie
LEFT JOIN casting ON movie.id = casting.movieid
LEFT JOIN actor ON actor.id = casting.actorid
WHERE movie.yr= 1962 AND casting.ord = 1;

-- 11	Busy years for Rock Hudson
-- Which were the busiest years for 'Rock Hudson', 
-- show the year and the number of movies he made each year for any year in which he made more than 2 movies.
SELECT yr,COUNT(title) AS Count 
FROM movie 
JOIN casting ON movie.id=movieid
JOIN actor   ON actorid=actor.id
WHERE actor.name='Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2;

-- 12	Lead actor in Julie Andrews movies
-- List the film title and the leading actor for all of the films 'Julie Andrews' played in.
SELECT movie.title, actor.name 
FROM movie 
JOIN casting ON movie.id=movieid
JOIN actor   ON actorid=actor.id
WHERE movie.id IN (SELECT casting.movieid FROM casting 
                    WHERE casting.actorid = (
                    SELECT id FROM actor
                    WHERE actor.name='Julie Andrews')) 
                AND casting.ord=1;

-- 13	Actors with 15 leading roles
-- Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles.
SELECT actor.name 
FROM movie 
JOIN casting ON movie.id=movieid
JOIN actor   ON actorid=actor.id
WHERE casting.ord=1
GROUP BY actor.name
HAVING COUNT(movie.title) >= 15
ORDER BY actor.name ASC ;

-- 14	Movies released in the year 1978
-- List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
SELECT movie.title, COUNT(actor.name) AS Count
FROM movie 
JOIN casting ON movie.id=movieid
JOIN actor   ON actorid=actor.id
WHERE movie.yr=1978
GROUP BY movie.title
ORDER BY COUNT(actor.name) DESC, movie.title;

-- 15	Actors worked with 'Art Garfunkel'
-- List all the people who have worked with actor 'Art Garfunkel'.
SELECT DISTINCT(actor.name)
FROM movie 
JOIN casting ON movie.id=movieid
JOIN actor   ON actorid=actor.id
WHERE movie.id IN (
SELECT casting.movieid 
FROM casting 
WHERE casting.actorid = (
  SELECT id FROM actor
  WHERE actor.name='Art Garfunkel')
) AND actor.name <>'Art Garfunkel';