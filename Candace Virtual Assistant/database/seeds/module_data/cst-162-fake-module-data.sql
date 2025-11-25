-- ============================
-- CST 162 – Modules (Weeks 1–15)
-- class_id = 2005
-- ============================

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2005, 'Week 1: Course Introduction & Canvas / Java Setup', 1, 0);
SET @cst162_mod1 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2005, 'Week 2: Creating Java Programs & Using Data (Ch. 1–2)', 2, 0);
SET @cst162_mod2 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2005, 'Week 3: Making Decisions (Ch. 5)', 3, 0);
SET @cst162_mod3 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2005, 'Week 4: Semester Exam I – Ch. 1, 2 & 5', 4, 0);
SET @cst162_mod4 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2005, 'Week 5: Methods, Classes & Objects (Ch. 3)', 5, 0);
SET @cst162_mod5 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2005, 'Week 6: More Object Concepts (Ch. 4)', 6, 0);
SET @cst162_mod6 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2005, 'Week 7: Object-Oriented Programming Practice', 7, 0);
SET @cst162_mod7 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2005, 'Week 8: Semester Exam II – Ch. 3 & 4; Intro to Looping', 8, 0);
SET @cst162_mod8 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2005, 'Week 9: Looping (Ch. 6)', 9, 0);
SET @cst162_mod9 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2005, 'Week 10: Arrays (Ch. 8)', 10, 0);
SET @cst162_mod10 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2005, 'Week 11: Advanced Array Concepts (Ch. 9)', 11, 0);
SET @cst162_mod11 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2005, 'Week 12: Semester Exam III – Ch. 6, 8 & 9; Exception Handling (Ch. 12)', 12, 0);
SET @cst162_mod12 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2005, 'Week 13: File Input/Output (Ch. 13)', 13, 0);
SET @cst162_mod13 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2005, 'Week 14: Swing GUIs (Ch. 14) & Final Project Work', 14, 0);
SET @cst162_mod14 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2005, 'Week 15: Final Examination & Course Wrap-Up', 15, 0);
SET @cst162_mod15 = LAST_INSERT_ID();

-- ============================
-- CST 162 – Assignments
-- class_id = 2005
-- ============================

-- Week 2 – Programming Assignment 1: Java Basics
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2005,
  'Programming Assignment 1: Java Basics (Ch. 1–2)',
  'homework',
  0.06,
  '2026-01-30 23:59:00',
  40,
  'Write several small Java programs that compile and run from the command line, demonstrating console I/O and basic variables.',
  40,
  1
);
SET @cst162_a1 = LAST_INSERT_ID();

-- Week 3 – Programming Assignment 2: Decisions
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2005,
  'Programming Assignment 2: Decisions (Ch. 5)',
  'homework',
  0.06,
  '2026-02-06 23:59:00',
  40,
  'Programs that use selection structures (if/else, switch) and logical operators to make decisions.',
  40,
  1
);
SET @cst162_a2 = LAST_INSERT_ID();

-- Week 4 – Semester Exam I (Ch. 1, 2, 5)
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2005,
  'Semester Exam I: Java Basics & Decisions',
  'exam',
  0.12,
  '2026-02-11 18:00:00',
  100,
  'In-class exam covering Chapters 1, 2 and 5: basic Java programs, data, and decision structures.',
  100,
  1
);
SET @cst162_a3 = LAST_INSERT_ID();

-- Week 6–7 – Project 1: Object-Oriented Program
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2005,
  'Project 1: Object-Oriented Java Program',
  'project',
  0.08,
  '2026-02-27 23:59:00',
  80,
  'Design and implement an object-oriented Java application using user-defined classes, methods, constructors, and encapsulation.',
  80,
  1
);
SET @cst162_a4 = LAST_INSERT_ID();

-- Week 8 – Semester Exam II (Ch. 3 & 4)
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2005,
  'Semester Exam II: Classes & Objects',
  'exam',
  0.13,
  '2026-03-13 18:00:00',
  110,
  'Exam on Chapter 3 and 4 topics: methods, classes, objects, overloading, and more object concepts.',
  110,
  1
);
SET @cst162_a5 = LAST_INSERT_ID();

