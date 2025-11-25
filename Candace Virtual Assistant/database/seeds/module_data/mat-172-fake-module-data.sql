-- ============================
-- MAT 172 – Modules (Weeks 1–15)
-- class_id = 2002
-- ============================

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2002, 'Week 1: Bases Other Than e, L’Hôpital’s Rule, Inverse Trig', 1, 0);
SET @mat172_mod1 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2002, 'Week 2: Inverse Trig Integration, Hyperbolic Functions, Diff Eq', 2, 0);
SET @mat172_mod2 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2002, 'Week 3: Growth & Decay, Review & Test 1', 3, 0);
SET @mat172_mod3 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2002, 'Week 4: Area Between Curves, Disk Method', 4, 0);
SET @mat172_mod4 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2002, 'Week 5: Shell Method, Arc Length, Work', 5, 0);
SET @mat172_mod5 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2002, 'Week 6: Centroids & Review for Test 2', 6, 0);
SET @mat172_mod6 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2002, 'Week 7: Basic Integration Rules, Integration by Parts', 7, 0);
SET @mat172_mod7 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2002, 'Week 8: Trig Integrals & Trig Substitution', 8, 0);
SET @mat172_mod8 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2002, 'Week 9: Partial Fractions & Improper Integrals; Test 3', 9, 0);
SET @mat172_mod9 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2002, 'Week 10: Sequences & Series', 10, 0);
SET @mat172_mod10 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2002, 'Week 11: Integral Test, Comparison Tests, Alternating Series', 11, 0);
SET @mat172_mod11 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2002, 'Week 12: Ratio/Root Tests, Taylor Polynomials & Approximations', 12, 0);
SET @mat172_mod12 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2002, 'Week 13: Power Series & Representations', 13, 0);
SET @mat172_mod13 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2002, 'Week 14: Taylor & Maclaurin Series; Review for Test 4', 14, 0);
SET @mat172_mod14 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2002, 'Week 15: Conics, Parametric Equations & Final Review', 15, 0);
SET @mat172_mod15 = LAST_INSERT_ID();

-- ============================
-- MAT 172 – Assignments
-- class_id = 2002
-- ============================

-- Week 1 Quiz – Limits, Bases Other Than e, L'Hôpital
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2002,
  'Quiz 1: Bases, L’Hôpital’s Rule, Inverse Trig',
  'quiz',
  0.04,
  '2026-01-24 23:59:00',
  25,
  'Covers exponential bases other than e, L’Hôpital’s Rule, and inverse trig differentiation.',
  25,
  1
);
SET @mat172_a1 = LAST_INSERT_ID();

-- Week 3 – Test 1 (Unit I)
INSERT INTO assignments (
  class_id, assignment_name, assignment_type, assignment_score_weight,
  due_at, max_points, description, points, is_published
) VALUES (
  2002,
  'Unit Test 1: Limits, Inverse Trig, Hyperbolic, Diff Eq',
  'exam',
  0.12,
  '2026-02-07 18:00:00',
  100,
  'Covers Chapters 5.5–5.9 and 6.2: bases, indeterminate forms, inverse trig, hyperbolic functions, growth & decay.',
  100,
  1
);
SET @mat172_a2 = LAST_INSERT_ID();

-- Week 5 – Homework on Applications of Integration
INSERT INTO assignments (
  class_id, assignment_name, assignment_type, assignment_score_weight,
  due_at, max_points, description, points, is_published
) VALUES (
  2002,
  'Homework 1: Areas, Volumes, Work, Centroids',
  'homework',
  0.08,
  '2026-02-21 23:59:00',
  50,
  'Practice problems on area between curves, disk/shell methods, arc length, work, and centroids.',
  50,
  1
);
SET @mat172_a3 = LAST_INSERT_ID();

-- Week 6 – Test 2 (Unit II)
INSERT INTO assignments (
  class_id, assignment_name, assignment_type, assignment_score_weight,
  due_at, max_points, description, points, is_published
) VALUES (
  2002,
  'Unit Test 2: Applications of Integration',
  'exam',
  0.14,
  '2026-02-28 18:00:00',
  120,
  'Covers Chapter 7 (Areas, Volumes, Work, Centroids).',
  120,
  1
);
SET @mat172_a4 = LAST_INSERT_ID();

