-- use row number to make sure 2 same rows are not considered as a symmetric pair
WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER (ORDER BY X) AS RowNum
    FROM Functions
)
SELECT DISTINCT F1.X, F1.Y
FROM CTE F1
    JOIN CTE F2 ON F1.X = F2.Y AND F1.Y = F2.X AND F1.RowNum <> F2.RowNum
WHERE F1.X <= F1.Y
ORDER BY F1.X ASC;