-- 1369. Get the Second Most Recent Activity
WITH CTE AS(
    SELECT *,
            ROW_NUMBER() OVER(PARTITION BY username ORDER BY startDate DESC) AS rk, 
            COUNT(1) OVER(PARTITION BY username) AS ct
    FROM UserActivity
)
SELECT username, activity, startDate, endDate 
FROM CTE 
WHERE ct=1 OR rk=2;