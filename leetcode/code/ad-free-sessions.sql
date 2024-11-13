-- 1809. Ad-Free Sessions
WITH CTE AS (
    SELECT p.session_id
    FROM Playback p 
        JOIN Ads a ON p.customer_id=a.customer_id AND a.timestamp BETWEEN p.start_time AND p.end_time)
SELECT session_id
FROM Playback
WHERE session_id NOT IN (SELECT session_id FROM CTE);