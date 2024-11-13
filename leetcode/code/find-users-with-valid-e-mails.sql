-- 1517. Find Users With Valid E-Mails
SELECT *
FROM Users
WHERE mail REGEXP '^[a-zA-Z][\\w_.-]*@leetcode\\.com$';