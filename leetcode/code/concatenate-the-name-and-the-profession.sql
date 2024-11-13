-- 2504. Concatenate the Name and the Profession
SELECT person_id, CONCAT(name, '(', LEFT(profession, 1), ')') AS name 
FROM Person 
ORDER BY person_id DESC;