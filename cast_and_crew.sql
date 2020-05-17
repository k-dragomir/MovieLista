USE movielista;

-- ----------------------------------- VIEW

CREATE OR REPLACE VIEW view_cast AS
	SELECT c.id AS c_id,
		   concat_ws(' ', c.first_name, c.last_name) AS name,
		   r.id AS r_id,
		   r.role,
		   t.id AS t_id,
		   t.title,
		   ti.release_date
	  FROM creators c
			   INNER JOIN cast_and_crew cac ON c.id = cac.creator_id
			   INNER JOIN titles t ON cac.title_id = t.id
			   INNER JOIN roles r ON cac.role_id = r.id
			   INNER JOIN title_info ti ON t.id = ti.title_id
	 ORDER BY
		 c.id
;

-- ----------------------------------- COMMON SELECT QUERY: filmography
SELECT name, title, role, release_date
  FROM view_cast
 WHERE c_id = 23
ORDER BY role, release_date DESC;

-- ----------------------------------- COMMON SELECT QUERY: title cast and crew
SELECT title, role, name
  FROM view_cast
 WHERE t_id = 23
ORDER BY role;