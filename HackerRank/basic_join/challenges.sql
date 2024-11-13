/*
sql_mode=only_full_group_by
when use GROUP BY clause, columns in SELECT, ORDER BY, HAVING clause must either occur in GROUP BY or serve as argument of aggregate function
*/

WITH StudentChallenges AS (
    SELECT
        c.hacker_id AS hacker_id,
        h.name AS name,
        COUNT(*) AS challenge_count,
        DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS challenge_rank
    FROM Challenges c
    JOIN Hackers h ON c.hacker_id = h.hacker_id
    GROUP BY c.hacker_id, h.name
),
ChallengeRankFilter AS (
    SELECT challenge_rank
    FROM StudentChallenges
    GROUP BY challenge_rank
    HAVING (COUNT(*) >= 1 AND challenge_rank = 1)
        OR (COUNT(*) = 1 AND challenge_rank > 1)
)
SELECT hacker_id, name, challenge_count
FROM StudentChallenges s 
JOIN ChallengeRankFilter c ON s.challenge_rank = c.challenge_rank
ORDER BY challenge_count DESC, hacker_id ASC;
