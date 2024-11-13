/*
 Outer join (LEFT JOIN, RIGHT JOIN) tutorial from https://sqlzoo.net/wiki/Using_Null

teacher data description

teacher
-------------------------
id: unique teacher id, e.g., 101	
dept: department id, can be NULL	
name: teacher name	
phone: 4-digit phone number	
mobile: 14-digit mobile phone number, e.g., '07986 555 1234'

dept
-------------------------
id: department id	
name: department name, e.g., 'Computing'

*/
-- 1. List the teachers who have NULL for their department.
SELECT name
FROM teacher
WHERE dept IS NULL;

-- 2. Note the INNER JOIN misses the teachers with no department and the departments with no teacher.
SELECT teacher.name, dept.name
FROM teacher 
INNER JOIN dept ON (teacher.dept=dept.id);

-- 3. Use a different JOIN so that all teachers are listed.
SELECT teacher.name, dept.name
FROM teacher 
LEFT JOIN dept ON (teacher.dept=dept.id);

-- 4. Show teacher name and mobile number or '07986 444 2266'
SELECT name, 
        COALESCE(mobile, '07986 444 2266') AS mobile_number
FROM teacher;

-- 5. print the teacher name and department name. 
-- Use the string 'None' where there is no department.
SELECT teacher.name, 
        COALESCE(dept.name, 'None') AS deparment
FROM teacher 
LEFT JOIN dept ON (teacher.dept=dept.id)

-- 6. show the number of teachers and the number of mobile phones.
SELECT COUNT(name) AS Count_teacher, 
        COUNT(mobile) AS Count_mobile
FROM teacher

-- 7. show each department and the number of staff. 
SELECT dept.name, 
        COUNT(teacher.name) AS staff_number
FROM teacher
RIGHT JOIN dept ON teacher.dept=dept.id
GROUP BY dept.name

-- 8. show the name of each teacher followed by 'Sci' if the teacher is in dept 1 or 2 and 'Art' otherwise.
SELECT name, 
        (CASE WHEN (dept=1 OR dept=2) THEN 'Sci' ELSE 'Art' END) AS dept
FROM teacher

-- 9. show the name of each teacher followed by 'Sci' if the teacher is in dept 1 or 2, show 'Art' if the teacher's dept is 3 and 'None' otherwise.
SELECT name, 
        (CASE WHEN (dept=1 OR dept=2) THEN 'Sci' 
              WHEN dept=3             THEN 'Art' 
         ELSE 'None' END) AS dept
FROM teacher;