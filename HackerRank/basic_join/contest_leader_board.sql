-- solution1: CTE + MAX() + GROUP BY
WITH MAX_SCORE AS (
    SELECT s.hacker_id, h.name, MAX(s.score) AS score
    FROM Submissions s
    JOIN Hackers h ON s.hacker_id = h.hacker_id
    GROUP BY s.challenge_id, s.hacker_id, h.name
    HAVING MAX(s.score) > 0
)
SELECT hacker_id, name,SUM(score) AS total_score
FROM MAX_SCORE
GROUP BY hacker_id, name
ORDER BY total_score DESC,hacker_id ASC;


-- solution2: CTE + DISTINCT MAX() OVER (PARTITION BY)
WITH MAX_SCORE as (
    SELECT DISTINCT h.hacker_id, h.name, s.challenge_id,
        MAX(s.score) OVER (PARTITION BY s.challenge_id, s.hacker_id) AS score
    FROM Hackers h
        JOIN Submissions s ON s.hacker_id = h.hacker_id
)
SELECT hacker_id, name, SUM(score) AS total_score
FROM MAX_SCORE
GROUP BY hacker_id, name
HAVING SUM(score) > 0
ORDER BY total_score DESC, hacker_id ASC;



