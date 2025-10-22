USE bookstore;

CREATE OR REPLACE VIEW total_author_book_value AS
SELECT
    CONCAT(a.first_name, ' ', a.last_name) AS name,
    TIMESTAMPDIFF(YEAR, a.birth_date, CURDATE()) AS age,
    COUNT(DISTINCT b.isbn) AS book_title_count,
    ROUND(SUM(b.price * i.amount), 2) AS inventory_value
FROM author a
         LEFT JOIN book b ON a.id = b.author_id
         LEFT JOIN inventory i ON b.isbn = i.isbn
GROUP BY a.id, a.first_name, a.last_name, a.birth_date;

SELECT * FROM total_author_book_value;

-- Lokalt konto
CREATE USER IF NOT EXISTS 'developer'@'localhost' IDENTIFIED BY 'devpassword';
-- Fjärråtkomst (för Docker/verktyg som inte ansluter som localhost)
CREATE USER IF NOT EXISTS 'developer'@'%' IDENTIFIED BY 'devpassword';

GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, INDEX
    ON bookstore.* TO 'developer'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, INDEX
    ON bookstore.* TO 'developer'@'%';

-- Säkerhet – ta bort administrativa rättigheter
REVOKE CREATE USER, GRANT OPTION
    ON *.* FROM 'developer'@'localhost';
REVOKE CREATE USER, GRANT OPTION
    ON *.* FROM 'developer'@'%';

CREATE USER IF NOT EXISTS 'webserver'@'localhost' IDENTIFIED BY 'webpassword';
CREATE USER IF NOT EXISTS 'webserver'@'%' IDENTIFIED BY 'webpassword';

GRANT SELECT, INSERT, UPDATE, DELETE
    ON bookstore.* TO 'webserver'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE
    ON bookstore.* TO 'webserver'@'%';

-- Säkerhet – ta bort schema- och adminrättigheter
REVOKE CREATE, DROP, ALTER, CREATE USER, GRANT OPTION
    ON *.* FROM 'webserver'@'localhost';
REVOKE CREATE, DROP, ALTER, CREATE USER, GRANT OPTION
    ON *.* FROM 'webserver'@'%';

FLUSH PRIVILEGES;

SHOW GRANTS FOR 'developer'@'localhost';
SHOW GRANTS FOR 'developer'@'%';
SHOW GRANTS FOR 'webserver'@'localhost';
SHOW GRANTS FOR 'webserver'@'%';
