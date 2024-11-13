-- MySQL 
SELECT 
    submission_date,
    (
        SELECT COUNT(DISTINCT hacker_id) 
        FROM Submissions s2 
        WHERE s2.submission_date = s1.submission_date AND 
            (
                SELECT COUNT(DISTINCT s3.submission_date) 
                FROM Submissions s3 
                WHERE s3.hacker_id = s2.hacker_id AND s3.submission_date < s1.submission_date
            ) = DATEDIFF(s1.submission_date, '2016-03-01')
    ),
    (
        SELECT hacker_id 
        FROM submissions s2 
        WHERE s2.submission_date = s1.submission_date 
        GROUP BY hacker_id 
        ORDER BY COUNT(submission_id) DESC, hacker_id 
        LIMIT 1
    ) AS s4,
    (
        SELECT name 
        FROM hackers 
        WHERE hacker_id = s4 
    )
FROM (
    SELECT DISTINCT submission_date 
    FROM submissions
) s1;

-- MS SQL
With SubmissionsCte (Submission_Date, Hacker_Id, DC)
As
(
    select Submission_Date, Hacker_Id, DC = 1 from Submissions where Submission_Date = (Select Min(Submission_Date) from Submissions)
    union all 
    select S1.Submission_Date, S1.Hacker_Id, DC = 1 from Submissions S1 inner join SubmissionsCte sc on s1.hacker_Id = sc.Hacker_Id 
    and S1.Submission_Date = DateAdd(D,1,Sc.Submission_Date)
)

Select X.Submission_Date, Y.UHackerCount, x.Hacker_Id, H.Name 
from Hackers H
inner join (
            select    Min(T2.Hacker_Id) as Hacker_Id
                ,    T2.Submission_Date
                ,    T2.DC
            from (select s.Submission_Date, s.Hacker_Id, DC = Count(s.Submission_Id) from Submissions s group by s.Submission_Date, s.Hacker_Id) T2
            inner join (    
                            select T1.Submission_Date, Max(T1.Dc) as DC from (select s.Submission_Date, s.Hacker_Id, DC = Count(s.Submission_Id) from Submissions s group by s.Submission_Date, s.Hacker_Id) T1
                            group by T1.Submission_Date
                        ) T3
            on T2.Submission_Date = T3.Submission_Date and T2.DC = T3.DC
            group by T2.Submission_Date, T2.DC
         ) X  on H.Hacker_Id = X.Hacker_Id
inner join (
             select Submission_Date, Count(Distinct Hacker_Id) as UHackerCount
             from SubmissionsCte 
             group by Submission_Date
           ) Y on X.Submission_Date = Y.Submission_Date
order by 1;


-- not solved
WITH submission_dates AS (
    SELECT DISTINCT submission_date 
    FROM submissions
),
daily_hackers AS (
    SELECT 
        s1.submission_date,
        COUNT(DISTINCT s2.hacker_id) AS Total_hackers
    FROM submission_dates s1
		JOIN Submissions s2 ON s2.submission_date = s1.submission_date
    -- filters the rows to only include hackers who have made at least one submission every day from the start of the contest until the current submission date
    WHERE DATEDIFF(s1.submission_date , (SELECT MIN(submission_date) FROM Submissions)) = (
                            SELECT COUNT(DISTINCT s3.submission_date) 
                            FROM Submissions s3 
                            WHERE s3.hacker_id = s2.hacker_id AND s3.submission_date < s1.submission_date)
    GROUP BY s1.submission_date
),
daily_submissions AS (
    SELECT 
        submission_date,
        hacker_id,
        COUNT(submission_id) AS submission_count
    FROM submissions
    GROUP BY submission_date, hacker_id
),
ranked_hackers AS (
    SELECT 
        submission_date,
        hacker_id,
        ROW_NUMBER() OVER (PARTITION BY submission_date ORDER BY submission_count DESC, hacker_id) AS rn
    FROM daily_submissions
),
top_hackers AS (
	SELECT submission_date, hacker_id
    FROM ranked_hackers
    WHERE rn = 1
)

SELECT 
    s.submission_date,
    d.Total_hackers,
    t.hacker_id,
    h.name
FROM submission_dates s
	JOIN daily_hackers d ON s.submission_date = d.submission_date
	JOIN top_hackers t ON t.submission_date = s.submission_date
	JOIN hackers h ON h.hacker_id = t.hacker_id
ORDER BY s.submission_date;








-- create submissions table and hackers table
CREATE DATABASE HackerRank;
USE HackerRank;
CREATE TABLE submissions (submission_date date, submission_id integer, hacker_id integer, score integer);
CREATE TABLE hackers (hacker_id integer, name VARCHAR(255));

-- insert example rows
INSERT INTO submissions VALUES('2016-03-01',8494,20703,0);
INSERT INTO submissions VALUES('2016-03-01',22403,53473,15);
INSERT INTO submissions VALUES('2016-03-01',23965,79722,60);
INSERT INTO submissions VALUES('2016-03-01',30173,36396,70);
INSERT INTO submissions VALUES('2016-03-02',34928,20703,0);
INSERT INTO submissions VALUES('2016-03-02',38740,15758,60);
INSERT INTO submissions VALUES('2016-03-02',42769,79722,60);
INSERT INTO submissions VALUES('2016-03-02',44364,79722,60);
INSERT INTO submissions VALUES('2016-03-03',45440,20703,0);
INSERT INTO submissions VALUES('2016-03-03',49050,36396,70);
INSERT INTO submissions VALUES('2016-03-03',50273,79722,5);
INSERT INTO submissions VALUES('2016-03-04',50344,20703,0);
INSERT INTO submissions VALUES('2016-03-04',51360,44065,90);
INSERT INTO submissions VALUES('2016-03-04',54404,53473,65);
INSERT INTO submissions VALUES('2016-03-04',61533,79722,45);
INSERT INTO submissions VALUES('2016-03-05',72852,20703,0);
INSERT INTO submissions VALUES('2016-03-05',74546,38289,0);
INSERT INTO submissions VALUES('2016-03-05',76487,62529,0);
INSERT INTO submissions VALUES('2016-03-05',82439,36396,10);
INSERT INTO submissions VALUES('2016-03-05',90006,36396,40);
INSERT INTO submissions VALUES('2016-03-06',90404,20703,0);

INSERT INTO hackers VALUES(15758,'Rose');
INSERT INTO hackers VALUES(20703,'Angela');
INSERT INTO hackers VALUES(36396,'Frank');
INSERT INTO hackers VALUES(38289,'Patrick');
INSERT INTO hackers VALUES(44065,'Lisa');
INSERT INTO hackers VALUES(53473,'Kimberly');
INSERT INTO hackers VALUES(62529,'Bonnie');
INSERT INTO hackers VALUES(79722,'Michael');