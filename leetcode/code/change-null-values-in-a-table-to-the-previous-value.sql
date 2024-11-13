-- 2388. Change Null Values in a Table to the Previous Value

-- solution1: user-defined variable `tmp` keeps track of the last non-NULL value of the drink column
SELECT id,
        @tmp := IFNULL(drink, @tmp) AS drink
FROM CoffeeShop;

-- solution2: ROW ID and self-join
WITH Shop AS(
    SELECT *, ROW_NUMBER() OVER () AS rowid
    FROM CoffeeShop
), CTE AS (
    SELECT s1.rowid, MAX(s1.id) AS s1_id, MAX(s1.drink) AS s1_drink, MAX(s2.rowid) AS s2_rowid
    FROM Shop s1
        LEFT JOIN Shop s2 ON s1.rowid > s2.rowid AND s1.drink IS NULL AND s2.drink IS NOT NULL
    GROUP BY s1.rowid
)
SELECT c.s1_id AS id, IFNULL(c.s1_drink, s.drink) AS drink
FROM CTE c 
    LEFT JOIN Shop s ON c.s2_rowid=s.rowid
ORDER BY c.rowid ASC;