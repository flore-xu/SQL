-- 1555. Bank Account Summary
WITH CTE AS(
    SELECT paid_by AS user_id, -amount AS amount 
        FROM Transactions
    UNION ALL
    SELECT paid_to AS user_id, amount AS amount 
        FROM Transactions
), CTE2 AS (
    SELECT u.user_id, u.user_name, 
        IFNULL(u.credit + SUM(c.amount), u.credit) AS credit
        
    FROM Users u   
        LEFT JOIN CTE c ON u.user_id=c.user_id
    GROUP BY u.user_id
)
SELECT *, IF(credit<0, 'Yes', 'No') AS credit_limit_breached
FROM CTE2
;