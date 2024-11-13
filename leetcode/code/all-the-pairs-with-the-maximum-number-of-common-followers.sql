-- 1951. All the Pairs With the Maximum Number of Common Followers
WITH CTE AS(
    SELECT r1.user_id AS user1_id, r2.user_id AS user2_id, 
            RANK() OVER(ORDER BY COUNT(*) DESC) AS rk
    FROM Relations r1 
        JOIN Relations r2 ON r1.follower_id=r2.follower_id AND r1.user_id<r2.user_id 
    GROUP BY r1.user_id, r2.user_id
)
SELECT user1_id, user2_id
FROM CTE 
WHERE rk=1;