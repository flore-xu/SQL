/* Numeric tutorial from https://sqlzoo.net/wiki/NSS_Tutorial

National Student Survey 2012

The National Student Survey http://www.thestudentsurvey.com/ is presented to thousands of graduating students in UK Higher Education. 
columns: institution, subject and question, STRONGLY DISAGREE, DISAGREE, NEUTRAL, AGREE or STRONGLY AGREE, etc.

The survey asks 22 questions, students can respond with 5 options STRONGLY DISAGREE, DISAGREE, NEUTRAL, AGREE or STRONGLY AGREE. 
The values in these columns represent PERCENTAGES of the total students who responded with that answer.

*/
-- 1	Check out one row
-- The example shows the number who responded for:

-- question 1
-- at 'Edinburgh Napier University'
-- studying '(8) Computer Science'
-- Show the the percentage who STRONGLY AGREE
SELECT A_STRONGLY_AGREE
FROM nss
WHERE question='Q01'
        AND institution='Edinburgh Napier University'
        AND subject='(8) Computer Science';

-- 2	how many agree or strongly agree
-- Show the institution and subject where the score is at least 100 for question 15.
SELECT institution, subject
  FROM nss
 WHERE question='Q15' AND score >= 100;

-- 3	Unhappy Computer Students
-- Show the institution and score where the score for '(8) Computer Science' is less than 50 for question 'Q15'
SELECT institution,score
  FROM nss
 WHERE question='Q15'
   AND subject='(8) Computer Science'
   AND score < 50;

-- 4	More Computing or Creative Students?
-- Show the subject and total number of students who responded to question 22 for each of the subjects '(8) Computer Science' and '(H) Creative Arts and Design'.
SELECT subject, SUM(response) AS response
  FROM nss
 WHERE question='Q22'
   AND subject IN ('(8) Computer Science','(H) Creative Arts and Design') 
GROUP BY subject;
-- 5	Strongly Agree Numbers
-- Show the subject and total number of students who A_STRONGLY_AGREE to question 22 for each of the subjects '(8) Computer Science' and '(H) Creative Arts and Design'.

SELECT subject, SUM(A_STRONGLY_AGREE*response/100) AS STRONGLY_AGREE 
FROM nss
WHERE question='Q22'
      AND subject IN ('(8) Computer Science','(H) Creative Arts and Design') 
GROUP BY subject;

-- 6	Strongly Agree, Percentage
-- Show the percentage of students who A_STRONGLY_AGREE to question 22 for the subject '(8) Computer Science' show the same figure for the subject '(H) Creative Arts and Design'.

-- Use the ROUND function to show the percentage without decimal places.
SELECT subject, ROUND(SUM(response*A_STRONGLY_AGREE)/SUM(response),0) AS STRONGLY_AGREE 
FROM nss
WHERE question='Q22'
        AND subject IN ('(8) Computer Science','(H) Creative Arts and Design') 
GROUP BY subject;

-- 7	Scores for Institutions in Manchester
-- Show the average scores for question 'Q22' for each institution that include 'Manchester' in the name.
SELECT institution, SUM(score * response)/SUM(response) AS avg_score
FROM nss
WHERE question='Q22' AND (institution LIKE '%Manchester%')
GROUP BY institution
ORDER BY institution;

-- 8	Number of Computing Students in Manchester
-- Show the institution, the total sample size and the number of computing students for institutions in Manchester for 'Q01'.
SELECT institution, 
        SUM(sample) AS sample, 
        SUM(CASE WHEN subject = '(8) Computer Science' THEN sample ELSE 0 END) AS computing
FROM nss
WHERE question='Q01' AND (institution LIKE '%Manchester%')
GROUP BY institution;