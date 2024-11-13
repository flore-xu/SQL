-- 2308. Arrange Table by Gender
-- self-defined sort key
WITH CTE AS 
    (SELECT user_id, gender,
        CASE WHEN gender='female' THEN 1
             WHEN gender='other' THEN 2
             ELSE 3
        END AS sort_gender,
        ROW_NUMBER() OVER (PARTITION BY gender ORDER BY user_id ASC) as rk
    FROM Genders
)

SELECT user_id, gender 
FROM cte
ORDER BY rk ASC, sort_gender ASC;