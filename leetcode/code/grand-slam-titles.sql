-- 1783. Grand Slam Titles
WITH CTE AS(
    SELECT Wimbledon AS player_id
        FROM Championships
    UNION ALL 
    SELECT Fr_open AS player_id
        FROM Championships
    UNION ALL 
    SELECT US_open AS player_id
        FROM Championships
    UNION ALL
    SELECT Au_open AS player_id
        FROM Championships  
)
SELECT c.player_id, p.player_name, COUNT(*) AS grand_slams_count
FROM CTE c
    JOIN Players p ON p.player_id=c.player_id
GROUP BY c.player_id;