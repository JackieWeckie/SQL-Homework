CREATE TABLE publishers
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(128) NOT NULL
);

CREATE TABLE books
(
    id           SERIAL PRIMARY KEY,
    title        VARCHAR(128) NOT NULL,
    date         DATE,
    publisher_id INT REFERENCES publishers (id) ON DELETE CASCADE
);

CREATE TABLE authors
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(128) NOT NULL
);

CREATE TABLE books_authors
(
    book_id   INT REFERENCES books (id) ON DELETE CASCADE,
    author_id INT REFERENCES authors (id) ON DELETE CASCADE,
    PRIMARY KEY (book_id, author_id)
);

INSERT INTO authors (name)
VALUES ('Энтони Молинаро'),
       ('Роберт де Грааф'),
       ('Владстон Феррейро Фило');

INSERT INTO books (title, date)
VALUES ('SQL Сборник Рецептов', '2023-07-13'),
       ('Теоретический Минимум По Computer Science', '2020-11-27');

INSERT INTO publishers (name)
VALUES ('OReilly'),
       ('Питер');

INSERT INTO books_authors (book_id, author_id)
VALUES ('1', '1'),
       ('1', '2'),
       ('2', '3');

SELECT b.title AS book_title,
       p.name  AS publisher_name

FROM books b
         JOIN books_authors ab ON b.id = ab.book_id
         JOIN publishers p on p.id = b.publisher_id;

ALTER TABLE books
ADD COLUMN price DECIMAL(10,2);
UPDATE books SET price = 7.99;
UPDATE books SET price = 4.59;
UPDATE books SET price = 57.99;

INSERT INTO publishers (name, id)
VALUES ('Oracle Press', '3');

INSERT INTO books (title, date, publisher_id, id)
VALUES ('Core Java, Volume 1: Fundamentals', '2024-07-15', '3', '3');

INSERT INTO authors (id, name)
VALUES ('4', 'Кэй С.Хорстманн');

INSERT INTO books_authors (book_id, author_id)
VALUES ('3', '4');

SELECT AVG(price) AS average_price, MIN(price) AS min_price, MAX(price) AS max_price FROM books;

SELECT authors.id, COUNT(books.id) AS book_count, AVG(books.price) AS average_price
FROM authors
JOIN books_authors ON authors.id = books_authors.author_id
JOIN books ON books_authors.book_id = books.id
GROUP BY authors.id;

SELECT authors.id, COUNT(books.id) AS book_count, AVG(books.price) AS average_price
FROM authors
JOIN books_authors ON authors.id = books_authors.author_id
JOIN books ON books_authors.book_id = books.id
GROUP BY authors.id;

SELECT authors.id
FROM authors
LEFT JOIN books_authors ON authors.id = books_authors.author_id
LEFT JOIN books ON books_authors.book_id = books.id
WHERE books.id IS NULL;

SELECT authors.id
FROM authors
LEFT JOIN books_authors ON authors.id = books_authors.author_id
GROUP BY authors.id
HAVING COUNT(books_authors.author_id) = 0;
