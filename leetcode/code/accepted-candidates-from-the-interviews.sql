-- 2041. Accepted Candidates From the Interviews
SELECT c.candidate_id
FROM Candidates c
    JOIN Rounds r USING(interview_id)
WHERE c.years_of_exp >= 2
GROUP BY candidate_id
HAVING SUM(r.score) > 15