-- Задание 1


USE vk;
SHOW TABLES;
DESC posts;
DESC likes;
DESC media;
DESC messages;
DESC users;

CREATE INDEX posts_head_idx ON posts(head);

SHOW INDEX FROM posts;
SHOW INDEX FROM messages;
SHOW INDEX FROM media;
SHOW INDEX FROM users;

CREATE INDEX users_first_name_last_name_idx ON users(first_name, last_name);

CREATE UNIQUE INDEX users_email_uq ON users(email);

ALTER TABLE posts DROP INDEX posts_head_idx;
ALTER TABLE users DROP INDEX users_first_name_last_name_idx;
ALTER TABLE users DROP index users_email_uq;


-- Задание 2


SHOW TABLES;
DESC communities;
DESC communities_users;
SELECT * FROM users;
SELECT * FROM profiles WHERE first_name = 'Ida';
SELECT * FROM profiles;
SELECT * FROM communities;
SELECT * FROM communities_users;

SELECT COUNT(c_u.user_id) FROM communities_users AS c_u;
SELECT COUNT(c.id) FROM communities AS c;

SELECT DISTINCT c.name AS name,
  COUNT(c_u.user_id) OVER () / (SELECT COUNT(c.id) FROM communities AS c) AS average_number_of_users,
  FIRST_VALUE(CONCAT(u.first_name, ' ', u.last_name)) OVER (w_c ORDER BY p.birthday DESC) AS youngest,
  FIRST_VALUE(CONCAT(u.first_name, ' ', u.last_name)) OVER (w_c ORDER BY p.birthday ASC) AS oldest,
  COUNT(c_u.user_id) OVER (PARTITION BY c_u.community_id) AS users_in_the_group,
  (SELECT COUNT(id) FROM users) AS users_total,
  COUNT(c_u.user_id) OVER w_c / (SELECT COUNT(id) FROM users) *100 AS '%%'
    FROM communities AS c
      LEFT JOIN communities_users AS c_u
        ON c_u.user_id = c.id
	  LEFT JOIN users AS u
        ON c_u.user_id = u.id
	  LEFT JOIN profiles AS p
        ON p.user_id = u.id
	  WINDOW w_c AS (PARTITION BY c.id);    