-- Week 8 – Homework on Advanced Integration Techniques
INSERT INTO assignments (
  class_id, assignment_name, assignment_type, assignment_score_weight,
  due_at, max_points, description, points, is_published
) VALUES (
  2002,
  'Homework 2: Integration Techniques (Parts, Trig, Substitution)',
  'homework',
  0.08,
  '2026-03-14 23:59:00',
  60,
  'Problems on integration by parts, trig integrals, trig substitution, and partial fractions.',
  60,
  1
);
SET @mat172_a5 = LAST_INSERT_ID();

-- Week 9 – Test 3 (Unit III)
INSERT INTO assignments (
  class_id, assignment_name, assignment_type, assignment_score_weight,
  due_at, max_points, description, points, is_published
) VALUES (
  2002,
  'Unit Test 3: Integration Techniques & Improper Integrals',
  'exam',
  0.16,
  '2026-03-21 18:00:00',
  120,
  'Covers Chapters 8.1–8.8: integration rules, parts, trig integrals, substitution, partial fractions, improper integrals.',
  120,
  1
);
SET @mat172_a6 = LAST_INSERT_ID();

-- Week 11 – Series Homework
INSERT INTO assignments (
  class_id, assignment_name, assignment_type, assignment_score_weight,
  due_at, max_points, description, points, is_published
) VALUES (
  2002,
  'Homework 3: Sequences & Series Tests',
  'homework',
  0.06,
  '2026-04-04 23:59:00',
  60,
  'Exercises on convergence tests: p-series, comparison test, alternating series, ratio/root tests.',
  60,
  1
);
SET @mat172_a7 = LAST_INSERT_ID();

-- Week 14 – Test 4 (Unit IV)
INSERT INTO assignments (
  class_id, assignment_name, assignment_type, assignment_score_weight,
  due_at, max_points, description, points, is_published
) VALUES (
  2002,
  'Unit Test 4: Series & Taylor/Maclaurin',
  'exam',
  0.18,
  '2026-04-18 18:00:00',
  120,
  'Covers Chapters 9.1–9.10: sequences, series tests, power series, Taylor/Maclaurin.',
  120,
  1
);
SET @mat172_a8 = LAST_INSERT_ID();

-- Week 15 – Final Exam
INSERT INTO assignments (
  class_id, assignment_name, assignment_type, assignment_score_weight,
  due_at, max_points, description, points, is_published
) VALUES (
  2002,
  'Final Exam: Comprehensive Calculus II',
  'exam',
  0.22,
  '2026-05-02 18:00:00',
  150,
  'Covers entire MAT 172 curriculum including integration, applications, series, conics, and parametric equations.',
  150,
  1
);
SET @mat172_a9 = LAST_INSERT_ID();

-- ============================
-- MAT 172 – Module Items
-- ============================

INSERT INTO course_module_items (module_id, item_type, title, assignment_id, external_url, position) VALUES
  (@mat172_mod1, 'assignment', 'Quiz 1: Bases & L’Hôpital', @mat172_a1, NULL, 1),

  (@mat172_mod3, 'assignment', 'Unit Test 1', @mat172_a2, NULL, 1),

  (@mat172_mod5, 'assignment', 'Homework 1: Areas & Volumes', @mat172_a3, NULL, 1),

  (@mat172_mod6, 'assignment', 'Unit Test 2', @mat172_a4, NULL, 1),

  (@mat172_mod8, 'assignment', 'Homework 2: Integration Techniques', @mat172_a5, NULL, 1),

  (@mat172_mod9, 'assignment', 'Unit Test 3', @mat172_a6, NULL, 1),

  (@mat172_mod11, 'assignment', 'Homework 3: Series Tests', @mat172_a7, NULL, 1),

  (@mat172_mod14, 'assignment', 'Unit Test 4', @mat172_a8, NULL, 1),

  (@mat172_mod15, 'assignment', 'Final Exam: Comprehensive Calculus II', @mat172_a9, NULL, 1);
