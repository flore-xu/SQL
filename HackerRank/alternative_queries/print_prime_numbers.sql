/*
trial division algorithm: a prime n is indivisible by integers in [2, sqrt(n)]

*/

DELIMITER //
CREATE PROCEDURE printprime(n INT)
BEGIN
    DECLARE iter INT DEFAULT 2;
    DECLARE last INT DEFAULT n;
    DECLARE traversal INT DEFAULT 0;
    DECLARE divisible_count INT DEFAULT 0;
    DECLARE chain TEXT DEFAULT '';
    
    WHILE iter <= last DO
        SET divisible_count = 0;
        SET traversal = 2;
        WHILE traversal <= FLOOR(SQRT(iter)) DO
            IF iter % traversal = 0 THEN
                SET divisible_count = 1;
            END IF;
            SET traversal = traversal + 1;
        END WHILE ;
        IF divisible_count = 0 THEN
            IF iter = 2 THEN
                SET chain = '2';
            ELSE 
                SET chain = CONCAT(chain, '&', iter);
            END IF;
        END IF;
        SET iter = iter + 1;
    END WHILE;
    SELECT chain;
END //
DELIMITER ;

CALL printprime(1000);
