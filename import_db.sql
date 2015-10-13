CREATE TABLE users(
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255),
  body VARCHAR(255),
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows(
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);


CREATE TABLE replies(
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,
  body VARCHAR(255),

  FOREIGN KEY (parent_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)

);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);


INSERT INTO
  users(fname, lname)
VALUES
  ('Peter', 'Zheng')
  ;

INSERT INTO
  questions(title, body, author_id)
VALUES
  ('hi', 'hello world', 1)
  ;

INSERT INTO
  questions(title, body, author_id)
VALUES
  ('i', 'hello world', 1)
  ;

INSERT INTO
  replies(question_id, parent_id, user_id, body)
VALUES
  (1, NULL, 1, "This is cool")
  ;

INSERT INTO
  replies(question_id, parent_id, user_id, body)
VALUES
  (1, 1, 1, "No it's not")
  ;

INSERT INTO
  replies(question_id, parent_id, user_id, body)
VALUES
  (1, 1, 1, "Yes")
  ;

INSERT INTO
  question_follows(question_id, user_id)
VALUES
  (2, 1)
  ;

INSERT INTO
  question_follows(question_id, user_id)
VALUES
  (1, 1)
  ;

INSERT INTO
  question_likes(user_id, question_id)
VALUES
  (1, 2)
  ;
