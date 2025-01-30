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

SELECT b.title AS book_title,
       p.name  AS publisher_name
FROM books b
         JOIN books_authors ab ON b.id = ab.book_id
         JOIN publishers p on p.id = b.publisher_id;

