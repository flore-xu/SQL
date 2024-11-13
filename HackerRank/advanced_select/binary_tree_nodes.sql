
SELECT N, 
        CASE WHEN P IS NULL THEN 'Root'
             WHEN N IN (SELECT DISTINCT P FROM BST) AND P IS NOT NULL THEN 'Inner' 
             ELSE 'Leaf'
        END AS type  
FROM BST
ORDER BY N ASC;