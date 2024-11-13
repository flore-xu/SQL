-- 2199. Finding the Topic of Each Post
WITH CTE AS(
    SELECT DISTINCT post_id, topic_id
    FROM posts p 
        LEFT JOIN keywords 
            ON CONCAT(' ', content, ' ') LIKE CONCAT('% ', word, ' %')
            -- INSTR(CONCAT(' ', content, ' '), CONCAT(' ', word, ' ')) <> 0
            -- POSITION(CONCAT(' ', word, ' ') IN CONCAT(' ', content, ' ')) <> 0
)
SELECT post_id,
       IFNULL(GROUP_CONCAT(topic_id ORDER BY topic_id), 'Ambiguous!') AS topic
FROM CTE 
GROUP BY post_id; 