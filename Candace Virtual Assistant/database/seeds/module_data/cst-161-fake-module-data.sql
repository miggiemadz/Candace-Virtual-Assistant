SHOW COLUMNS FROM course_modules;
SHOW COLUMNS FROM assignments;
SHOW COLUMNS FROM course_module_items;

-- ============================
-- CST 161 - Modules (Weeks 1–15)
-- course_id = 104
-- ============================

-- Week 1: Orientation & Canvas
INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (
  1004,
  'Week 1: Course Introduction & Canvas Orientation',
  1,
  0
);
SET @cst161_mod1 = LAST_INSERT_ID();

-- Week 2: Intro to Python + Ethics
INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (
  1004,
  'Week 2: Intro to Python & Cybersecurity Ethics',
  2,
  0
);
SET @cst161_mod2 = LAST_INSERT_ID();

-- Week 3: Variables & Expressions
INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (
  1004,
  'Week 3: Variables & Expressions',
  3,
  0
);
SET @cst161_mod3 = LAST_INSERT_ID();

-- Week 4: Selection / Decision Structures
INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (
  1004,
  'Week 4: Selection & Decision Structures',
  4,
  0
);
SET @cst161_mod4 = LAST_INSERT_ID();

-- Week 5: Review & Exam I (Ch. 1–3)
INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (
  1004,
  'Week 5: Review & Semester Exam I',
  5,
  0
);
SET @cst161_mod5 = LAST_INSERT_ID();

-- Week 6: Loops I
INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (
  1004,
  'Week 6: Loops I – While & For',
  6,
  0
);
SET @cst161_mod6 = LAST_INSERT_ID();

-- Week 7: Loops II & Intro to Lists
INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (
  1004,
  'Week 7: Loops II & Intro to Lists',
  7,
  0
);
SET @cst161_mod7 = LAST_INSERT_ID();

-- Week 8: Lists & Dictionaries
INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (
  1004,
  'Week 8: Lists & Dictionaries',
  8,
  0
);
SET @cst161_mod8 = LAST_INSERT_ID();

-- Week 9: Number Systems
INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (
  1004,
  'Week 9: Number Systems',
  9,
  0
);
SET @cst161_mod9 = LAST_INSERT_ID();

-- Week 10: Semester Exam II (Ch. 4–6 + Number Systems)
INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (
  1004,
  'Week 10: Review & Semester Exam II',
  10,
  0
);
SET @cst161_mod10 = LAST_INSERT_ID();

-- Week 11: Computer Architecture & Digital Logic
INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (
  1004,
  'Week 11: Computer Architecture & Digital Logic',
  11,
  0
);
SET @cst161_mod11 = LAST_INSERT_ID();

-- Week 12: Files & Strings
INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (
  1004,
  'Week 12: File I/O & Strings',
  12,
  0
);
SET @cst161_mod12 = LAST_INSERT_ID();

-- Week 13: Functions & Classes
INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (
  1004,
  'Week 13: Functions & Classes',
  13,
  0
);
SET @cst161_mod13 = LAST_INSERT_ID();

-- Week 14: Exceptions & Robust Programs
INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (
  1004,
  'Week 14: Exceptions & Robust Programs',
  14,
  0
);
SET @cst161_mod14 = LAST_INSERT_ID();

-- Week 15: Final Exam & Course Wrap-Up
INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (
  1004,
  'Week 15: Final Exam & Wrap-Up',
  15,
  0
);
SET @cst161_mod15 = LAST_INSERT_ID();

-- ============================
-- CST 161 - Assignments
-- class_id = 1004
-- ============================

INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES
(
  1004,
  'Getting Started: Canvas & zyBooks Setup',
  'homework',
  0.03,
  '2025-09-05 23:59:00',
  20,
  'Confirm access to Canvas and zyBooks, review the syllabus, and submit the introductory survey.',
  20,
  1
);
SET @cst161_a1 = LAST_INSERT_ID();

INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES
(
  1004,
  'Lab 1: Intro to Python & Ethics Reflection',
  'lab',
  0.05,
  '2025-09-12 23:59:00',
  40,
  'Write and run your first simple Python programs and submit a short reflection on the ACM Code of Ethics.',
  40,
  1
);
SET @cst161_a2 = LAST_INSERT_ID();

INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES
(
  1004,
  'Homework 1: Variables & Expressions',
  'homework',
  0.05,
  '2025-09-19 23:59:00',
  40,
  'Solve practice problems involving variables, expressions, and basic I/O in Python.',
  40,
  1
);
SET @cst161_a3 = LAST_INSERT_ID();

INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES
(
  1004,
  'Homework 2: Decision Structures',
  'homework',
  0.05,
  '2025-09-26 23:59:00',
  40,
  'Write programs that use if/elif/else to implement basic decision-making logic.',
  40,
  1
);
SET @cst161_a4 = LAST_INSERT_ID();

INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES
(
  1004,
  'Semester Exam I: Chapters 1–3',
  'exam',
  0.12,
  '2025-09-30 18:00:00',
  100,
  'In-class exam covering introduction to Python, variables and expressions, and decision structures.',
  100,
  1
);
SET @cst161_a5 = LAST_INSERT_ID();

INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES
(
  1004,
  'Homework 3: Loops',
  'homework',
  0.06,
  '2025-10-10 23:59:00',
  50,
  'Practice using while and for loops to solve repetition problems.',
  50,
  1
);
SET @cst161_a6 = LAST_INSERT_ID();

INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES
(
  1004,
  'Project 1: Lists & Dictionaries Mini-Project',
  'project',
  0.10,
  '2025-10-24 23:59:00',
  100,
  'Build a small Python application that stores and processes data using lists and dictionaries.',
  100,
  1
);
SET @cst161_a7 = LAST_INSERT_ID();

INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES
(
  1004,
  'Quiz: Number Systems',
  'quiz',
  0.04,
  '2025-10-31 23:59:00',
  30,
  'Short quiz on binary, octal, decimal, and hexadecimal representations and conversions.',
  30,
  1
);
SET @cst161_a8 = LAST_INSERT_ID();

INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES
(
  1004,
  'Semester Exam II: Loops, Data Structures & Number Systems',
  'exam',
  0.15,
  '2025-11-05 18:00:00',
  120,
  'Second semester exam covering loops, lists/dictionaries, and number systems.',
  120,
  1
);
SET @cst161_a9 = LAST_INSERT_ID();

INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES
(
  1004,
  'Homework 4: Files, Strings & Exceptions',
  'homework',
  0.07,
  '2025-11-19 23:59:00',
  60,
  'Write programs that read/write text files, process strings, and use basic exception handling.',
  60,
  1
);
SET @cst161_a10 = LAST_INSERT_ID();

INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES
(
  1004,
  'Project 2: Final Programming Project',
  'project',
  0.13,
  '2025-12-03 23:59:00',
  150,
  'Design and implement a small Python program that ties together course topics.',
  150,
  1
);
SET @cst161_a11 = LAST_INSERT_ID();

INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES
(
  1004,
  'Final Exam: Comprehensive',
  'exam',
  0.15,
  '2025-12-10 18:00:00',
  150,
  'Comprehensive final exam covering Chapters 1–10 plus number systems and digital logic.',
  150,
  1
);
SET @cst161_a12 = LAST_INSERT_ID();

-- ============================
-- CST 161 - Module Items
-- ============================

INSERT INTO course_module_items (module_id, item_type, title, assignment_id, external_url, position) VALUES
  (@cst161_mod1, 'assignment', 'Getting Started: Canvas & zyBooks Setup', @cst161_a1, NULL, 1),
  (@cst161_mod2, 'assignment', 'Lab 1: Intro to Python & Ethics Reflection', @cst161_a2, NULL, 1),
  (@cst161_mod3, 'assignment', 'Homework 1: Variables & Expressions', @cst161_a3, NULL, 1),
  (@cst161_mod4, 'assignment', 'Homework 2: Decision Structures', @cst161_a4, NULL, 1),
  (@cst161_mod5, 'assignment', 'Semester Exam I: Chapters 1–3', @cst161_a5, NULL, 1),
  (@cst161_mod6, 'assignment', 'Homework 3: Loops', @cst161_a6, NULL, 1),
  (@cst161_mod8, 'assignment', 'Project 1: Lists & Dictionaries Mini-Project', @cst161_a7, NULL, 1),
  (@cst161_mod9, 'assignment', 'Quiz: Number Systems', @cst161_a8, NULL, 1),
  (@cst161_mod10,'assignment', 'Semester Exam II', @cst161_a9, NULL, 1),
  (@cst161_mod12,'assignment', 'Homework 4: Files, Strings & Exceptions', @cst161_a10, NULL, 1),
  (@cst161_mod13,'assignment', 'Project 2: Final Programming Project', @cst161_a11, NULL, 1),
  (@cst161_mod15,'assignment', 'Final Exam: Comprehensive', @cst161_a12, NULL, 1);