-- Week 9 – Programming Assignment 3: Loops
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2005,
  'Programming Assignment 3: Looping (Ch. 6)',
  'homework',
  0.06,
  '2026-03-20 23:59:00',
  40,
  'Write Java programs using while, do-while, and for loops, including nested loops and sentinel-controlled repetition.',
  40,
  1
);
SET @cst162_a6 = LAST_INSERT_ID();

-- Week 11 – Programming Assignment 4: Arrays & Searching
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2005,
  'Programming Assignment 4: Arrays & Searching (Ch. 8–9)',
  'homework',
  0.06,
  '2026-04-03 23:59:00',
  50,
  'Programs that use one- and two-dimensional arrays, simple searching and sorting algorithms, and array processing.',
  50,
  1
);
SET @cst162_a7 = LAST_INSERT_ID();

-- Week 12 – Semester Exam III (Ch. 6, 8, 9)
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2005,
  'Semester Exam III: Loops & Arrays',
  'exam',
  0.10,
  '2026-04-10 18:00:00',
  100,
  'Exam on Chapters 6, 8 and 9 covering loops, arrays, and advanced array concepts.',
  100,
  1
);
SET @cst162_a8 = LAST_INSERT_ID();

-- Week 13 – Programming Assignment 5: Exceptions & File I/O
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2005,
  'Programming Assignment 5: Exceptions & File I/O (Ch. 12–13)',
  'homework',
  0.08,
  '2026-04-17 23:59:00',
  60,
  'Write programs that use try/catch blocks, exception classes, and text file input/output for persistent storage.',
  60,
  1
);
SET @cst162_a9 = LAST_INSERT_ID();

-- Week 14 – Project 2: GUI Application with Swing
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2005,
  'Project 2: Swing GUI Application',
  'project',
  0.10,
  '2026-04-24 23:59:00',
  120,
  'Final programming project building a small GUI application using Swing components, events, and good OO design.',
  120,
  1
);
SET @cst162_a10 = LAST_INSERT_ID();

-- Week 15 – Final Exam (Ch. 3–14)
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2005,
  'Final Exam: Comprehensive Java & Algorithms',
  'exam',
  0.15,
  '2026-05-01 18:00:00',
  150,
  'Comprehensive final covering Chapters 3–14: methods, classes, loops, arrays, exceptions, file I/O, and Swing.',
  150,
  1
);
SET @cst162_a11 = LAST_INSERT_ID();

-- ============================
-- CST 162 – Module Items
-- ============================

INSERT INTO course_module_items
  (module_id, item_type, title, assignment_id, external_url, position)
VALUES
  -- Early programming assignments
  (@cst162_mod2, 'assignment', 'Programming Assignment 1: Java Basics', @cst162_a1, NULL, 1),
  (@cst162_mod3, 'assignment', 'Programming Assignment 2: Decisions', @cst162_a2, NULL, 1),

  -- Exam I
  (@cst162_mod4, 'assignment', 'Semester Exam I: Java Basics & Decisions', @cst162_a3, NULL, 1),

  -- Object-oriented project
  (@cst162_mod7, 'assignment', 'Project 1: Object-Oriented Java Program', @cst162_a4, NULL, 1),

  -- Exam II
  (@cst162_mod8, 'assignment', 'Semester Exam II: Classes & Objects', @cst162_a5, NULL, 1),

  -- Loops
  (@cst162_mod9, 'assignment', 'Programming Assignment 3: Looping', @cst162_a6, NULL, 1),

  -- Arrays
  (@cst162_mod11, 'assignment', 'Programming Assignment 4: Arrays & Searching', @cst162_a7, NULL, 1),

  -- Exam III
  (@cst162_mod12, 'assignment', 'Semester Exam III: Loops & Arrays', @cst162_a8, NULL, 1),

  -- Exceptions + File I/O
  (@cst162_mod13, 'assignment', 'Programming Assignment 5: Exceptions & File I/O', @cst162_a9, NULL, 1),

  -- GUI Project
  (@cst162_mod14, 'assignment', 'Project 2: Swing GUI Application', @cst162_a10, NULL, 1),

  -- Final exam
  (@cst162_mod15, 'assignment', 'Final Exam: Comprehensive Java & Algorithms', @cst162_a11, NULL, 1);
