USE movielista;

-- ----------------------------------- TITLE PROFILE

CREATE OR REPLACE VIEW title_profile AS
SELECT ti.poster,
	   t.title,
	   tr.wavg_rating,
	   t.original_title,
	   tt.title_type,
	   ti.tagline,
	   ti.synopsis,
	   ti.release_date,
	   ti.rars
  FROM titles AS t
		   INNER JOIN title_info ti ON t.id = ti.title_id
		   INNER JOIN title_types tt ON ti.title_type_id = tt.id
		   INNER JOIN title_ratings tr ON tr.title = t.title
 WHERE t.id = 1;

-- ----------------------------------- CREATOR PROFILE

CREATE OR REPLACE VIEW creator_profile AS
SELECT concat(p.first_name, ' ', p.last_name) AS full_name,
	   p.date_of_birth,
	   p.gender,
	   c.country,
	   concat(r.role, ' - ', t.title) AS career
  FROM people AS p
		   INNER JOIN title_cast_crew tcc ON p.id = tcc.people_id
		   INNER JOIN countries c ON p.country_id = c.id
		   INNER JOIN roles r ON tcc.role_id = r.id
		   INNER JOIN titles t ON tcc.title_id = t.id
 WHERE p.id = 22;




