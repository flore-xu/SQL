-- 550. Game Play Analysis IV
WITH CTE AS (
    SELECT player_id, event_date,
        MIN(event_date) AS first_login
    FROM activity
    GROUP BY player_id)
SELECT ROUND(AVG(a.event_date IS NOT NULL), 2) AS fraction
FROM CTE  
    LEFT JOIN activity a ON CTE.player_id=a.player_id AND DATEDIFF(a.event_date, CTE.first_login)=1;