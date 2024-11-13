-- 2252. Dynamic Pivoting of a Table
CREATE PROCEDURE PivotProducts()
BEGIN
	# Write your MySQL query statement below.
    # initialize @sql variable
	SET @sql = NULL;
    # default max length of group_concat function is 1024, but we have at most 30 stores
    SET group_concat_max_len = 10240;
    WITH CTE AS (
        select distinct store 
        from Products
    )
    SELECT
        GROUP_CONCAT(
            CONCAT('MAX(IF(store = "', store, '", price, NULL)) AS ', store) SEPARATOR ', ') INTO @sql
    FROM CTE;

    # update @sql string variable
    SET @sql = CONCAT('SELECT product_id, ', 
                        @sql, 
                        ' FROM Products GROUP BY product_id');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
END