USE movielista;

-- ----------------------------------- TITLES AND THEIR RATINGS

-- Weighted average function

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

SELECT wavg_rating(3);


CREATE OR REPLACE VIEW title_ratings AS
	SELECT t.id,
		   t.title AS title,
		   round(avg(r.rating)) AS avg_rating,     -- Average rating
		   round(wavg_rating(t.id)) AS wavg_rating -- Weighted average rating
	  FROM titles AS t
			   INNER JOIN rating AS r ON t.id = r.title_id
	 GROUP BY
		 t.id
	 ORDER BY
		 t.id;

-- TOP 10

SELECT title,
	   avg_rating -- Top 10 titles by average rating
  FROM title_ratings
 ORDER BY
	 avg_rating DESC
 LIMIT 10;

SELECT title,
	   wavg_rating -- Top 10 titles by weighted average rating
  FROM title_ratings
 ORDER BY
	 wavg_rating DESC
 LIMIT 10;
