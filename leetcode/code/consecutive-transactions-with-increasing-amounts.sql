-- 2701. Consecutive Transactions with Increasing Amounts

with transaction as (
    select * 
    from Transactions 
    order by customer_id, transaction_date
), init as (
    select @g:=0, @d:=null, @a:=null, @c:=null
), t as (
    select
        *,
        @g:=if(@c = customer_id and datediff(transaction_date, @d) = 1 and amount > @a, @g, @g + 1) as g,
        @d:=transaction_date,
        @a:=amount,
        @c:=customer_id
    from transaction, init 
)
select
    customer_id,
    min(transaction_date) as consecutive_start,
    max(transaction_date) as consecutive_end
from t
group by g
having datediff(consecutive_end, consecutive_start) >= 2
order by customer_id 




with tmp as (
    select t1.*, 
            case when t2.customer_id is NULL then 1 else 0 end group_start
    from transactions t1
        left join transactions t2 on t1.customer_id=t2.customer_id
        and t1.amount > t2.amount
        and DATEDIFF(t1.transaction_date, t2.transaction_date)=1
), tmp2 as(
    select *,
            sum(group_start) over (order by customer_id,transaction_date) grp
from tmp
)
select customer_id, 
    min(transaction_date) consecutive_start, 
    max(transaction_date) consecutive_end
from tmp2
group by grp,customer_id
having count(1)>=3
order by customer_id