PRAGMA foreign_keys = ON;

DROP TABLE question_likes;
DROP TABLE replies;
DROP TABLE question_follows;
DROP TABLE questions;
DROP TABLE users;

CREATE TABLE users(
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

CREATE TABLE questions(
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY(author_id) REFERENCES users(id)
);

CREATE TABLE question_follows(
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

CREATE TABLE replies(
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  subject_question_id INTEGER NOT NULL,
  parent_reply_id INTEGER,
  user_id INTEGER NOT NULL,

  FOREIGN KEY(subject_question_id) REFERENCES questions(id),
  FOREIGN KEY(parent_reply_id) REFERENCES replies(id),
  FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE question_likes(
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

INSERT INTO
  users(fname, lname)
VALUES
  ('Ned','Stark'),
  ('Kush','Patel'),
  ('Earl','Sweatshirt'),
  ('Chad', 'C'),
  ('Ken', 'C'),
  ('Paige', 'C');

INSERT INTO
  questions(title, body, author_id)
VALUES
  ('Ned Question', 'NED NED NED', 1),
  ('Kush Question', 'KUSH KUSH KUSH', 2),
  ('Earl Question', 'MEOW MEOW MEOW', 3),
  ('what time is it?', 'I''m not sure what time it is.', 1);

INSERT INTO 
  replies(body, subject_question_id, user_id)
VALUES
  ('NED', 1, 2),
  ('NED', 1, 3),
  ('KUSH', 2, 1),
  ('KUSH', 2, 3),
  ('EARL', 3, 1),
  ('EARL', 3, 2),
  ('it''s 6:34 man', 4, 2);
INSERT INTO 
  replies(body, subject_question_id, parent_reply_id, user_id)
VALUES
  ('Thanks Kush!', 4, 7, 1),
  ('AnyTIME lolz', 4, 7, 2),
  ('SMH Kush', 4, 9, 3);

INSERT INTO 
  question_follows(user_id, question_id)
VALUES
  (1, 1),
  (2, 2),
  (3, 3),
  (1, 4),
  (2, 1),
  (3, 1),
  (1, 2),
  (3, 2),
  (1, 3),
  (2, 3),
  (2, 4),
  (3, 4),
  (4, 4),
  (5, 4),
  (6, 4),
  (4, 3),
  (5, 3),
  (6, 2);

