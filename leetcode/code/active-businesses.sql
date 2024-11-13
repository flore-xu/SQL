1126. Active Businesses
WITH CTE AS (
    SELECT business_id, occurences, 
            AVG(occurences) over(partition by event_type) AS avg_activity
    FROM Events
)
SELECT business_id
FROM CTE 
WHERE occurences > avg_activity
GROUP BY business_id
HAVING COUNT(*) >= 2;