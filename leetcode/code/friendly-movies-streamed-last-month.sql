-- 1495. Friendly Movies Streamed Last Month
SELECT DISTINCT c.title
FROM TVProgram t 
    JOIN Content c ON t.content_id=c.content_id 
WHERE DATE_FORMAT(t.program_date, '%Y-%m')='2020-06' AND c.Kids_content='Y' AND c.content_type='Movies';