-- 511. Game Play Analysis I
WITH CTE AS (
    SELECT player_id, event_date,
            ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY event_date ASC) AS rk
    FROM Activity
)
SELECT player_id, event_date AS first_login
FROM CTE 
WHERE rk=1;