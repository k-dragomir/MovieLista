USE movielista;

-- ----------------------------------- TITLES PROFILES view

CREATE OR REPLACE ALGORITHM = TEMPTABLE VIEW t_profiles AS
	SELECT t.id AS title_id,
		   t.title,
		   t.original_title,
		   tt.id AS type_id,
		   tt.title_type,
		   ti.poster,
		   ti.tagline,
		   ti.synopsis,
		   ti.release_date,
		   ti.rars
	  FROM titles AS t
			   INNER JOIN title_info ti ON t.id = ti.title_id
			   INNER JOIN title_types tt ON ti.title_type_id = tt.id
	 ORDER BY
		 t.id;
-- DROP VIEW IF EXISTS t_profiles;



-- ----------------------------------- USERS PROFILES view
CREATE OR REPLACE VIEW u_profiles AS
	SELECT u.id,
		   concat_ws(', ', up.first_name, up.last_name) AS name,
		   u.username,
		   u.phone_number,
		   u.email,
		   up.avatar,
		   up.date_of_birth,
		   TIMESTAMPDIFF(YEAR, up.date_of_birth, NOW()) AS age,
		   CASE (up.gender)
			   WHEN 'm' THEN 'male'
			   WHEN 'f' THEN 'female'
			   WHEN 'nb' THEN 'non-binary'
			   WHEN 'ud' THEN 'undefined'
			   END AS gender,
		   c.country,
		   up.about
	  FROM users u
			   INNER JOIN user_profiles up ON u.id = up.user_id
			   INNER JOIN countries c ON up.country_id = c.id;
-- DROP VIEW IF EXISTS u_profiles;
