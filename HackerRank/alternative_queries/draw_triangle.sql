-- draw triangle 1
DELIMITER //
CREATE PROCEDURE P(IN n INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    WHILE i < n DO
        SELECT REPEAT('* ', n - i);
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;

CALL P(20);

-- draw triangle 2
DELIMITER //
CREATE PROCEDURE P(IN n INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= n DO
        SELECT REPEAT('* ', i);
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;

CALL P(20);