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

CREATE USER IF NOT EXISTS 'developer'@'localhost' IDENTIFIED BY 'devpassword';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, INDEX
    ON bookstore.* TO 'developer'@'localhost';
REVOKE CREATE USER, CREATE, GRANT OPTION
    ON *.* FROM 'developer'@'localhost';

CREATE USER IF NOT EXISTS 'webserver'@'localhost' IDENTIFIED BY 'webpassword';
GRANT SELECT, INSERT, UPDATE, DELETE
    ON bookstore.* TO 'webserver'@'localhost';
REVOKE CREATE, DROP, ALTER, CREATE USER, GRANT OPTION
    ON *.* FROM 'webserver'@'localhost';

SHOW GRANTS FOR 'developer'@'localhost';
SHOW GRANTS FOR 'webserver'@'localhost';
