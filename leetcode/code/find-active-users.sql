-- 2688. Find Active Users

-- solution 1: COUNT() OVER()
WITH CTE AS (
    SELECT user_id, created_at,
            COUNT(created_at) OVER(PARTITION BY user_id ORDER BY created_at ASC RANGE BETWEEN CURRENT ROW AND INTERVAL 7 DAY FOLLOWING) AS ct
    FROM Users
)
SELECT DISTINCT user_id
FROM CTE 
WHERE ct>=2;


-- solution 2: LEAD()
WITH CTE AS (
    select user_id, created_at,
        lead(created_at) over(partition by user_id order by created_at) next_date
    from users
)
SELECT DISTINCT user_id
FROM CTE 
where datediff(next_date, created_at) <= 7