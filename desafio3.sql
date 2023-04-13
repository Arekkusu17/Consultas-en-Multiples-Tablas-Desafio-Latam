-- CREATE DATABASE
CREATE DATABASE desafio3_alex_fernandez_179

--CONNECT DB
\c desafio3_alex_fernandez_179

--CREATE TABLE USERS
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR,
    name VARCHAR,
    lastname VARCHAR,
    rol VARCHAR
);

-- CREATE AND INSERT DATASET FOR USERS
INSERT INTO users(email, name, lastname,rol)
VALUES ( 'juliastone@dbtest.com', 'Julia', 'Stone','administrador' );
INSERT INTO users(email, name, lastname,rol)
VALUES ('alexanderclarke@dbtest.com','Alexander','Clarke','usuario');
INSERT INTO users(email, name, lastname,rol)
VALUES ( 'sophiadavis@dbtest.com', 'Sophia', ' Davis','usuario' );
INSERT INTO users(email, name, lastname,rol)
VALUES ( 'liamcampbell@dbtest.com', 'Liam','Campbell', 'usuario' );
INSERT INTO users(email, name, lastname,rol)
VALUES ( 'isabelleadams@dbtest.com', 'Isabelle', 'Adams', 'usuario');

--CREATE POSTS TABLE
CREATE TABLE IF NOT EXISTS posts (
    id SERIAL PRIMARY KEY,
    title VARCHAR,
    content TEXT,
    date_created TIMESTAMP,
    date_updated TIMESTAMP,
    destacado BOOLEAN,
    user_id INT
);

-- CREATE AND INSERT DATASET FOR POSTS
INSERT INTO posts(title,content,date_created,date_updated,destacado,user_id)
VALUES ('Title 1','Content 1','2023-04-09 09:00:00','2023-04-09 09:30:00',TRUE,1);
INSERT INTO posts(title,content,date_created,date_updated,destacado,user_id)
VALUES ('Title 2','Content 2','2023-04-09 10:00:00','2023-04-09 11:00:00',FALSE,1);
INSERT INTO posts(title,content,date_created,date_updated,destacado,user_id)
VALUES ('Title 3','Content 3','2023-04-09 12:00:00','2023-04-09 14:00:00',FALSE,5);
INSERT INTO posts(title,content,date_created,date_updated,destacado,user_id)
VALUES ('Title 4','Content 4','2023-04-09 15:00:00','2023-04-09 16:00:00',TRUE,4);
INSERT INTO posts(title,content,date_created,date_updated,destacado,user_id)
VALUES ('Title 5','Content 5','2023-04-09 17:00:00','2023-04-09 19:00:00',FALSE,NULL);

--CREATE TABLE COMMENTS
CREATE TABLE IF NOT EXISTS comments (
    id SERIAL PRIMARY KEY,
    content TEXT,
    date_created TIMESTAMP,
    user_id INT,
    post_id INT
)

-- CREATE AND INSERT DATASET FOR comments
INSERT INTO comments (content,date_created,user_id,post_id)
VALUES('Comment 1','2023-04-09 10:00:00',1,1);
INSERT INTO comments (content,date_created,user_id,post_id)
VALUES('Comment 2','2023-04-09 10:15:00',2,1);
INSERT INTO comments (content,date_created,user_id,post_id)
VALUES('Comment 3','2023-04-09 10:20:00',3,1);
INSERT INTO comments (content,date_created,user_id,post_id)
VALUES('Comment 4','2023-04-09 11:30:00',1,2);
INSERT INTO comments (content,date_created,user_id,post_id)
VALUES('Comment 5','2023-04-09 11:45:00',2,2);


-- CRUZA LOS DATOS DE LA TABLA USUARIOS Y POSTS MOSTRANDO LAS SIGUIENTES COLUMNAS:
-- NOMBRE E EMAIL DE USUARIO JUNTO AL TÍTULO Y CONTENIDO DEL POST
SELECT u.name,u.email,p.title AS post_title,p.content AS post_content FROM users u JOIN posts p ON u.id=p.user_id;



--MUESTRA EL ID,TITULO Y CONTENDIO DE LOS POST DE LOS ADMINISTRADORES, EL ADMINISTRADOR 
-- PUEDE SER CUALQUIER ID Y DEBES SELECCIONARLO DINAMICAMENTE
SELECT p.id, p.title, p.content 
FROM posts p 
JOIN users u ON p.user_id=u.id 
WHERE u.rol='administrador';

-- CUENTA LA CANTIDAD DE POSTS DE CADA USUARIO. LA TABLA RESULTANTE
--DEBE MOSTRAR EL ID E EMAIL JUNTO CON LA CANTIDAD DE POSTS DE CADA USUARIO
SELECT u.id,u.email,COUNT(p.id) AS post_qty 
FROM users u 
LEFT JOIN posts p ON u.id=p.user_id
GROUP BY u.id,u.email
ORDER BY u.id ASC; 

-- MUESTRA EL EMAIL DEL USUARIO QUE HA CREADO MÁS POSTS. LA TABLA
-- RESULTANTE TIENE UN ÚNICO REGISTRO Y MUESTRA SOLO EL EMAIL
SELECT u.email 
FROM users u
INNER JOIN (
    SELECT user_id,COUNT(*) as num_posts
    FROM posts
    GROUP BY user_id
    ORDER BY num_posts DESC 
    LIMIT 1
) p ON u.id=p.user_id

-- MUESTRA LA FECHA DEL ÚLTIMO POST DE CADA USUARIO
SELECT u.name, MAX(p.date_created) as last_post_date
FROM users u
JOIN posts p ON u.id=p.user_id
GROUP BY u.name;

-- MUESTRA EL TÍTULO Y CONTENIDO DEL POST CON MÁS COMENTARIOS
SELECT p.title, p.content,comment_qty
FROM posts p 
INNER JOIN (
    SELECT post_id, COUNT(*) as comment_qty
    FROM comments c 
    GROUP BY post_id
    ORDER BY comment_qty DESC
    LIMIT 1
) c ON p.id=c.post_id;

--MUESTRA EN UNA TABLA EL TÍTULO DE CADA POST, EL CONTENIDO DE CADA POST 
-- Y EL CONTENIDO DE CADA COMENTARIO ASOCIADO A LOS POST MOOSTRADOS, JUNTO
-- AL EMAIL DEL USUARIO QUE LO ESCRIBIO
SELECT p.title AS post_title, p.content AS post_content,c.content AS comment_content, u.email
FROM posts p 
JOIN comments c ON p.id=c.post_id
JOIN users u ON c.user_id=u.id;

--MUESTRA EL CONTENIDO DEL ULTIMO COMENTARIO DE CADA USUARIO

SELECT date_created, content, user_id FROM comments as c JOIN users as u ON c.user_id = u.id WHERE c.date_created = (SELECT MAX(date_created) FROM comments WHERE user_id = u.id);

-- MUESTRA LOS EMAILS DE LOS USUARIOS QUE NO TIENEN NINGUN COMENTARIO
SELECT u.email
FROM users u 
LEFT JOIN comments c on u.id=c.user_id
GROUP BY u.email
HAVING COUNT(c.id)=0;