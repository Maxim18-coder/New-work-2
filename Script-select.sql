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