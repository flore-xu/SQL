-- 1148. Article Views I
SELECT author_id AS id 
FROM Views
WHERE author_id = viewer_id
GROUP BY author_id
HAVING COUNT(*) >= 1
ORDER BY id ASC;