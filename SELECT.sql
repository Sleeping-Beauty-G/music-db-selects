-- Задание 2.
--  Название и продолжительность самого длительного трека
SELECT title, duration
FROM Track
ORDER BY duration DESC
LIMIT 1;

--  Название треков, продолжительность которых не менее 3,5 минут (210 секунд)
SELECT title, duration
FROM Track
WHERE duration >= 210;

--  Названия сборников, вышедших в период с 2018 по 2020 год включительно
SELECT title, release_year
FROM Compilation
WHERE release_year BETWEEN 2018 AND 2020;

-- Исполнители, чьё имя состоит из одного слова
SELECT name
FROM Artist
WHERE name NOT LIKE '% %';

--  Треки, содержащие «мой» или «my»
SELECT title
FROM Track
WHERE title ILIKE '%my%' OR title ILIKE '%мой%';

-- Задание 3.
--  Количество исполнителей в каждом жанре
SELECT g.name AS genre, COUNT(ag.artist_id) AS artist_count
FROM Genre g
LEFT JOIN ArtistGenre ag ON g.id = ag.genre_id
GROUP BY g.name;


--  Количество треков, вошедших в альбомы 2019–2020 годов
SELECT COUNT(*) AS track_count
FROM Track t
JOIN Album a ON t.album_id = a.id
WHERE a.release_year BETWEEN 2019 AND 2020;

--  Средняя продолжительность треков по каждому альбому
SELECT a.title AS album, AVG(t.duration) AS avg_duration
FROM Album a
JOIN Track t ON a.id = t.album_id
GROUP BY a.title;

-- Все исполнители, которые не выпустили альбомы в 2020 году
SELECT name
FROM Artist
WHERE id NOT IN (
    SELECT aa.artist_id
    FROM ArtistAlbum aa
    JOIN Album a ON aa.album_id = a.id
    WHERE a.release_year = 2020
 );
 -- Названия сборников, в которых присутствует конкретный исполнитель
 SELECT DISTINCT c.title
FROM Compilation c
JOIN CompilationTrack ct ON c.id = ct.compilation_id
JOIN Track t ON ct.track_id = t.id
JOIN Album a ON t.album_id = a.id
JOIN ArtistAlbum aa ON a.id = aa.album_id
JOIN Artist ar ON aa.artist_id = ar.id
WHERE ar.name = 'GOT7';

-- Задание 4.
-- Названия альбомов, в которых присутствуют исполнители более чем одного жанра
SELECT DISTINCT al.title AS album
FROM Album al
JOIN ArtistAlbum aa ON al.id = aa.album_id
JOIN ArtistGenre ag ON aa.artist_id = ag.artist_id
GROUP BY al.id, al.title
HAVING COUNT(DISTINCT ag.genre_id) > 1;

-- Наименования треков, которые не входят в сборники
SELECT t.title
FROM Track t
LEFT JOIN CompilationTrack ct ON t.id = ct.track_id
WHERE ct.compilation_id IS NULL;

-- Исполнитель или исполнители, написавшие самый короткий по продолжительности трек
SELECT DISTINCT ar.name
FROM Artist ar
JOIN ArtistAlbum aa ON ar.id = aa.artist_id
JOIN Album al ON aa.album_id = al.id
JOIN Track t ON t.album_id = al.id
WHERE t.duration = (
    SELECT MIN(duration) FROM Track
);

--  Названия альбомов, содержащих наименьшее количество треков
WITH track_counts AS (
    SELECT album_id, COUNT(*) AS track_count
    FROM Track
    GROUP BY album_id
)
SELECT al.title
FROM Album al
JOIN track_counts tc ON al.id = tc.album_id
WHERE tc.track_count = (
    SELECT MIN(track_count) FROM track_counts
);







