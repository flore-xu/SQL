-- 1454. Active Users

-- function
DELIMITER //
CREATE FUNCTION get_active_users(n INT)
RETURNS TABLE
BEGIN
    RETURN (
        WITH CTE1 AS(
            SELECT DISTINCT *
            FROM Logins 
        ), CTE2 AS(
            SELECT id, login_date,
            COUNT(*) OVER(PARTITION BY id ORDER BY login_date RANGE BETWEEN CURRENT ROW AND INTERVAL 4 DAY FOLLOWING) AS ct
            FROM CTE1
        )
        SELECT DISTINCT c.id, a.name
        FROM CTE2 c
        JOIN Accounts a ON a.id=c.id
        WHERE c.ct >= n
        ORDER BY c.id ASC
    );
END //
DELIMITER ;

SELECT * FROM get_active_users(5);


-- procedure
DELIMITER //
CREATE PROCEDURE get_active_users(IN n INT)
BEGIN
    WITH CTE1 AS(
        SELECT DISTINCT *
        FROM Logins 
    ), CTE2 AS(
        SELECT id, login_date,
        COUNT(*) OVER(PARTITION BY id ORDER BY login_date RANGE BETWEEN CURRENT ROW AND INTERVAL 4 DAY FOLLOWING) AS ct
        FROM CTE1
    )
    SELECT DISTINCT c.id, a.name
    FROM CTE2 c
    JOIN Accounts a ON a.id=c.id
    WHERE c.ct >= n
    ORDER BY c.id ASC;
END //
DELIMITER ;

CALL get_active_users(5);

