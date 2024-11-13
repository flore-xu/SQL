-- 1988. Find Cutoff Score for Each School
SELECT s.school_id, IFNULL(MIN(e.score), -1) AS score 
FROM Schools s 
    LEFT JOIN Exam e ON s.capacity >= e.student_count 
GROUP BY s.school_id;