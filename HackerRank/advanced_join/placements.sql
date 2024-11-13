-- the official solution needs to join Students table again, I think is unnesesary
SELECT s.Name
FROM Students s
    JOIN Packages p1 ON s.ID = p1.ID
    JOIN Friends f ON s.ID = f.Friend_ID
    JOIN Packages p2 ON p2.ID = f.ID
WHERE p1.Salary < p2.Salary
ORDER BY p2.Salary ASC;