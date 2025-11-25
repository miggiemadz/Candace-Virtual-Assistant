SET SQL_SAFE_UPDATES = 0;
SET FOREIGN_KEY_CHECKS = 0;

-- ==========================================
-- PROFESSORS (capture IDs as we insert)
-- ==========================================

INSERT INTO professors (professor_first_name, professor_last_name, department)
VALUES ('Linda', 'Morales', 'English');
SET @prof_eng101 = LAST_INSERT_ID();

INSERT INTO professors (professor_first_name, professor_last_name, department)
VALUES ('Stephen', 'Price', 'Psychology');
SET @prof_psy101 = LAST_INSERT_ID();

INSERT INTO professors (professor_first_name, professor_last_name, department)
VALUES ('James', 'Patel', 'Mathematics');
SET @prof_mat171 = LAST_INSERT_ID();

INSERT INTO professors (professor_first_name, professor_last_name, department)
VALUES ('Rebecca', 'Cho', 'Mathematics');
SET @prof_mat172 = LAST_INSERT_ID();

INSERT INTO professors (professor_first_name, professor_last_name, department)
VALUES ('Alan', 'Greene', 'Computer Science');
SET @prof_cst161 = LAST_INSERT_ID();

INSERT INTO professors (professor_first_name, professor_last_name, department)
VALUES ('Nicole', 'Alvarez', 'Computer Science');
SET @prof_cst162 = LAST_INSERT_ID();

INSERT INTO professors (professor_first_name, professor_last_name, department)
VALUES ('Peter', 'Dunn', 'Physics');
SET @prof_phy111 = LAST_INSERT_ID();

INSERT INTO professors (professor_first_name, professor_last_name, department)
VALUES ('Hannah', 'Singh', 'Physics');
SET @prof_phyl111 = LAST_INSERT_ID();

INSERT INTO professors (professor_first_name, professor_last_name, department)
VALUES ('Maria', 'Sanchez', 'Computer Science');
SET @prof_extra = LAST_INSERT_ID();

-- ==========================================
-- CREATE USER ACCOUNTS FOR PROFESSORS
-- (use a real hash here; this is just a placeholder)
-- ==========================================

INSERT INTO users (email, password_hash, role, professor_id) VALUES
('linda.morales@candace.local',  '$2b$12$abcdefghijklmnopqrstuv', 'instructor', @prof_eng101),
('stephen.price@candace.local', '$2b$12$abcdefghijklmnopqrstuv', 'instructor', @prof_psy101),
('james.patel@candace.local',   '$2b$12$abcdefghijklmnopqrstuv', 'instructor', @prof_mat171),
('rebecca.cho@candace.local',   '$2b$12$abcdefghijklmnopqrstuv', 'instructor', @prof_mat172),
('alan.greene@candace.local',   '$2b$12$abcdefghijklmnopqrstuv', 'instructor', @prof_cst161),
('nicole.alvarez@candace.local','$2b$12$abcdefghijklmnopqrstuv', 'instructor', @prof_cst162),
('peter.dunn@candace.local',    '$2b$12$abcdefghijklmnopqrstuv', 'instructor', @prof_phy111),
('hannah.singh@candace.local',  '$2b$12$abcdefghijklmnopqrstuv', 'instructor', @prof_phyl111),
('maria.sanchez@candace.local', '$2b$12$abcdefghijklmnopqrstuv', 'instructor', @prof_extra);

-- ==========================================
-- ASSIGN PROFESSORS TO CLASSES
-- ==========================================

UPDATE classes SET professor_id = @prof_eng101  WHERE class_id = 1001;  -- ENG 101
UPDATE classes SET professor_id = @prof_eng101  WHERE class_id = 1002;  -- ENG 102
UPDATE classes SET professor_id = @prof_mat171  WHERE class_id = 1003;  -- MAT 171
UPDATE classes SET professor_id = @prof_cst161  WHERE class_id = 1004;  -- CST 161
UPDATE classes SET professor_id = @prof_psy101  WHERE class_id = 2001;  -- PSY 101
UPDATE classes SET professor_id = @prof_mat172  WHERE class_id = 2002;  -- MAT 172
UPDATE classes SET professor_id = @prof_phy111  WHERE class_id = 2003;  -- PHY 111
UPDATE classes SET professor_id = @prof_phyl111 WHERE class_id = 2004;  -- PHYL 111
UPDATE classes SET professor_id = @prof_cst162  WHERE class_id = 2005;  -- CST 162;

SET FOREIGN_KEY_CHECKS = 1;
SET SQL_SAFE_UPDATES = 1;
