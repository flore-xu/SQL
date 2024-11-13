-- 571. Find Median Given Frequency of Numbers

-- median: both the number of all the previous/behind numbers is less than half the total number

WITH CTE AS(
    SELECT 
        *,
        sum(frequency) over(order by num) as rnk1,
        sum(frequency) over(order by num desc) as rnk2,
        sum(frequency) over() as ct
    from Numbers
)
select round(avg(num),1) as median 
from CTE 
where rnk1>= ct/2 AND rnk2>=ct/2