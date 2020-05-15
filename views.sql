USE movielista;

-- ----------------------------------- FUNCTIONS

-- Функция расчета средневзвешенного рейтинга
DROP FUNCTION IF EXISTS wavg_rating;
DELIMITER //
CREATE FUNCTION wavg_rating(t_id INT UNSIGNED)
	RETURNS FLOAT UNSIGNED DETERMINISTIC
BEGIN
	DECLARE rate1 INT UNSIGNED;
	DECLARE rate2 INT UNSIGNED;
	DECLARE rate3 INT UNSIGNED;
	DECLARE rate4 INT UNSIGNED;
	DECLARE rate5 INT UNSIGNED;
	DECLARE rate6 INT UNSIGNED;
	DECLARE rate7 INT UNSIGNED;
	DECLARE rate8 INT UNSIGNED;
	DECLARE rate9 INT UNSIGNED;
	DECLARE rate10 INT UNSIGNED;

	DECLARE num1 INT UNSIGNED;
	DECLARE num2 INT UNSIGNED;
	DECLARE num3 INT UNSIGNED;
	DECLARE num4 INT UNSIGNED;
	DECLARE num5 INT UNSIGNED;
	DECLARE num6 INT UNSIGNED;
	DECLARE num7 INT UNSIGNED;
	DECLARE num8 INT UNSIGNED;
	DECLARE num9 INT UNSIGNED;
	DECLARE num10 INT UNSIGNED;

	SET rate1 = 1;
	SET rate2 = 2;
	SET rate3 = 3;
	SET rate4 = 4;
	SET rate5 = 5;
	SET rate6 = 6;
	SET rate7 = 7;
	SET rate8 = 8;
	SET rate9 = 9;
	SET rate10 = 10;

	SET num1 = (SELECT count(*) FROM rating WHERE rating = rate1 AND title_id = t_id);
	SET num2 = (SELECT count(*) FROM rating WHERE rating = rate2 AND title_id = t_id);
	SET num3 = (SELECT count(*) FROM rating WHERE rating = rate3 AND title_id = t_id);
	SET num4 = (SELECT count(*) FROM rating WHERE rating = rate4 AND title_id = t_id);
	SET num5 = (SELECT count(*) FROM rating WHERE rating = rate5 AND title_id = t_id);
	SET num6 = (SELECT count(*) FROM rating WHERE rating = rate6 AND title_id = t_id);
	SET num7 = (SELECT count(*) FROM rating WHERE rating = rate7 AND title_id = t_id);
	SET num8 = (SELECT count(*) FROM rating WHERE rating = rate8 AND title_id = t_id);
	SET num9 = (SELECT count(*) FROM rating WHERE rating = rate9 AND title_id = t_id);
	SET num10 = (SELECT count(*) FROM rating WHERE rating = rate10 AND title_id = t_id);

	RETURN (rate1 * num1 + rate2 * num2 + rate3 * num3 + rate4 * num4 + rate5 * num5 +
			rate6 * num6 + rate7 * num7 + rate8 * num8 + rate9 * num9 + rate10 * num10)
		/ (num1 + num2 + num3 + num4 + num5 + num6 + num7 + num8 + num9 + num10);
END;
//
DELIMITER ;

-- Функция расчета соответствия ключевого слова фильму (по пользовательским голосованиям)
DROP FUNCTION IF EXISTS keywords;
DELIMITER //
CREATE FUNCTION keywords(t_id INT, k_id INT)
	RETURNS INT DETERMINISTIC
BEGIN
	RETURN (SELECT 2 * plus_tag.c - all_tags.c
			  FROM (
					   SELECT count(vote) AS c
						 FROM title_keyword
						WHERE vote = 1 AND title_id = t_id AND keyword_id = k_id
				   ) AS plus_tag
					   JOIN (SELECT count(vote) AS c FROM title_keyword WHERE title_id = t_id AND keyword_id = k_id
							) AS all_tags
		   );
END;
//
DELIMITER ;

-- Функция расчета соответствия жанра фильму (по пользовательским голосованиям)
DROP FUNCTION IF EXISTS genres;
DELIMITER //
CREATE FUNCTION genres(t_id INT, g_id INT)
	RETURNS INT DETERMINISTIC
BEGIN
	RETURN (SELECT 2 * plus_tag.c - all_tags.c
			  FROM (
					   SELECT count(vote) AS c
						 FROM title_genre
						WHERE vote = 1 AND title_id = t_id AND genre_id = g_id
				   ) AS plus_tag
					   JOIN (SELECT count(vote) AS c FROM title_genre WHERE title_id = t_id AND genre_id = g_id
							) AS all_tags
		   );
END;
//
DELIMITER ;


-- ----------------------------------- RATINGS view

CREATE OR REPLACE ALGORITHM = TEMPTABLE VIEW t_ratings AS
	SELECT t.id,
		   t.title AS title,
		   r.avg_rating,
		   r.wavg_rating,
		   r.count
	  FROM titles AS t
			   LEFT JOIN (SELECT title_id,
								 round(avg(rating)) AS avg_rating,
								 round(wavg_rating(title_id)) AS wavg_rating,
								 count(rating) AS count
							FROM rating
						   GROUP BY title_id
						 ) AS r ON r.title_id = t.id
	 ORDER BY
		 t.id;

-- TOP 10

SELECT title,
	   avg_rating -- Top 10 titles by average rating
  FROM t_ratings
 ORDER BY
	 avg_rating DESC
 LIMIT 10;

SELECT title,
	   wavg_rating -- Top 10 titles by weighted average rating
  FROM t_ratings
 ORDER BY
	 wavg_rating DESC
 LIMIT 10;

-- DROP VIEW IF EXISTS t_ratings;

-- ----------------------------------- TITLE PROFILES view

CREATE OR REPLACE ALGORITHM = TEMPTABLE VIEW t_profiles AS
	SELECT t.id,
		   t.title,
		   t.original_title,
		   tt.title_type,
		   tr.avg_rating,
		   tr.wavg_rating,
		   ti.poster,
		   ti.tagline,
		   ti.synopsis,
		   ti.release_date,
		   ti.rars
	  FROM titles AS t
			   INNER JOIN title_info ti ON t.id = ti.title_id
			   INNER JOIN title_types tt ON ti.title_type_id = tt.id
			   LEFT OUTER JOIN t_ratings tr ON tr.title = t.title
	 ORDER BY
		 t.id;

-- ----------------------------------- TITLE KEYWORDS view

CREATE OR REPLACE VIEW t_keywords AS
	SELECT t.id, t.title, k.keyword
	  FROM titles t
			   JOIN title_keyword tk ON t.id = tk.title_id
			   JOIN keywords k ON tk.keyword_id = k.id
	 WHERE keywords(tk.title_id, tk.keyword_id) > 0
	 GROUP BY
		 tk.title_id, tk.keyword_id
	 ORDER BY
		 tk.title_id;

-- ----------------------------------- TITLE GENRES view

CREATE OR REPLACE VIEW t_genres AS
	SELECT t.id, t.title, g.genre
	  FROM titles t
			   JOIN title_genre tg ON t.id = tg.title_id
			   JOIN genres g ON tg.genre_id = g.id
	 WHERE genres(tg.title_id, tg.genre_id) > 0
	 GROUP BY
		 tg.title_id, tg.genre_id
	 ORDER BY
		 tg.title_id;