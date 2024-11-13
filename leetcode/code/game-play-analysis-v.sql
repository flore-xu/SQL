-- 1097. Game Play Analysis V
WITH CTE AS(
    SELECT player_id, event_date,
            DATEDIFF(LEAD(event_date, 1) OVER(PARTITION BY player_id ORDER BY event_date ASC), event_date) AS diff,
            ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY event_date ASC) AS rk 
    FROM Activity
)
SELECT event_date AS install_dt,
        COUNT(*) AS installs,
        ROUND(IFNULL(SUM(diff=1), 0)/COUNT(*), 2) AS Day1_retention

FROM CTE
WHERE rk=1
GROUP BY event_date
ORDER BY install_dt ASC;