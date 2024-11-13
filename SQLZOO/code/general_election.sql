/* Window function tutorial

https://sqlzoo.net/wiki/Window_functions

general election database description

table ge
-------------------------------------------------
yr: year
firstName: first name of candidate	
lastName: last name of candidate	
constituency: code of a constituency, e.g., 'S14000024', Scottland starts as 'S'
party: party name, e.g., 'Labour'
votes: number of votes

*/
-- 1	Warming up
-- Show the lastName, party and votes for the constituency 'S14000024' in 2017.
SELECT lastName, party, votes
FROM ge
WHERE constituency = 'S14000024' AND yr = 2017
ORDER BY votes DESC;
-- 2	Who won?
-- Show the party and RANK for constituency S14000024 in 2017. List the output by party
SELECT party, votes,
       RANK() OVER (ORDER BY votes DESC) as posn
FROM ge
WHERE constituency = 'S14000024' AND yr = 2017
ORDER BY party;

-- 3	PARTITION BY
-- show the ranking of each party in S14000021 in each year. Include yr, party, votes and ranking (the party with the most votes is 1).
SELECT yr, party, votes,
        RANK() OVER (PARTITION BY yr ORDER BY votes DESC) as posn
FROM ge
WHERE constituency = 'S14000021'
ORDER BY party,yr;

-- 4	Edinburgh Constituency
-- Edinburgh constituencies are numbered S14000021 to S14000026.

-- show the ranking of each party in Edinburgh Constituency in 2017. 
-- Order your results so the winners are shown first, then ordered by constituency.
SELECT constituency, party, votes,
        RANK() OVER (PARTITION BY constituency ORDER BY votes DESC) AS posn
FROM ge
WHERE constituency BETWEEN 'S14000021' AND 'S14000026' AND yr  = 2017
ORDER BY posn, constituency ASC;

-- 5	Winners Only
-- Show the parties that won for each Edinburgh constituency in 2017.

SELECT constituency, party
FROM (SELECT constituency, party, votes, RANK() OVER (PARTITION BY constituency ORDER BY votes DESC) AS posn
      FROM ge
      WHERE constituency BETWEEN 'S14000021' AND 'S14000026' AND yr  = 2017
      ) AS x
WHERE x.posn = 1;

-- 6	Scottish seats
-- Show how many seats for each party in Scotland in 2017.
-- i.e. how many constituency did each party win
-- Scottish constituencies start with 'S'
SELECT party, COUNT(*) AS Seat
FROM (SELECT constituency, party, votes, RANK() OVER (PARTITION BY constituency ORDER BY votes DESC) AS posn
      FROM ge
      WHERE constituency LIKE 'S%' AND yr  = 2017
     ) AS x
WHERE x.posn = 1
GROUP BY party;