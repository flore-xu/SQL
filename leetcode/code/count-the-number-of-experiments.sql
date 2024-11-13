
-- 1990. Count the Number of Experiments
-- solution1: list to column by VALUES ROW
WITH CTE1(platform) AS (
    VALUES ROW('Android'), ROW('IOS'), ROW('Web')
    ),
    CTE2(experiment_name) AS (
    VALUES ROW('Reading'), ROW('Sports'), ROW('Programming')
    )
SELECT p.platform, e.experiment_name, COUNT(e2.experiment_id) AS num_experiments
FROM CTE1 p
    CROSS JOIN CTE2 e 
    LEFT JOIN Experiments e2 ON e2.platform=p.platform AND e2.experiment_name=e.experiment_name
GROUP BY p.platform, e.experiment_name;




-- solution2: list to column by UNION
WITH platform_cte AS (
    SELECT 'Android' AS platform
    UNION 
    SELECT 'IOS'
    UNION 
    SELECT 'Web'
), exp_cte AS (
    SELECT 'Reading' AS experiment_name
    UNION 
    SELECT 'Sports'
    UNION 
    SELECT 'Programming'
)
SELECT p.platform, e.experiment_name, COUNT(e2.experiment_id) AS num_experiments
FROM platform_cte p
    CROSS JOIN exp_cte e 
    LEFT JOIN Experiments e2 ON e2.platform=p.platform AND e2.experiment_name=e.experiment_name
GROUP BY p.platform, e.experiment_name;