-- 596. Classes More Than 5 Students
SELECT class
FROM Courses
GROUP BY class 
HAVING COUNT(DISTINCT student) >= 5;