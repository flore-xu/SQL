-- Sort and filter on HR database

--------------------------------------
-- table: employees
--------------------------------------

-- 1. find those employees whose salaries are less than 6000. Return full name (first and last name), and salary.

SELECT CONCAT(first_name , ' ' , last_name) AS full_name, salary
FROM employees
WHERE salary < 6000;

-- 2. find those employees whose salary is higher than 8000. Return first name, last name and department number and salary.

SELECT first_name, last_name, department_id, salary
FROM employees
WHERE salary > 8000;

-- 3. find those employees whose last name is "McEwen". Return first name, last name and department ID

SELECT first_name, last_name, department_id
FROM employees
WHERE last_name = 'McEwen';


-- 4. identify employees who do not have a department number. Return employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary,commission_pct, manager_id and department_id.

SELECT *
FROM employees
WHERE department_id IS NULL;

-- 5. find the details of 'Marketing' department. Return all fields.

SELECT *
FROM departments
WHERE department_name = 'Marketing';

-- 6. find those employees whose first name does not contain the letter ‘M’. 
-- Sort the result-set in ascending order by department ID. Return full name (first and last name together), hire_date, salary and department_id.

SELECT CONCAT(first_name , ' ' , last_name) AS full_name, hire_date, salary, department_id
FROM employees
WHERE first_name NOT LIKE '%M%'
ORDER BY department_id;

-- 7. find those employees who earn between 8000 and 12000 (Begin and end values are included.) and get some commission. 
-- These employees joined before ‘1987-06-05’ and were not included in the department numbers 40, 120 and 70. Return all fields

SELECT *
FROM employees
WHERE (salary BETWEEN 8000 AND 12000) 
    AND (commission_pct IS NOT NULL)
    AND (hire_date < '1987-06-05')
    AND department_id NOT IN (40 , 120 , 70);

-- 8. find those employees who do not earn any commission. Return full name (first and last name), and salary.

SELECT CONCAT(first_name , ' ' , last_name) AS full_name, salary
FROM employees
WHERE commission_pct IS NULL;


-- 9. find the employees whose salary is in the range 9000,17000 (Begin and end values are included). 
-- Return full name, contact details (e.g., '515.123.4568 - NKOCHHAR') and salary.

SELECT CONCAT(first_name , ' ' , last_name) AS full_name, 
        CONCAT(phone_number,  ' - ', email ) AS contact_details, 
        salary
FROM employees
WHERE salary BETWEEN 9000 AND 17000;


-- 10. find the employees whose first name ends with the letter ‘m’. Return the first and last name, and salary.

SELECT first_name, last_name, salary
FROM employees
WHERE first_name LIKE '%m';


-- 11. find those employees whose salaries are not between 7000 and 15000 (Begin and end values are included). 
-- Sort the result-set in ascending order by the full name (first and last). Return full name and salary.

SELECT CONCAT(first_name , ' ' , last_name) AS name, salary
FROM employees
WHERE NOT salary BETWEEN 7000 AND 15000
ORDER BY name ASC;


-- 12. find those employees who were hired between November 5th, 2007 and July 5th, 2009. Return full name (first and last), job id and hire date.


SELECT CONCAT(first_name , ' ' , last_name) AS full_name, job_id, hire_date   
FROM employees
WHERE hire_date BETWEEN '2007-11-05' AND '2009-07-05';


-- 13. find those employees who work either in department 70 or 90. Return full name (first and last name), department id.

SELECT CONCAT(first_name , ' ' , last_name) AS full_name, department_id 
FROM employees
WHERE department_id IN (70, 90);


-- 14. find those employees who work under a manager. Return full name (first and last name), salary, and manager ID.

SELECT CONCAT(first_name , ' ' , last_name) AS full_name, salary, manager_id
FROM employees
WHERE manager_id IS NOT NULL;


-- 15. find the employees who were hired before June 21st, 2002. Return all fields.

SELECT *
FROM employees
WHERE hire_date < '2002-06-21';


-- 16. find the employees whose managers hold the ID 120, 103, or 145. Return first name, last name, email, salary and manager ID.

SELECT first_name, last_name, email, 
salary, manager_id
FROM employees
WHERE manager_id IN (120 , 103 , 145);


-- 17. find employees whose first names contain the letters D, S, or N. 
-- Sort the result-set in descending order by salary. Return all fields.

SELECT *
FROM employees
WHERE first_name LIKE '%[DSN]%'
ORDER BY salary DESC;



-- 18. find those employees who earn above 11000 or the seventh character in their phone number is 3.
-- Sort the result-set in descending order by first name. 
-- Return full name (first name and last name), hire date, commission percentage, email, and telephone separated by '-', and salary.

SELECT CONCAT(first_name , ' ' , last_name) AS full_name, 
        hire_date, 
        CONCAT(phone_number,  ' - ', email ) AS contact_details, 
        salary 
FROM employees 
WHERE salary > 11000 OR phone_number LIKE '______3%'
ORDER BY first_name DESC;



