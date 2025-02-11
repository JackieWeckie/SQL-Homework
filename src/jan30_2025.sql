CREATE TABLE publishers
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(128) NOT NULL
        CHECK (name > 0)
);

CREATE TABLE books
(
    id           SERIAL PRIMARY KEY,
    title        VARCHAR(128) NOT NULL,
    date         DATE         NOT NULL,
    CHECK (title > 0),
    publisher_id INT REFERENCES publishers (id) ON DELETE CASCADE
);

CREATE TABLE authors
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(128) NOT NULL
        CHECK (LENGTH(name) > 0)
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

SELECT b.title AS Название,
       p.name  AS Автор

FROM books b
         JOIN books_authors ab ON b.id = ab.book_id
         JOIN publishers p on p.id = b.publisher_id;

ALTER TABLE books
    ADD COLUMN price DECIMAL(10, 2) NOT NULL;
UPDATE books
SET price = 7.99
WHERE title = 'SQL Сборник Рецептов';

UPDATE books
SET price = 4.59
WHERE title = 'Теоретический Минимум По Computer Science';

INSERT INTO publishers (name, id)
VALUES ('Oracle Press', '3');

INSERT INTO books (title, date, publisher_id, id)
VALUES ('Core Java, Volume 1: Fundamentals', '2024-07-15', '3', '3');

INSERT INTO authors (id, name)
VALUES ('4', 'Кэй С.Хорстманн');

INSERT INTO books_authors (book_id, author_id)
VALUES ('3', '4');

UPDATE books
SET price = 57.99
WHERE title = 'Core Java, Volume 1: Fundamentals';

SELECT AVG(price) AS Средняя_цена, MIN(price) AS Минимальная_цена, MAX(price) AS Максимальная_цена
FROM books;

SELECT authors.id AS ID_автора, COUNT(books.id) AS Колво_книг, AVG(books.price) AS Средняя_цена
FROM authors
         JOIN books_authors ON authors.id = books_authors.author_id
         JOIN books ON books_authors.book_id = books.id
GROUP BY authors.id;

SELECT authors.id AS ID_автора
FROM authors
         LEFT JOIN books_authors ON authors.id = books_authors.author_id
         LEFT JOIN books ON books_authors.book_id = books.id
WHERE books.id IS NULL;

SELECT authors.id AS ID_автора
FROM authors
         LEFT JOIN books_authors ON authors.id = books_authors.author_id
GROUP BY authors.id
HAVING COUNT(books_authors.author_id) = 0;

INSERT INTO publishers (name)
VALUES ('');

INSERT INTO authors (name)
VALUES ('');

INSERT INTO books (title, date, price)
VALUES ('', NULL, '');

CREATE TABLE categories
(
    id        SERIAL PRIMARY KEY,
    name      VARCHAR(128) NOT NULL,
    parent_id INTEGER REFERENCES categories (id)
);

INSERT INTO categories (name, parent_id)
VALUES ('Категория 1', NULL),
       ('Категория 2', 1),
       ('Категория 3', 2);

ALTER TABLE books
    ADD COLUMN page_amount INTEGER;

UPDATE books
SET page_amount = 700
WHERE title = 'SQL Сборник Рецептов';

UPDATE books
SET page_amount = 450
WHERE title = 'Теоретический Минимум По Computer Science';

UPDATE books
SET page_amount = 650
WHERE title = 'Core Java, Volume 1: Fundamentals';

SELECT title, page_amount
FROM books
WHERE page_amount > (SELECT AVG(page_amount) FROM books);

ALTER TABLE books
    ADD COLUMN book_amount INTEGER;

UPDATE books
SET book_amount = 32
WHERE title = 'SQL Сборник Рецептов';

UPDATE books
SET book_amount = 19
WHERE title = 'Теоретический Минимум По Computer Science';

UPDATE books
SET book_amount = 9
WHERE title = 'Core Java, Volume 1: Fundamentals';

SELECT title, date
FROM books
WHERE date = (SELECT MAX(date) FROM books);

SELECT title, (price * book_amount) AS Стоимость_всех_книг
FROM books
WHERE (price * book_amount) > 300
ORDER BY Стоимость_всех_книг;

SELECT title, (price * book_amount) AS Стоимость_всех_книг
FROM books
GROUP BY title, price, book_amount
HAVING (price * book_amount) > 300
ORDER BY Стоимость_всех_книг;

WITH book_value AS (SELECT title, (price * book_amount) AS Стоимость_всех_книг
                    FROM books)
SELECT *
FROM book_value
WHERE Стоимость_всех_книг > 300
ORDER BY Стоимость_всех_книг;

SELECT
    b.title AS Название_книги,
    b.date AS Опубликовано,
    a.name AS Имя_автора,
  CASE
WHEN b.date = (CURRENT_DATE) THEN 'Новинка!'
WHEN b.date >= (CURRENT_DATE) - 2 THEN 'Недавняя'
ELSE 'Давняя'
  END AS Статус_книги
FROM
  books b
JOIN
  books_authors ba ON b.id = ba.book_id
JOIN
  authors a ON ba.author_id = a.id
ORDER BY
  b.title, ba.book_id;
