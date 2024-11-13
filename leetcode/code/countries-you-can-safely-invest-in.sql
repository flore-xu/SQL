-- 1501. Countries You Can Safely Invest In
WITH CTE AS (
    select caller_id, duration 
        from Calls
    union all
    select callee_id, duration 
        from Calls
)
SELECT c.name AS country 
FROM CTE 
    JOIN Person p on CTE.caller_id=p.id
    JOIN Country c on LEFT(p.phone_number, 3)=c.country_code
GROUP BY c.name
HAVING AVG(CTE.duration) > (SELECT AVG(duration) FROM Calls);