DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  parent_id INTEGER,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (parent_id) REFERENCES replies(id),
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES user(id)

);

DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);


INSERT INTO
  users (fname, lname)
VALUES
  ('John', 'Doe'),
  ('Phil', 'turner'),
  ('Benjamin', 'Dover'),
  ('Mr. Hue', 'Johnson'),
  ('Hugh', 'G. Rolly'),
  ('Jared', 'Subway');

INSERT INTO
  questions (title, body, user_id)
VALUES
  ('hello', 'world?', 1),
  ('flat earth theory', 'is the earth round?', 2),
  ('desperate student', 'how long is this going to take?', 3),
  ('student','how do I SQL?', 4);

INSERT INTO
  replies (body, question_id, user_id)
VALUES
  ('nope, this is pluto', 1, 1),
  ('The earth is not round', 2, 2),
  ('Too long', 4, 4),
  ('I do not know man', 3, 3);

  INSERT INTO
    question_follows (user_id, question_id)
  VALUES
    (2, 1),
    (1, 2),
    (3, 3),
    (4, 4);

    INSERT INTO
      question_likes (user_id, question_id)
    VALUES
      (2, 1),
      (1, 2),
      (3, 3),
      (4, 2);
