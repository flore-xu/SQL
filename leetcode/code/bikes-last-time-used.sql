-- 2687. Bikes Last Time Used 
WITH CTE AS(
    SELECT bike_number, end_time,
            RANK() OVER (PARTITION BY bike_number ORDER BY end_time DESC) AS rk
    FROM Bikes 
)
SELECT bike_number, end_time
FROM CTE 
WHERE rk=1
ORDER BY end_time DESC;