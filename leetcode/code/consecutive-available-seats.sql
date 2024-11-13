603. Consecutive Available Seats
WITH t1 AS(
    SELECT *, seat_id - row_number() OVER(ORDER BY seat_id) AS rk
    FROM Cinema
    WHERE free = 1
), t2 AS(
    SELECT rk  
    FROM t1
    GROUP BY rk
    HAVING count(rk) >= 2
)

SELECT seat_id
FROM t1 
WHERE rk IN (SELECT * FROM t2);