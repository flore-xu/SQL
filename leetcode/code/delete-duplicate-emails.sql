-- 196. Delete Duplicate Emails

-- solution1: ROW_NUMBER() and CTE
DELETE FROM Person
WHERE id IN(   
    WITH CTE AS (
        SELECT id, 
               ROW_NUMBER() OVER(PARTITION BY email ORDER BY id) AS rk 
        FROM Person)
    SELECT id 
    FROM CTE 
    WHERE rk > 1
);

-- solution2: self join
DELETE p1 FROM Person p1
JOIN Person p2
ON p1.email = p2.email AND p1.id > p2.id;


