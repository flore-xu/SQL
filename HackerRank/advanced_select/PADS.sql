/*
 can't use ORDER BY inside UNION clause
to preserve row order in each derived table t1 and t2, use 2 additional columns sort_col1 (1 for first derived table, 2 for second derived table) and sort_col2 (row number)

*/

SELECT col1
FROM (
    SELECT *
    FROM (
        SELECT CONCAT(Name, '(', LEFT(Occupation, 1), ')') AS col1,
            1 AS sort_col1,
            ROW_NUMBER() OVER (ORDER BY Name) AS sort_col2
        FROM OCCUPATIONS
    ) t1
    UNION
    SELECT *
    FROM (
        SELECT CONCAT('There are a total of ', COUNT(*), ' ', LOWER(Occupation), 's.') AS col1,
            2 AS sort_col1,
            ROW_NUMBER() OVER (ORDER BY COUNT(*) ASC, Occupation ASC) AS sort_col2
        FROM OCCUPATIONS
        GROUP BY Occupation
    ) t2
ORDER BY sort_col1, sort_col2) t3;