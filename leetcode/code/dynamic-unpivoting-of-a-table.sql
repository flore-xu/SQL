-- 2253. Dynamic Unpivoting of a Table
CREATE PROCEDURE UnpivotProducts()
BEGIN
	# Write your MySQL query statement below.
    SET group_concat_max_len = 10240;
    with temp as 
    (
        SELECT column_name 
        FROM information_schema.columns -- information_schema is a database provides access to database metadata, such as information about tables, columns, and access privileges. In this case, it’s being used to get information about columns in the Products table. 
        WHERE table_schema = DATABASE() -- database is the current database
            AND table_name = 'Products' 
            AND column_name <> 'product_id'
    )
    SELECT 
        GROUP_CONCAT(
            'SELECT product_id, "',
            column_name, '" AS store, ',
            column_name,
            ' AS price FROM Products WHERE ',
            column_name,
            ' IS NOT NULL' 
            SEPARATOR ' UNION all '
            ) INTO @sql 
    FROM temp;

    PREPARE statement FROM @sql;
    EXECUTE statement;
END