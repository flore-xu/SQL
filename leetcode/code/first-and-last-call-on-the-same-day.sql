-- 1972. First and Last Call On the Same Day
WITH CTE1 AS (
    SELECT caller_id AS user1_id, recipient_id AS user2_id, call_time
        FROM Calls 
    UNION ALL 
    SELECT recipient_id AS user1_id, caller_id AS user2_id, call_time
        FROM Calls
), CTE2 AS(
    SELECT user1_id, 
            DATE_FORMAT(call_time, '%Y-%m-%d') AS dt, 
            user2_id, 
            ROW_NUMBER() OVER(PARTITION BY user1_id, DATE_FORMAT(call_time, '%Y-%m-%d') ORDER BY call_time ASC) AS first_rk,
            ROW_NUMBER() OVER(PARTITION BY user1_id, DATE_FORMAT(call_time, '%Y-%m-%d') ORDER BY call_time DESC) AS last_rk
    FROM CTE1 
)
SELECT DISTINCT user1_id AS user_id 
FROM CTE2
WHERE first_rk=1 OR last_rk=1
GROUP BY user1_id, dt
HAVING COUNT(DISTINCT user2_id)=1
ORDER BY 1;