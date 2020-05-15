USE movielista;

-- ----------------------------------- TITLE PROFILE

CREATE OR REPLACE ALGORITHM = TEMPTABLE VIEW title_profiles AS
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
			   LEFT OUTER JOIN title_ratings tr ON tr.title = t.title
	 ORDER BY
		 t.id;

-- DROP VIEW IF EXISTS title_profiles;
