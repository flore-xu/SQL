-- 2118. Build the Equation
WITH CTE AS (
    SELECT power, 
            IF(factor>0, CONCAT('+', factor), factor) AS factor_term, 
            CASE WHEN power = 0 THEN ''
                WHEN power = 1 THEN 'X'
                ELSE CONCAT('X^', power)
            END AS power_term
    FROM terms
)

SELECT CONCAT(GROUP_CONCAT(CONCAT(factor_term, power_term) ORDER BY power DESC SEPARATOR ''), '=0') AS equation
FROM CTE;