USE movielista;

-- ----------------------------------- Filmography
SELECT name, title, role, release_date
  FROM titles_and_cast
 WHERE c_id = 25
ORDER BY role, release_date DESC;


-- ----------------------------------- Top 5 titles about vampires
SELECT tp.title, tp.rating
  FROM t_profiles tp
		   JOIN titles_and_keywords tak ON tp.t_id = tak.t_id
 WHERE tak.keyword = 'vampire'
 ORDER BY
	 tp.rating DESC
 LIMIT 5;


-- ----------------------------------- All drama TV series
SELECT tp.title, tp.rating
  FROM t_profiles tp
		   JOIN titles_and_genres tag ON tp.t_id = tag.t_id
 WHERE tp.title_type = 'TV Series' AND tag.relevancy > 0
ORDER BY tp.rating DESC , tag.relevancy DESC;


-- ----------------------------------- All titles somehow related to Korea
SELECT title
  FROM titles_and_countries
 WHERE country = 'Korea'

UNION

SELECT tac2.title
  FROM cr_profiles cp
		   JOIN titles_and_countries tac2 ON cp.country = tac2.country
 WHERE tac2.country = 'Korea'
 GROUP BY
	 cp.name

UNION

SELECT tp.title
  FROM t_profiles tp
		   JOIN titles_and_keywords tak ON tp.t_id = tak.t_id
 WHERE tak.keyword = 'dorama';


-- ----------------------------------- Some good titles for kids
SELECT title,
       title_type,
       rars
FROM t_profiles
WHERE (rars = '0+' OR rars = '6+') AND rars != 'NR' AND rating >= 6
ORDER BY rand()
LIMIT 5;
