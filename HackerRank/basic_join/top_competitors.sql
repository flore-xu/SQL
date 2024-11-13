SELECT h.hacker_id, h.name
FROM Hackers h
    JOIN Submissions s ON h.hacker_id = s.hacker_id
    JOIN Challenges c ON c.challenge_id = s.challenge_id
    JOIN Difficulty d ON d.difficulty_level = c.difficulty_level AND s.score = d.score
GROUP BY s.hacker_id, h.name
HAVING COUNT(c.challenge_id) > 1
ORDER BY COUNT(c.challenge_id) DESC, h.hacker_id ASC;