-- 2669. Count Artist Occurrences On Spotify Ranking List
SELECT artist, COUNT(*) AS occurrences
FROM Spotify
GROUP BY artist 
ORDER BY occurrences DESC, artist ASC;