-- 19. find those employees whose first name contains a character 's' in the third position. 
-- Return first name, last name and department id

SELECT first_name,last_name, department_id
FROM employees
WHERE first_name LIKE '__s%';


-- 20. find those employees work in the departments that are not part of the department 50 or 30 or 80. 
-- Return employee_id, first_name,job_id, department_id.

SELECT employee_id, first_name, job_id, department_id
FROM employees
WHERE department_id NOT IN (50, 30, 80);



-- 21. find the employees whose department numbers are included in 30, 40, or 90. 
-- Return employee id, first name, job id, department id.

SELECT employee_id, first_name, job_id, department_id
FROM employees
WHERE department_id IN (30, 40, 90);



-- 22. find those employees who worked more than two jobs in the past. 
-- Return employee id.

SELECT employee_id 
FROM job_history 
GROUP BY employee_id 
HAVING COUNT(*) >= 2;

-- 23. count the number of employees, the sum of all salary, and difference between the highest salary and lowest salaries by each job id. 
-- Return job_id, count, sum, salary_difference

SELECT job_id, COUNT(*) AS count, SUM(salary) AS sum, 
        MAX(salary)-MIN(salary) AS salary_difference 
FROM employees 
GROUP BY job_id;


-- 26. count the number of employees worked under each manager. 
-- Return manager ID and number of employees.

SELECT manager_id, COUNT(*) 
FROM employees 
GROUP BY manager_id;

-- 28. find all those employees who are either Sales Representatives or Salesmen. 
-- Return first name, last name and hire date.

SELECT first_name, last_name, hire_date
FROM employees 
WHERE job_id IN ('SA_REP', 'SA_MAN');


-- 29. calculate the average salary of employees who receive a commission percentage for each department. 
-- Return department id, average salary.

SELECT department_id, AVG(salary) 
FROM employees 
WHERE commission_pct IS NOT NULL 
GROUP BY department_id;

-- 30. find the departments where any manager manages four or more employees. 
-- Return department_id.

SELECT DISTINCT department_id
FROM employees
GROUP BY department_id, manager_id 
HAVING COUNT(employee_id) >=4;


-- 31. find the departments where more than ten employees receive commissions. 
-- Return department id.

SELECT department_id 
FROM employees 
GROUP BY department_id 
HAVING COUNT(commission_pct)>10;

-- 33. find those employees who do not have commission percentage and have salaries between 7000, 12000 (Begin and end values are included.) and who are employed in the department number 50. 
-- Return all the fields of employees.

SELECT * 
FROM employees 
WHERE commission_pct IS NULL 
    AND salary BETWEEN 7000 AND 12000 
    AND department_id=50;



-- 34. compute the average salary of each job ID. Exclude those records where average salary is higher than 8000. 
-- Return job ID, average salary.

SELECT job_id, AVG(salary) 
FROM employees 
GROUP BY job_id 
HAVING AVG(salary)>8000;



-- 36. find the employees whose first or last name begins with 'D'. 
-- Return first name, last name.

SELECT first_name, last_name 
FROM employees 
WHERE first_name  LIKE 'D%' OR last_name LIKE 'D%';


-- 38. find those employees who joined after 7th September 1987. 
-- Return all the fields.

SELECT * 
FROM employees  
WHERE hire_date > '1987-09-07';







------------------------------------------------
-- table: job_history

-- employee can only has one job ongoing. employee can have next job after finishing the previous one.
------------------------------------------------


-- 24. find each job ids where two or more employees worked for more than 300 days. 
-- Return job id.

SELECT job_id 
FROM job_history 
WHERE DATEDIFF(start_date, end_date) > 300 
GROUP BY job_id 
HAVING COUNT(*)>=2;

-- 32. find those employees who have completed their previous jobs. 
-- Return employee ID, and the latest end date for each employee with multiple job history entries.

SELECT employee_id , MAX(end_date)
FROM job_history
WHERE employee_id IN (SELECT employee_id
                        FROM job_history
                        GROUP BY employee_id
                        HAVING COUNT(employee_id) > 1)
GROUP BY employee_id;




------------------------------------------------
-- table: locations
------------------------------------------------

-- 25. count the number of cities in each country. 
-- Return country ID and number of cities.

SELECT country_id,  COUNT(*)  
FROM locations 
GROUP BY country_id;






------------------------------------------------
-- table: jobs 
------------------------------------------------


-- 27. find all jobs. Sort the result-set in descending order by job title. 
-- Return all fields.

SELECT * 
FROM jobs 
ORDER BY job_title DESC;

-- 35. find those job titles where maximum salary falls between 12000 and 18000 (Begin and end values are included.). 
-- Return job_title, max_salary-min_salary.

SELECT job_title, max_salary-min_salary AS salary_differences 
FROM jobs 
WHERE max_salary BETWEEN 12000 AND 18000;


-- 37. find details of those jobs where the minimum salary exceeds 9000. 
-- Return all the fields of jobs.

SELECT * 
FROM jobs 
WHERE min_salary > 9000;






