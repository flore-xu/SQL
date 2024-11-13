-- 626. Exchange Seats
SELECT id, 
    CASE WHEN id % 2 = 1 AND id <> (SELECT COUNT(*) FROM Seat) THEN LEAD(student, 1) OVER(ORDER BY id)
        WHEN id % 2 = 0 THEN LAG(student, 1) OVER(ORDER BY id)
    ELSE student   
    END AS student
FROM Seat;