-- ============================
-- PHYL 111 – Modules
-- class_id = 2004
-- ============================

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2004, 'Week 1: Lab 1 – Safety, Spreadsheets & Measurement Part 1', 1, 0);
SET @phyl111_mod1 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2004, 'Week 2: Lab 1 – Measurement Part 2', 2, 0);
SET @phyl111_mod2 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2004, 'Week 3: Lab 2 – Force Table', 3, 0);
SET @phyl111_mod3 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2004, 'Week 4: Lab 3 – Acceleration due to Gravity (Part 1)', 4, 0);
SET @phyl111_mod4 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2004, 'Week 5: Lab 3 – Acceleration due to Gravity (Parts 2 & 3)', 5, 0);
SET @phyl111_mod5 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2004, 'Week 6: Lab 4 – Projectile Motion (Part 1)', 6, 0);
SET @phyl111_mod6 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2004, 'Week 7: Lab 4 – Projectile Motion (Part 2)', 7, 0);
SET @phyl111_mod7 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2004, 'Week 8: Lab 5 – Newton’s Laws', 8, 0);
SET @phyl111_mod8 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2004, 'Week 9: Lab 6 – Inclined Plane', 9, 0);
SET @phyl111_mod9 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2004, 'Week 10: Lab 7 – Circular Motion', 10, 0);
SET @phyl111_mod10 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2004, 'Week 11: Lab 8 – Conservation of Energy', 11, 0);
SET @phyl111_mod11 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2004, 'Week 12: Lab 9 – Torque', 12, 0);
SET @phyl111_mod12 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2004, 'Week 13: Problem Session & Make-Up Labs', 13, 0);
SET @phyl111_mod13 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2004, 'Week 14: Final Lab Exam & Course Reflection', 14, 0);
SET @phyl111_mod14 = LAST_INSERT_ID();

-- ============================
-- PHYL 111 – Assignments
-- class_id = 2004
-- ============================

-- Lab Report 1 – Safety, Excel & Measurement
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2004,
  'Lab Report 1: Safety, Excel & Measurement',
  'lab',
  0.05,
  '2026-01-24 23:59:00',
  40,
  'Group/individual lab report for Lab 1 covering safety procedures, spreadsheet use, and basic measurements.',
  40,
  1
);
SET @phyl111_lab1 = LAST_INSERT_ID();

-- Lab Report 2 – Force Table
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2004,
  'Lab Report 2: Force Table',
  'lab',
  0.05,
  '2026-01-31 23:59:00',
  40,
  'Lab report analyzing vector addition and equilibrium using the force table experiment.',
  40,
  1
);
SET @phyl111_lab2 = LAST_INSERT_ID();

-- Lab Report 3 – Acceleration due to Gravity
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2004,
  'Lab Report 3: Acceleration due to Gravity',
  'lab',
  0.05,
  '2026-02-14 23:59:00',
  40,
  'Combined report for Lab 3 parts 1–3 determining g using different experimental setups.',
  40,
  1
);
SET @phyl111_lab3 = LAST_INSERT_ID();

-- Lab Report 4 – Projectile Motion
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2004,
  'Lab Report 4: Projectile Motion',
  'lab',
  0.05,
  '2026-02-28 23:59:00',
  40,
  'Report for Lab 4 parts 1–2 analyzing projectile motion and comparison with kinematics predictions.',
  40,
  1
);
SET @phyl111_lab4 = LAST_INSERT_ID();

-- Lab Report 5 – Newton''s Laws
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2004,
  'Lab Report 5: Newton''s Laws',
  'lab',
  0.05,
  '2026-03-07 23:59:00',
  40,
  'Report for Lab 5 investigating Newton’s laws using carts, masses, and force sensors.',
  40,
  1
);
SET @phyl111_lab5 = LAST_INSERT_ID();

-- Lab Report 6 – Inclined Plane
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2004,
  'Lab Report 6: Inclined Plane',
  'lab',
  0.05,
  '2026-03-21 23:59:00',
  40,
  'Lab report analyzing motion on an inclined plane and comparison to theoretical predictions.',
  40,
  1
);
SET @phyl111_lab6 = LAST_INSERT_ID();

