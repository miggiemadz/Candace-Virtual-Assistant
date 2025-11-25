USE candace_assistant;

SET SQL_SAFE_UPDATES = 0;

-- Shared password hash for demo student accounts ("student123")
SET @student_pwd_hash := 'scrypt:32768:8:1$gElQ3Ga2wUCGxhRL$31bffa1e8edd85213711561eb8ef5a7558cc0a2d3d229dc12a406aaa9f3104659c64cc945477e87ead00881dfcf3f7bfc8da209efd6e65aa284eb4ad39610d98';

-- =========================================================
-- 1. Core Data Science cohort (besides Alex = 1000001)
--    student_id: 1000002–1000012
--    major_id = 1 assumed to be "A.S. Data Science"
-- =========================================================

INSERT INTO students (
    student_id, student_first_name, student_last_name,
    student_gpa, student_total_credits, major_id, has_account
) VALUES
(1000002, 'Brianna', 'Lopez',     3.40, 14, 1, 1),
(1000003, 'Jordan',  'Patel',     3.20, 14, 1, 1),
(1000004, 'Maya',    'Chen',      3.80, 14, 1, 1),
(1000005, 'Diego',   'Ramirez',   3.10, 14, 1, 1),
(1000006, 'Fatima',  'Khan',      3.50, 14, 1, 1),
(1000007, 'Lucas',   'Nguyen',    3.25, 14, 1, 1),
(1000008, 'Sofia',   'Martinez',  3.60, 14, 1, 1),
(1000009, 'Ethan',   'Park',      3.30, 14, 1, 1),
(1000010, 'Chloe',   'Johnson',   3.45, 14, 1, 1),
(1000011, 'Omar',    'Hassan',    3.15, 14, 1, 1),
(1000012, 'Emily',   'Rogers',    3.70, 14, 1, 1);

-- Matching user accounts (all password = "student123")
INSERT INTO users (email, password_hash, role, student_id) VALUES
('brianna.lopez@candace.local',  @student_pwd_hash, 'student', 1000002),
('jordan.patel@candace.local',   @student_pwd_hash, 'student', 1000003),
('maya.chen@candace.local',      @student_pwd_hash, 'student', 1000004),
('diego.ramirez@candace.local',  @student_pwd_hash, 'student', 1000005),
('fatima.khan@candace.local',    @student_pwd_hash, 'student', 1000006),
('lucas.nguyen@candace.local',   @student_pwd_hash, 'student', 1000007),
('sofia.martinez@candace.local', @student_pwd_hash, 'student', 1000008),
('ethan.park@candace.local',     @student_pwd_hash, 'student', 1000009),
('chloe.johnson@candace.local',  @student_pwd_hash, 'student', 1000010),
('omar.hassan@candace.local',    @student_pwd_hash, 'student', 1000011),
('emily.rogers@candace.local',   @student_pwd_hash, 'student', 1000012);

-- =========================================================
-- 2. Extra non-DS students (to make rosters look realistic)
--    student_id: 1000013–1000016
-- =========================================================

INSERT INTO students (
    student_id, student_first_name, student_last_name,
    student_gpa, student_total_credits, major_id, has_account
) VALUES
(1000013, 'Liam',   'Brooks',   3.10, 12, NULL, 1),  -- undecided / gen-ed
(1000014, 'Ava',    'Morales',  3.25, 12, NULL, 1),  -- social science-ish
(1000015, 'Noah',   'Kim',      3.35, 12, NULL, 1),  -- physics/engineering leaning
(1000016, 'Grace',  'Howard',   3.50, 12, NULL, 1);

INSERT INTO users (email, password_hash, role, student_id) VALUES
('liam.brooks@candace.local',   @student_pwd_hash, 'student', 1000013),
('ava.morales@candace.local',   @student_pwd_hash, 'student', 1000014),
('noah.kim@candace.local',      @student_pwd_hash, 'student', 1000015),
('grace.howard@candace.local',  @student_pwd_hash, 'student', 1000016);

-- =========================================================
-- 3. Enrollments (schedule) – Canvas-style rosters
--    Use INSERT IGNORE so we don't blow up if Alex or others
--    already have some schedule rows.
-- =========================================================

