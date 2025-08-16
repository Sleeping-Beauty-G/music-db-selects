
--  Название и продолжительность самого длительного трека
SELECT title, duration -- Выбираем называние треков и его длительность
FROM Track -- Из таблицы track
ORDER BY duration DESC -- Сначала самые длинные треки
LIMIT 1; -- Показываем только один трек

--  Название треков, продолжительность которых не менее 3,5 минут (210 секунд)
SELECT title, duration  -- Выбираем называние треков и его длительность
FROM Track -- Из таблицы track
WHERE duration >= 210; -- Только треки, которые длиннее или равны 210 секунд

--  Названия сборников, вышедших в период с 2018 по 2020 год включительно
SELECT title, release_year -- Выбираем называние треков и год выхода
FROM Compilation  -- Из таблицы Compilation
WHERE release_year BETWEEN 2018 AND 2020; -- Только сборники, вышедшие с 2018 по 2020 год включительно

-- Исполнители, чьё имя состоит из одного слова
SELECT name -- Выбираем имя исполнителя 
FROM Artist -- Из таблицы artist
WHERE name NOT LIKE '% %'; -- Только исполнители с одним словом в имени

--  Треки, содержащие «мой» или «my»
SELECT title -- Выбираем называние треков
FROM Track -- Из таблицы track
WHERE title ILIKE '%my%' OR title ILIKE '%мой%'; -- Оставляем треки, где в названии есть "my" или  "мой"

--  Количество исполнителей в каждом жанре
SELECT g.name AS genre, COUNT(ag.artist_id) AS artist_count -- Выбираем название жанра, сколько артистов связано с этим жанром
FROM Genre g -- -- Из таблицы genre
LEFT JOIN ArtistGenre ag ON g.id = ag.genre_id -- Соединяем с таблицей ArtistGenre, чтобы узнать, кто к какому жанру относится
GROUP BY g.name; -- Группируем по жанрам


--  Количество треков, вошедших в альбомы 2019–2020 годов
SELECT COUNT(*) AS track_count -- Считаем все треки
FROM Track t -- Из таблицы Track -- Выбираем таблицу track и называем её коротко t
JOIN Album a ON t.album_id = a.id -- Объединяем с таблицей Album (коротко a), где album_id трека совпадает с id альбома
WHERE a.release_year BETWEEN 2019 AND 2020; -- Только альбомы, выпущенные в 2019–2020 годах

--  Средняя продолжительность треков по каждому альбому
SELECT a.title AS album, AVG(t.duration) AS avg_duration
FROM Album a
JOIN Track t ON a.id = t.album_id -- Соединяем с таблицей треков по альбому
GROUP BY a.title; -- Группируем по названию альбома

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

-- Названия альбомов, в которых присутствуют исполнители более чем одного жанра
SELECT DISTINCT al.title AS album
FROM Album al
JOIN ArtistAlbum aa ON al.id = aa.album_id
JOIN ArtistGenre ag ON aa.artist_id = ag.artist_id
GROUP BY al.id, al.title, aa.artist_id 
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







