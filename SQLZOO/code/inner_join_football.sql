/*
 JOIN operation Tutorial from https://sqlzoo.net/wiki/The_JOIN_operation

football database description

table game
-------------------------------------
id: PK. unique game id e.g., 1001, 1002
mdate: date of game, e.g., '8 June 2012'
stadium: e.g. 'National Stadium, Warsaw'
team1: team id in country code, e.g., 'GRE' for Germany
team2: team id in country code against team1

table eteam
-------------------------------------
id: PK. unique team id in country code, e.g., 'GRE' for Germany
teamname: country name, e.g., 'Germany'
coach: coach name of the team, e.g., 'Dick Advocaat'

table goal
-------------------------------------
matchid: PK. unique match id 
teamid: team id
player: name of player who made this goal, e.g., 'Robert Lewandowski'
gtime: time (minute) of goal in this match, e.g., 17 
*/


-- 1. show the matchid and player name for all goals scored by Germany. 

SELECT matchid, player 
FROM goal 
WHERE teamid = 'GER';

-- 2. Show id, stadium, team1, team2 for just game 1012
SELECT id,stadium,team1,team2
FROM game
WHERE id = 1012;

-- 3. show the player, teamid, stadium and mdate for every German goal.

SELECT player,teamid, stadium,mdate
FROM game tab1
JOIN goal tab2 ON (tab1.id=tab2.matchid)
WHERE teamid = 'GER'

-- 4. Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'
select team1, team2, player
FROM game tab1
JOIN goal tab2 ON (tab1.id=tab2.matchid)
WHERE player LIKE 'Mario%';

-- 5. Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10
SELECT player, teamid, coach, gtime
FROM goal tab1
JOIN eteam tab2 ON tab1.teamid=tab2.id
WHERE gtime<=10;

-- 6. List the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.
SELECT game.mdate, eteam.teamname
FROM game
JOIN eteam ON game.team1=eteam.id
WHERE eteam.coach = 'Fernando Santos';

-- 7. List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'
SELECT goal.player
FROM goal
JOIN game ON (game.id=goal.matchid)
WHERE game.stadium = 'National Stadium, Warsaw';

-- 8. show the name of all players who scored a goal against Germany.
SELECT DISTINCT(player)
FROM game JOIN goal ON goal.matchid = game.id 
WHERE (game.team1='GER' OR game.team2='GER') AND goal.teamid <> 'GER';

-- 9. Show teamname and the total number of goals scored.
SELECT teamname, COUNT(gtime) AS Count
FROM eteam JOIN goal ON id=teamid
GROUP BY teamname;

-- 10. Show the stadium and the number of goals scored in each stadium.
SELECT game.stadium, COUNT(goal.gtime) AS Count
FROM game
JOIN goal ON game.id = goal.matchid
GROUP BY game.stadium;

-- 11. For every match involving 'POL', show the matchid, date and the number of goals scored.
SELECT goal.matchid, game.mdate, COUNT(goal.gtime) AS Count 
FROM game JOIN goal ON goal.matchid = game.id 
WHERE (game.team1 = 'POL' OR game.team2 = 'POL')
GROUP BY goal.matchid, game.mdate;

-- 12. For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'
SELECT goal.matchid, game.mdate, COUNT(goal.gtime) AS Count 
FROM game JOIN goal ON goal.matchid = game.id 
WHERE goal.teamid = 'GER'
GROUP BY goal.matchid, game.mdate;

-- 13. List every match with the goals scored by each team as shown.
SELECT mdate, 
    team1,
    SUM(CASE WHEN teamid=team1 THEN 1 ELSE 0 END) AS score1,
    team2,
    SUM(CASE WHEN teamid=team2 THEN 1 ELSE 0 END) AS score2
FROM game 
LEFT JOIN goal ON matchid = id
GROUP BY mdate, matchid, team1, team2
ORDER BY mdate, matchid, team1, team2;