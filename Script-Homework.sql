CREATE TABLE IF NOT EXISTS genres (
    genre_id SERIAL PRIMARY KEY,
    genre_name VARCHAR(50) NOT NULL
);

select * from genres;

INSERT INTO genres (genre_name) VALUES
('Rock'),
('Pop'),
('Rock'),
('Folk');

CREATE TABLE IF NOT EXISTS musicians (
    musicians_id SERIAL PRIMARY KEY,
    musician_name VARCHAR(50) NOT null,
    alias VARCHAR(50) NOT null,
    country VARCHAR(50) NOT null
);

select * from musicians;

INSERT INTO musicians (musicians_id, musician_name) VALUES
('1', 'Klaus Alias'),
('2', 'Abel'),
('3', 'Till' ),
('4', 'Anastasiya');


CREATE TABLE IF NOT EXISTS genremusicians (
    genre_id INT NOT NULL REFERENCES genres(genre_id),
    musicians_id INT NOT NULL REFERENCES musicians(musicians_id),
    PRIMARY KEY (genre_id, musicians_id)
);

select * from genremusicians;

INSERT INTO genremusicians (genre_id, musicians_id) values
('1', '1'),
('2', '2'),
('3', '1'),
('4', '3');

CREATE TABLE IF NOT EXISTS albums (
    album_id SERIAL PRIMARY KEY,
    album_name VARCHAR(50) NOT NULL,
    album_year INTEGER
);

select * from albums;


INSERT INTO albums (album_name, album_year) VALUES
('Peacemaker', '2020'),
('Starboy', '2018'),
('Sonne', '2014'),
('Confession Of Loki', '2019');

CREATE TABLE IF NOT EXISTS albummusicians (
    musicians_id INT NOT NULL REFERENCES musicians(musicians_id),
    album_id INT NOT NULL REFERENCES albums(album_id),
    PRIMARY KEY (musicians_id, album_id)
);

select * from albummusicians;

INSERT INTO albummusicians (album_id, musicians_id) values
('1', '1'),
('2', '2'),
('3', '3'),
('4', '4');

CREATE TABLE IF NOT EXISTS collections (
    collection_id SERIAL PRIMARY KEY,
    collection_name VARCHAR(50) NOT NULL,
    collection_year INTEGER
);

select * from collections;

INSERT INTO collections (collection_name , collection_year) values
('GoldBallads', '2020'),
('Aeternastory', '2018'),
('Sonne', '2018'),
('NormalGuy', '2017');

CREATE TABLE IF NOT EXISTS songs (
    songs_id SERIAL PRIMARY KEY,
    song_name VARCHAR(50) NOT NULL,
    duration INTEGER,
    album_id INT REFERENCES albums(album_id)
);

select * from songs;

INSERT INTO songs (song_name, duration, album_id) values
('Peacemaker', '239', '1'),
('When you know', '246', '1'),
('intro', '92', '4'),
('my main', '177','2'),
('Confession Loki', '416', '4'),
('мой путь', '209', '3');


CREATE TABLE IF NOT EXISTS musiccollections (
    collection_id INT NOT NULL REFERENCES collections(collection_id),
    songs_id INT NOT NULL REFERENCES songs(songs_id),
    PRIMARY KEY (collection_id, songs_id)
);

select * from musiccollections;

INSERT INTO musiccollections (collection_id, songs_id) values
('1', '1'),
('1', '2'),
('2', '3'),
('2', '5'),
('3', '4'),
('4', '6');


SELECT song_name, duration
    FROM songs
    ORDER BY duration desc 
    LIMIT 1;

SELECT song_name, duration
    FROM songs 
    WHERE duration >= 210;

SELECT collection_name 
FROM collections 
WHERE collection_year::INTEGER >= 2018 AND collection_year::INTEGER <= 2020;


SELECT musician_name
   FROM musicians
   WHERE musician_name IS NOT NULL AND musician_name <> '';

SELECT song_name /* Имя трека из таблицы треков */
FROM songs
WHERE song_name ILIKE 'мой %' /* Где слово в начале строки */
OR song_name ILIKE '% мой' /* Где слово в конце строки */
OR song_name ILIKE '% мой %' /* Где слово в середине строки */
OR song_name ILIKE 'мой' /* Где название трека состоит из одного искомого слова */
OR song_name ILIKE 'my %' /* Где слово в начале строки для "my" */
OR song_name ILIKE '% my' /* Где слово в конце строки для "my" */
OR song_name ILIKE '% my %' /* Где слово в середине строки для "my" */
OR song_name ILIKE 'my'; /* Где название трека состоит из одного искомого слова для "my" */;

SELECT g.genre_name, COUNT(ms.musicians_id) AS musician_count
FROM genres g
JOIN genremusicians gm ON g.genre_id = gm.genre_id
JOIN musicians ms ON gm.musicians_id = ms.musicians_id
GROUP BY g.genre_name;

SELECT COUNT(s.songs_id) AS song_count
   FROM songs s
   JOIN albums al ON s.album_id = al.album_id
   WHERE al.album_year BETWEEN 2019 AND 2020;

SELECT al.album_name, AVG(s.duration) as average_duration
    FROM albums al
    JOIN songs s ON al.album_id = s.album_id
    GROUP BY al.album_name;

SELECT m.musician_name
FROM musicians m
WHERE m.musicians_id NOT IN (
    SELECT gm.musicians_id
    FROM genremusicians gm
    JOIN albummusicians am ON gm.musicians_id = am.musicians_id
    JOIN albums al ON am.album_id = al.album_id
    WHERE al.album_year = 2020
);

SELECT DISTINCT collection_name /* Имена сборников */
FROM collections /* Из таблицы сборников */
JOIN musiccollections ON musiccollections.collection_id = collections.collection_id /* Объединяем с промежуточной таблицей между сборниками и треками */
JOIN songs ON musiccollections.songs_id = songs.songs_id /* Объединяем с треками */
join albums ON songs.album_id = albums.album_id /* Объединяем с альбомами */
JOIN albummusicians ON albummusicians.album_id = albums.album_id /* Объединяем с промежуточной таблицей между альбомами и исполнителями */
JOIN musicians ON albummusicians.musicians_id = musicians.musicians_id /* Объединяем с исполнителями */
WHERE musician_name = 'Scorpions'; /* Где имя исполнителя равно определенному шаблону имени */