-- 1435. Create a Session Bar Chart
SELECT '[0-5>' AS bin, count(*) AS total 
    FROM Sessions 
    WHERE duration/60>=0 AND duration/60<5
UNION
SELECT '[5-10>' AS bin, count(*) AS total 
    FROM Sessions 
    WHERE duration/60>=5 AND duration/60<10
UNION
SELECT '[10-15>' AS bin, count(*) AS total 
    FROM Sessions 
    WHERE duration/60>=10 AND duration/60<15
UNION
SELECT '15 or more' AS bin, count(*) AS total 
    FROM Sessions 
    WHERE duration/60>=15;