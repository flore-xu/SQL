-- 1355. Activity Participants
WITH CTE AS(
    SELECT a.name, COUNT(f.id) AS ct 
    FROM Activities a 
        LEFT JOIN Friends f ON f.activity=a.name
    GROUP BY a.name 
)
SELECT name AS activity
FROM CTE 
WHERE ct NOT IN ((SELECT MIN(ct) FROM CTE), (SELECT MAX(ct) FROM CTE));