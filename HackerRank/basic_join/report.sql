-- condition of JOIN ... ON ... can be BETWEEN ... AND ...
SELECT 
    CASE WHEN g.grade >=8 THEN NAME END AS name,
    g.grade,
    s.marks
FROM students s
    JOIN grades g ON s.marks BETWEEN g.min_mark AND g.max_mark
ORDER BY grade DESC, name, marks;