
-------------------------------------------------------


SELECT a.album_title, s.song_title
FROM songs s
JOIN albums a ON s.album_id = a.album_id
ORDER BY a.release_date;


--------------------------------------------------


SELECT s.song_title, 
       (spotify_streams + apple_music_streams + youtube_views) AS total_streams
FROM streaming_stats ss
JOIN songs s ON ss.song_id = s.song_id
ORDER BY total_streams DESC
LIMIT 1;


-------------------------------------------------------------


SELECT s.song_title, ar.artist_name
FROM song_features sf
JOIN songs s ON sf.song_id = s.song_id
JOIN artists ar ON sf.artist_id = ar.artist_id
WHERE ar.artist_name <> 'Asake';



---------------------------------------------------------------


SELECT a.album_title, COUNT(s.song_id) AS total_tracks
FROM albums a
JOIN songs s ON a.album_id = s.album_id
GROUP BY a.album_title;


----------------------------------------------------------------


SELECT s.song_title,
       spotify_streams + apple_music_streams AS total_streams
FROM streaming_stats ss
JOIN songs s ON ss.song_id = s.song_id
ORDER BY total_streams DESC
LIMIT 10;


--------------------------------------------------------------------



SELECT a.album_title,
       SUM(ss.spotify_streams) AS spotify_total,
       SUM(ss.apple_music_streams) AS apple_music_total
FROM albums a
JOIN songs s ON a.album_id = s.album_id
JOIN streaming_stats ss ON s.song_id = ss.song_id
GROUP BY a.album_title
ORDER BY spotify_total DESC;



--
----------------------------------------------------------------------


CREATE VIEW platform_streams AS
SELECT
    s.song_id,
    s.song_title,
    'Spotify' AS platform,
    ss.spotify_streams AS streams
FROM songs s
JOIN streaming_stats ss ON s.song_id = ss.song_id

UNION ALL

SELECT
    s.song_id,
    s.song_title,
    'Apple Music' AS platform,
    ss.apple_music_streams AS streams
FROM songs s
JOIN streaming_stats ss ON s.song_id = ss.song_id;


------------------------------------------------------------

SELECT platform, SUM(streams) AS total_streams
FROM platform_streams
GROUP BY platform;

------------------------------------------------------------

SELECT platform, SUM(streams) AS total_streams
FROM platform_streams
GROUP BY platform;

-----------------------------------------------------------


SELECT a.album_title, ps.platform, SUM(ps.streams) AS total_streams
FROM platform_streams ps
JOIN songs s ON ps.song_id = s.song_id
JOIN albums a ON s.album_id = a.album_id
GROUP BY a.album_title, ps.platform
ORDER BY a.album_title, total_streams DESC;


--------------------------------------------------------------

SELECT *
FROM platform_streams
ORDER BY song_title, platform;

---------------------------------------------------------------

SELECT platform, SUM(streams) AS total_streams
FROM platform_streams
GROUP BY platform;

----------------------------------------------------------------


SELECT platform, song_title, streams
FROM (
    SELECT *,
           RANK() OVER (PARTITION BY platform ORDER BY streams DESC) AS rnk
    FROM platform_streams
) t
WHERE rnk = 1;


----------------------------------------------------------------

SELECT 
    a.album_title,
    SUM(ps.streams) AS total_streams
FROM platform_streams ps
JOIN songs s ON ps.song_id = s.song_id
JOIN albums a ON s.album_id = a.album_id
GROUP BY a.album_title
ORDER BY total_streams DESC;

----------------------------------------------------------------


SELECT 
    a.album_title,
    ROUND(SUM(ps.streams) / COUNT(DISTINCT s.song_id)) AS avg_streams_per_song
FROM platform_streams ps
JOIN songs s ON ps.song_id = s.song_id
JOIN albums a ON s.album_id = a.album_id
GROUP BY a.album_title
ORDER BY avg_streams_per_song DESC;


----------------------------------------------------------------

SELECT 
    a.album_title,
    SUM(ps.streams) AS apple_music_streams
FROM platform_streams ps
JOIN songs s ON ps.song_id = s.song_id
JOIN albums a ON s.album_id = a.album_id
WHERE ps.platform = 'Apple Music'
GROUP BY a.album_title
ORDER BY apple_music_streams DESC;

------------------------------------------------------------------

SELECT a.album_title, COUNT(DISTINCT ac.country_id) AS countries_charted
FROM album_charts ac
JOIN albums a ON ac.album_id = a.album_id
GROUP BY a.album_title
ORDER BY countries_charted DESC;


-------------------------------------------------------------------


SELECT a.album_title, MIN(ac.peak_position) AS best_peak
FROM album_charts ac
JOIN albums a ON ac.album_id = a.album_id
GROUP BY a.album_title
ORDER BY best_peak;

--------------------------------------------------------------------


SELECT 
    a.album_title,
    c.country_name,
    ac.peak_position,
    ac.weeks_on_chart
FROM album_charts ac
JOIN albums a ON ac.album_id = a.album_id
JOIN countries c ON ac.country_id = c.country_id
ORDER BY a.album_title, ac.peak_position;


---------------------------------------------------------------------

SELECT a.album_title, COUNT(*) AS total_chart_entries
FROM album_charts ac
JOIN albums a ON ac.album_id = a.album_id
GROUP BY a.album_title
ORDER BY total_chart_entries DESC;


---------------------------------------------------------------------

SELECT a.album_title, MIN(ac.peak_position) AS best_global_peak
FROM album_charts ac
JOIN albums a ON ac.album_id = a.album_id
GROUP BY a.album_title
ORDER BY best_global_peak;


---------------------------------------------------------------------


SELECT c.region, COUNT(*) AS chart_entries
FROM album_charts ac
JOIN countries c ON ac.country_id = c.country_id
GROUP BY c.region
ORDER BY chart_entries DESC;

----------------------------------------------------------------------

SELECT 
    l.language_name,
    a.album_title,
    MIN(ac.peak_position) AS best_peak
FROM album_charts ac
JOIN albums a ON ac.album_id = a.album_id
JOIN countries c ON ac.country_id = c.country_id
JOIN country_languages cl ON c.country_id = cl.country_id
JOIN languages l ON cl.language_id = l.language_id
GROUP BY l.language_name, a.album_title
ORDER BY l.language_name, best_peak;


--------------------------------------------------------------------------

SELECT 
    l.language_name,
    COUNT(*) AS chart_entries
FROM album_charts ac
JOIN countries c ON ac.country_id = c.country_id
JOIN country_languages cl ON c.country_id = cl.country_id
JOIN languages l ON cl.language_id = l.language_id
GROUP BY l.language_name
ORDER BY chart_entries DESC;

--------------------------------------------------------------------------

SELECT 
    a.album_title,
    l.language_name,
    c.country_name,
    ac.peak_position
FROM album_charts ac
JOIN albums a ON ac.album_id = a.album_id
JOIN countries c ON ac.country_id = c.country_id
JOIN country_languages cl ON c.country_id = cl.country_id
JOIN languages l ON cl.language_id = l.language_id
WHERE l.language_name IN ('Spanish', 'Portuguese')
ORDER BY l.language_name, a.album_title;


