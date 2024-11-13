-- 597. Friend Requests I: Overall Acceptance Rate
WITH CTE1 AS(
    SELECT COUNT(DISTINCT sender_id, send_to_id) AS ct 
    FROM 
    (SELECT sender_id, send_to_id
        FROM FriendRequest
    UNION
    SELECT requester_id, accepter_id
        FROM RequestAccepted
    ) T
), CTE2 AS(
    SELECT COUNT(DISTINCT requester_id, accepter_id) AS ct 
    FROM RequestAccepted
)
SELECT ROUND(IFNULL((SELECT ct FROM CTE2)/(SELECT ct FROM CTE1), 0), 2) AS accept_rate;