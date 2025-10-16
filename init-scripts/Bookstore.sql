-- Rensa om databasen redan finns
DROP DATABASE IF EXISTS bookstore;

-- Skapa om den
CREATE DATABASE bookstore;
USE bookstore;

-- Författare
CREATE TABLE author (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    birth_date DATE NOT NULL
);

INSERT INTO author (first_name, last_name, birth_date)
VALUES
    ('John', 'Tolkien', '1892-01-03'),
    ('Joanne', 'Murray', '1965-07-31');

CREATE TABLE language (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

INSERT INTO language (name)
VALUES
    ('English'),
    ('Swedish');

CREATE TABLE book (
    isbn CHAR(13) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    publication_date DATE NOT NULL,
    author_id INT NOT NULL,
    language_id INT,
    FOREIGN KEY (author_id) REFERENCES author(id),
    FOREIGN KEY (language_id) REFERENCES language(id)
);

INSERT INTO book (isbn, title, price, publication_date, author_id, language_id)
VALUES
    ('9781566210925', 'Lord of the Rings', 149.99, '1980-10-02', 1, 1),
    ('9781523567217', 'Harry Potter', 149.99, '1980-10-02', 2, 1);

CREATE TABLE bookstore (
                           id INT AUTO_INCREMENT PRIMARY KEY,
                           store_name VARCHAR(100) NOT NULL,
                           city VARCHAR(100) NOT NULL
);

INSERT INTO bookstore (store_name, city)
VALUES
    ('Adlibris', 'Piteå'),
    ('Akademibokhandeln', 'Stockholm');

CREATE TABLE inventory (
                           store_id INT NOT NULL,
                           isbn CHAR(13) NOT NULL,
                           amount INT NOT NULL DEFAULT 0,
                           PRIMARY KEY (store_id, isbn),
                           FOREIGN KEY (store_id) REFERENCES bookstore(id),
                           FOREIGN KEY (isbn) REFERENCES book(isbn)
);

INSERT INTO inventory (store_id, isbn, amount)
VALUES
    (1, '9781566210925', 5),
    (2, '9781523567217', 3);
