-- 1767. Find the Subtasks That Did Not Execute

-- 3 solutions to create recursive CTE with all subtasks

-- solution1: ascending order
WITH RECURSIVE cte(task_id, subtask_id, subtasks_count) AS (
    SELECT task_id, 1 AS subtask_id, subtasks_count 
        FROM Tasks
    UNION ALL
    SELECT task_id, subtask_id + 1, subtasks_count 
        FROM cte 
        WHERE subtask_id < subtasks_count
)
SELECT cte.task_id, cte.subtask_id 
FROM cte 
    LEFT JOIN Executed USING(task_id, subtask_id)
WHERE Executed.subtask_id IS NULL
ORDER BY 1, 2;

-- solution2: ascending order and JOIN

WITH RECURSIVE cte(task_id, subtask_id) AS (
    SELECT task_id, 1 AS subtask_id 
        FROM tasks
    UNION ALL
    SELECT cte.task_id, cte.subtask_id + 1 
        FROM cte 
        JOIN tasks ON cte.task_id = tasks.task_id 
        WHERE cte.subtask_id < tasks.subtasks_count
)

-- solution3: descending order
with recursive cte(task_id, subtask_id) as (
    select task_id, subtasks_count AS subtask_id 
        from Tasks
    union all
    select task_id, subtask_id-1 
        from table1 
        where subtask_id > 1
)




