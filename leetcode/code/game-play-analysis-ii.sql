-- 512. Game Play Analysis II
WITH CTE AS(
    SELECT *,
            ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY event_date ASC) AS rk 
    FROM Activity
)
SELECT player_id, device_id
FROM CTE 
WHERE rk=1;