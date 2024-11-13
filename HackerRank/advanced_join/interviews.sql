-- each challenge has multiple submissions, so we need 2 CTEs to aggregate view and submissions first
WITH view_stats_summary AS (
    SELECT challenge_id,
            SUM(total_views) AS total_views,
            SUM(total_unique_views) AS total_unique_views
    FROM View_stats
    GROUP BY challenge_id
),
submission_stats_summary AS (
    SELECT challenge_id,
            SUM(total_submissions) AS total_submissions,
            SUM(total_accepted_submissions) AS total_accepted_submissions
    FROM Submission_stats
    GROUP BY challenge_id
)
SELECT con.contest_id,
        con.hacker_id,
        con.name,
        SUM(total_submissions),
        SUM(total_accepted_submissions),
        SUM(total_views),
        SUM(total_unique_views)
FROM Contests con
    JOIN Colleges col ON con.contest_id = col.contest_id
    JOIN Challenges cha ON col.college_id = cha.college_id
    LEFT JOIN View_stats_summary vs ON cha.challenge_id = vs.challenge_id
    LEFT JOIN Submission_stats_summary ss ON cha.challenge_id = ss.challenge_id
GROUP BY con.contest_id, con.hacker_id,con.name
HAVING SUM(total_submissions) > 0
        OR SUM(total_accepted_submissions) > 0
        OR SUM(total_views) > 0
        OR SUM(total_unique_views) > 0
ORDER BY con.contest_id;
