-- 1412. Find the Quiet Students in All Exams

WITH CTE AS(
    SELECT exam_id, student_id,
            RANK() OVER(PARTITION BY exam_id ORDER BY score ASC) AS low_rk,
            RANK() OVER(PARTITION BY exam_id ORDER BY score DESC) AS high_rk
    FROM Exam
), CTE2 AS(
    SELECT DISTINCT student_id
    FROM CTE 
        JOIN Student USING(student_id)
    WHERE high_rk = 1 OR low_rk = 1
)
SELECT DISTINCT student_id, student_name
FROM Exam 
    JOIN Student USING(student_id)
WHERE student_id NOT IN (SELECT * FROM CTE2)
ORDER BY student_id ASC





with t1 as(
    select *, 
        min(score) over(partition by exam_id ) as minscore, 
        max(score) over(partition by exam_id) as maxscore
    from Exam
), t2 as(
    select student_id 
    from t1  
    group by student_id 
    having sum(score=minscore)=0 and sum(score=maxscore)=0
)
select *
from Student
where student_id in (select * from t2)