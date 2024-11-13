-- in addition to join ON Company_Code, also needs to join on Lead_manager_Code, Lead_Manager_Code, Manager_Code
SELECT c.Company_Code, c.Founder, 
        Count(DISTINCT L.Lead_Manager_Code) AS total_lead managers, 
        Count(DISTINCT S.Senior_Manager_Code) AS total_senior, 
        Count(DISTINCT M.Manager_Code) AS total_managers, 
        Count(DISTINCT E.Employee_Code) AS total_employees
FROM company c 
    JOIN Lead_Manager L ON c.Company_Code = L.Company_Code
    JOIN Senior_Manager S ON C.Company_Code = S.Company_Code 
        AND S.Lead_manager_code = L.Lead_manager_Code
    JOIN Manager M ON C.Company_Code = M.Company_Code 
        AND M.Lead_Manager_Code = L.Lead_Manager_Code
        AND M.Senior_Manager_Code = S.Senior_Manager_Code
    JOIN EMployee E ON C.Company_Code = E.Company_Code 
        AND E.Lead_Manager_Code = M.Lead_Manager_Code 
        AND E.Senior_Manager_Code = M.Senior_Manager_Code 
        AND E.Manager_Code = M.Manager_Code
GROUP BY c.Company_Code, c.Founder
ORDER BY c.Company_Code ASC;