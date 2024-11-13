-- 2346. Compute the Rank as a Percentage
SELECT student_id, department_id,
        ROUND(IFNULL((RANK() OVER(PARTITION BY department_id ORDER BY mark DESC)-1)/(COUNT(student_id) OVER(PARTITION BY department_id)-1)*100, 0), 2) AS percentage
FROM Students;