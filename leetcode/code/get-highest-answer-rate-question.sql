-- 578. Get Highest Answer Rate Question
WITH CTE AS(
    SELECT question_id,
            IFNULL(SUM(action='answer')/SUM(action='show'), 0) AS answer_rate
    FROM SurveyLog 
    GROUP BY question_id
)
SELECT question_id AS survey_log
FROM CTE 
ORDER BY answer_rate DESC, question_id ASC 
LIMIT 1;