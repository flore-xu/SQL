/*
start date of a project won't be any end date of a task of same project
end date of a project won't be any start date of a task of same project
use these 2 properties to find start date and possible end date of a project

*/
WITH Start_Dates AS (
    SELECT Start_Date
    FROM Projects
    WHERE Start_Date NOT IN (SELECT End_Date FROM Projects)
),
    End_Dates AS (
        SELECT End_Date
        FROM Projects
        WHERE End_Date NOT IN (SELECT Start_Date FROM Projects)
    )
SELECT s.Start_Date AS project_start_date, 
        MIN(e.End_Date) AS project_end_date,
        DATEDIFF(MIN(e.End_Date), s.Start_Date) AS complete_days
FROM Start_Dates s, End_Dates e  -- cross join start dates and end dates
WHERE s.Start_Date < e.End_Date
GROUP BY s.Start_Date
ORDER BY complete_days ASC, s.Start_Date ASC;
