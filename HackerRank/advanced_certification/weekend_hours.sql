WITH tmp AS(
    SELECT emp_id, 
		timestamp AS start_date, 
		LEAD(timestamp, 1) OVER(PARTITION BY emp_id ORDER BY timestamp ASC) AS end_date
    FROM attendance
    WHERE weekday(timestamp) IN (5, 6)
    )
SELECT emp_id, SUM(TIMESTAMPDIFF(HOUR, start_date, end_date)) AS work_hours
FROM tmp
WHERE weekday(start_date) = weekday(end_date)
GROUP BY emp_id
ORDER BY work_hours;