-- Helper: DS cohort = Alex (1000001) + 1000002–1000012
-- Cohort takes *all* 9 classes (Fall + Spring 1st-year)
INSERT IGNORE INTO schedule (student_id, class_id) VALUES
  -- Alex
  (1000001, 1001), (1000001, 1002), (1000001, 1003), (1000001, 1004),
  (1000001, 2001), (1000001, 2002), (1000001, 2003), (1000001, 2004), (1000001, 2005),

  -- Brianna
  (1000002, 1001), (1000002, 1002), (1000002, 1003), (1000002, 1004),
  (1000002, 2001), (1000002, 2002), (1000002, 2003), (1000002, 2004), (1000002, 2005),

  -- Jordan
  (1000003, 1001), (1000003, 1002), (1000003, 1003), (1000003, 1004),
  (1000003, 2001), (1000003, 2002), (1000003, 2003), (1000003, 2004), (1000003, 2005),

  -- Maya
  (1000004, 1001), (1000004, 1002), (1000004, 1003), (1000004, 1004),
  (1000004, 2001), (1000004, 2002), (1000004, 2003), (1000004, 2004), (1000004, 2005),

  -- Diego
  (1000005, 1001), (1000005, 1002), (1000005, 1003), (1000005, 1004),
  (1000005, 2001), (1000005, 2002), (1000005, 2003), (1000005, 2004), (1000005, 2005),

  -- Fatima
  (1000006, 1001), (1000006, 1002), (1000006, 1003), (1000006, 1004),
  (1000006, 2001), (1000006, 2002), (1000006, 2003), (1000006, 2004), (1000006, 2005),

  -- Lucas
  (1000007, 1001), (1000007, 1002), (1000007, 1003), (1000007, 1004),
  (1000007, 2001), (1000007, 2002), (1000007, 2003), (1000007, 2004), (1000007, 2005),

  -- Sofia
  (1000008, 1001), (1000008, 1002), (1000008, 1003), (1000008, 1004),
  (1000008, 2001), (1000008, 2002), (1000008, 2003), (1000008, 2004), (1000008, 2005),

  -- Ethan
  (1000009, 1001), (1000009, 1002), (1000009, 1003), (1000009, 1004),
  (1000009, 2001), (1000009, 2002), (1000009, 2003), (1000009, 2004), (1000009, 2005),

  -- Chloe
  (1000010, 1001), (1000010, 1002), (1000010, 1003), (1000010, 1004),
  (1000010, 2001), (1000010, 2002), (1000010, 2003), (1000010, 2004), (1000010, 2005),

  -- Omar
  (1000011, 1001), (1000011, 1002), (1000011, 1003), (1000011, 1004),
  (1000011, 2001), (1000011, 2002), (1000011, 2003), (1000011, 2004), (1000011, 2005),

  -- Emily
  (1000012, 1001), (1000012, 1002), (1000012, 1003), (1000012, 1004),
  (1000012, 2001), (1000012, 2002), (1000012, 2003), (1000012, 2004), (1000012, 2005);

-- ---------------------------------------------------------
-- Extra students:
-- Liam & Ava: just in gen-eds + calculus (ENG101, PSY101, MAT171)
-- Noah & Grace: spring STEM heavy (MAT172, PHY111, PHYL111)
-- ---------------------------------------------------------

INSERT IGNORE INTO schedule (student_id, class_id) VALUES
  -- Liam (gen-ed + calculus I only)
  (1000013, 1001),
  (1000013, 1002),
  (1000013, 1003),

  -- Ava (similar, but also in CST-161)
  (1000014, 1001),
  (1000014, 1002),
  (1000014, 1003),
  (1000014, 1004),

  -- Noah (spring physics + calc II)
  (1000015, 2002),
  (1000015, 2003),
  (1000015, 2004),

  -- Grace (spring physics + calc II + CST-162)
  (1000016, 2002),
  (1000016, 2003),
  (1000016, 2004),
  (1000016, 2005);

SET SQL_SAFE_UPDATES = 1;
