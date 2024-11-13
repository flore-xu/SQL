-- 2066. Account Balance
SELECT account_id, day,
        sum(case when type='Deposit' then amount else -amount end) over (partition by account_id order by day) as balance
FROM Transactions 
ORDER BY account_id ASC, day ASC;