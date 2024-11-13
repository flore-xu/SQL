-- 1811. Find Interview Candidates
WITH CTE1 AS(
    SELECT contest_id, gold_medal AS user_id
        FROM Contests
    UNION ALL 
    SELECT contest_id, silver_medal AS user_id
        FROM Contests
    UNION ALL 
    SELECT contest_id, bronze_medal AS user_id
        FROM Contests
), CTE2 AS(
    SELECT user_id, 
        contest_id-ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY contest_id ASC) AS diff
    FROM CTE1
), CTE3 AS(
    SELECT gold_medal AS user_id 
    FROM Contests
    GROUP BY gold_medal
    HAVING COUNT(*) >=3
)
SELECT name, mail
FROM Users
WHERE user_id IN (SELECT user_id
                    FROM CTE2
                    GROUP BY user_id, diff
                    HAVING COUNT(*)>=3)
    OR user_id IN (SELECT user_id
                    FROM CTE3);