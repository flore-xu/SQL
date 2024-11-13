-- CTE and ROW_NUMBER()
WITH wand_rank AS(
    SELECT w.id, wp.age, w.coins_needed, w.power,
        ROW_NUMBER() OVER(PARTITION BY wp.age, w.power ORDER BY w.coins_needed) AS rk
    FROM wands as w 
        JOIN wands_property as wp on w.code=wp.code
    where wp.is_evil=0)
SELECT id, age, coins_needed, power
FROM wand_rank
WHERE rk=1
ORDER BY power DESC, age DESC;