USE movielista;

-- ----------------------------------- TITLES
SET FOREIGN_KEY_CHECKS = 0;
SELECT @@FOREIGN_KEY_CHECKS;


DROP TRIGGER IF EXISTS title_insert;
DELIMITER //
CREATE TRIGGER title_insert BEFORE INSERT on titles FOR EACH ROW
    BEGIN
INSERT INTO title_info (title_id) VALUES (NEW.id);
	END //
-- INSERT INTO titles (title, original_title) VALUES
DELIMITER ;
SHOW TRIGGERS;

INSERT INTO titles (title, original_title) VALUES
                                               ('1', '1'),
                                               ();




SET FOREIGN_KEY_CHECKS = 1;

