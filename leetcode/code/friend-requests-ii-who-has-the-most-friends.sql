-- 602. Friend Requests II: Who Has the Most Friends
WITH CTE AS (
    SELECT requester_id AS id,
            COUNT(*) AS num
        FROM RequestAccepted
        GROUP BY requester_id
    UNION ALL
    SELECT accepter_id,
            COUNT(*) AS num
        FROM RequestAccepted
        GROUP BY accepter_id
)
SELECT id, SUM(num) AS num
FROM CTE 
GROUP BY id 
ORDER BY SUM(num) DESC
LIMIT 1;