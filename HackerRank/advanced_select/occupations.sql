WITH NameLists AS (
    SELECT
        Occupation,
        Name,
        ROW_NUMBER() OVER(PARTITION BY Occupation ORDER BY Name ASC) AS NameOrder
    FROM Occupations
)
SELECT
        -- both MIN() and MAX() works here to find non-NULL value in each NameOrder group
        MIN(CASE Occupation WHEN 'Doctor' THEN Name END) AS Doctor,
        MAX(CASE Occupation WHEN 'Professor' THEN Name END) AS Professor,
        MAX(CASE Occupation WHEN 'Singer' THEN Name END) AS Singer,
        MAX(CASE Occupation WHEN 'Actor' THEN Name END) AS Actor
FROM NameLists
GROUP BY NameOrder;