-- Lab Report 7 – Circular Motion
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2004,
  'Lab Report 7: Circular Motion',
  'lab',
  0.05,
  '2026-03-28 23:59:00',
  40,
  'Report for Lab 7 measuring centripetal force and acceleration in circular motion.',
  40,
  1
);
SET @phyl111_lab7 = LAST_INSERT_ID();

-- Lab Report 8 – Conservation of Energy
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2004,
  'Lab Report 8: Conservation of Energy',
  'lab',
  0.05,
  '2026-04-11 23:59:00',
  40,
  'Lab report on energy transformations and verification of mechanical energy conservation.',
  40,
  1
);
SET @phyl111_lab8 = LAST_INSERT_ID();

-- Lab Report 9 – Torque
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2004,
  'Lab Report 9: Torque',
  'lab',
  0.05,
  '2026-04-18 23:59:00',
  40,
  'Report for Lab 9 exploring torque, rotational equilibrium, and center of mass.',
  40,
  1
);
SET @phyl111_lab9 = LAST_INSERT_ID();

-- Experiential Learning Activity
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2004,
  'Experiential Learning Reflection',
  'project',
  0.10,
  '2026-04-25 23:59:00',
  50,
  'Short reflection connecting a PHYL 111 lab experience to career or real-world applications, supporting experiential learning outcomes.',
  50,
  1
);
SET @phyl111_exp = LAST_INSERT_ID();

-- Participation & Lab Skills
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2004,
  'Participation & Lab Skills',
  'participation',
  0.15,
  '2026-05-02 23:59:00',
  100,
  'Overall participation, teamwork, proper lab procedures, and timely completion of group reports throughout the semester.',
  100,
  1
);
SET @phyl111_part = LAST_INSERT_ID();

-- Final Lab Exam
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2004,
  'Final Lab Exam',
  'exam',
  0.30,
  '2026-05-02 18:00:00',
  100,
  'Comprehensive final lab exam and/or practical evaluation covering all PHYL 111 experiments.',
  100,
  1
);
SET @phyl111_final = LAST_INSERT_ID();

-- ============================
-- PHYL 111 – Module Items
-- ============================

INSERT INTO course_module_items
  (module_id, item_type, title, assignment_id, external_url, position)
VALUES
  (@phyl111_mod1, 'assignment', 'Lab Report 1: Safety, Excel & Measurement', @phyl111_lab1, NULL, 1),

  (@phyl111_mod3, 'assignment', 'Lab Report 2: Force Table', @phyl111_lab2, NULL, 1),

  (@phyl111_mod4, 'assignment', 'Lab Report 3: Acceleration due to Gravity', @phyl111_lab3, NULL, 1),

  (@phyl111_mod6, 'assignment', 'Lab Report 4: Projectile Motion', @phyl111_lab4, NULL, 1),

  (@phyl111_mod8, 'assignment', 'Lab Report 5: Newton''s Laws', @phyl111_lab5, NULL, 1),

  (@phyl111_mod9, 'assignment', 'Lab Report 6: Inclined Plane', @phyl111_lab6, NULL, 1),

  (@phyl111_mod10, 'assignment', 'Lab Report 7: Circular Motion', @phyl111_lab7, NULL, 1),

  (@phyl111_mod11, 'assignment', 'Lab Report 8: Conservation of Energy', @phyl111_lab8, NULL, 1),

  (@phyl111_mod12, 'assignment', 'Lab Report 9: Torque', @phyl111_lab9, NULL, 1),

  (@phyl111_mod13, 'assignment', 'Experiential Learning Reflection', @phyl111_exp, NULL, 1),

  (@phyl111_mod14, 'assignment', 'Participation & Lab Skills', @phyl111_part, NULL, 1),
  (@phyl111_mod14, 'assignment', 'Final Lab Exam', @phyl111_final, NULL, 2);
