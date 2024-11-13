-- 1661. Average Time of Process per Machine
WITH CTE AS(
    SELECT machine_id, process_id,
            LEAD(timestamp, 1) OVER(PARTITION BY machine_id, process_id ORDER BY activity_type='end') - timestamp AS process_time
    FROM Activity
)
SELECT machine_id, ROUND(AVG(process_time), 3) AS processing_time
FROM CTE
WHERE process_time IS NOT NULL
GROUP BY machine_id;