-- ============================
-- MAT 171 - Modules (Weeks 1–15)
-- class_id = 1003
-- ============================

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1003, 'Week 1: Precalculus Review & Preview of Calculus', 1, 0);
SET @mat171_mod1 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1003, 'Week 2: Limits – Numerical & Graphical', 2, 0);
SET @mat171_mod2 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1003, 'Week 3: Limits – Analytic, Continuity & Infinite Limits', 3, 0);
SET @mat171_mod3 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1003, 'Week 4: Derivatives & Tangent Lines', 4, 0);
SET @mat171_mod4 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1003, 'Week 5: Basic Differentiation Rules', 5, 0);
SET @mat171_mod5 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1003, 'Week 6: Chain Rule, Implicit Differentiation & Related Rates', 6, 0);
SET @mat171_mod6 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1003, 'Week 7: Extrema, Rolle’s Theorem & Mean Value Theorem', 7, 0);
SET @mat171_mod7 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1003, 'Week 8: Increasing/Decreasing & Concavity', 8, 0);
SET @mat171_mod8 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1003, 'Week 9: Limits at Infinity & Curve Sketching', 9, 0);
SET @mat171_mod9 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1003, 'Week 10: Optimization & Differentials', 10, 0);
SET @mat171_mod10 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1003, 'Week 11: Antiderivatives & Indefinite Integrals', 11, 0);
SET @mat171_mod11 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1003, 'Week 12: Area, Riemann Sums & Definite Integrals', 12, 0);
SET @mat171_mod12 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1003, 'Week 13: Fundamental Theorem of Calculus & Substitution', 13, 0);
SET @mat171_mod13 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1003, 'Week 14: Logarithmic & Exponential Functions', 14, 0);
SET @mat171_mod14 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1003, 'Week 15: Inverse Functions, Review & Final Exam', 15, 0);
SET @mat171_mod15 = LAST_INSERT_ID();


-- ============================
-- MAT 171 - Assignments
-- class_id = 1003
-- ============================

-- Week 1: skills check
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1003,
  'Diagnostic Skills Quiz (Precalculus Review)',
  'quiz',
  0.02,
  '2025-09-05 23:59:00',
  20,
  'Short quiz on prerequisite algebra and trigonometry skills to identify review needs.',
  20,
  1
);
SET @mat171_a1 = LAST_INSERT_ID();

-- Week 2: limits homework
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1003,
  'Homework 1: Limits & Continuity (Sections 1.1–1.4)',
  'homework',
  0.06,
  '2025-09-12 23:59:00',
  40,
  'Homework set on numeric, graphical, and analytic limits plus continuity and infinite limits.',
  40,
  1
);
SET @mat171_a2 = LAST_INSERT_ID();

-- Week 3: Quiz 1 (Limits)
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1003,
  'Quiz 1: Limits & Continuity',
  'quiz',
  0.04,
  '2025-09-19 23:59:00',
  30,
  'Quiz covering limit computation, continuity, and infinite limits.',
  30,
  1
);
SET @mat171_a3 = LAST_INSERT_ID();

-- Week 3: Unit Test I (Limits)
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1003,
  'Unit Test I: Limits & Their Properties',
  'exam',
  0.10,
  '2025-09-23 18:00:00',
  100,
  'In-class exam on Unit I topics (preview of calculus, limits, continuity, infinite limits).',
  100,
  1
);
SET @mat171_a4 = LAST_INSERT_ID();

-- Week 5: Homework 2 (Differentiation Rules)
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1003,
  'Homework 2: Basic Differentiation Rules (Sections 2.1–2.3)',
  'homework',
  0.08,
  '2025-10-03 23:59:00',
  50,
  'Exercises on derivative definition, basic rules, and product/quotient rules.',
  50,
  1
);
SET @mat171_a5 = LAST_INSERT_ID();

-- Week 6: Unit Test II (Differentiation)
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1003,
  'Unit Test II: Differentiation',
  'exam',
  0.16,
  '2025-10-10 18:00:00',
  120,
  'Exam on basic rules, chain rule, implicit differentiation, and related rates.',
  120,
  1
);
SET @mat171_a6 = LAST_INSERT_ID();

-- Week 8: Homework 3 (Applications of Derivatives)
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1003,
  'Homework 3: Applications of Derivatives (Sections 3.1–3.7)',
  'homework',
  0.08,
  '2025-10-24 23:59:00',
  60,
  'Problems on extrema, MVT, increasing/decreasing tests, concavity, curve sketching, and optimization.',
  60,
  1
);
SET @mat171_a7 = LAST_INSERT_ID();

-- Week 10: Unit Test III (Applications)
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1003,
  'Unit Test III: Applications of Differentiation',
  'exam',
  0.16,
  '2025-11-07 18:00:00',
  120,
  'Exam on Unit III topics including curve sketching, optimization, and differentials.',
  120,
  1
);
SET @mat171_a8 = LAST_INSERT_ID();

-- Week 13: Homework 4 (Integration & FTC)
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1003,
  'Homework 4: Integration & FTC',
  'homework',
  0.09,
  '2025-11-28 23:59:00',
  70,
  'Exercises on antiderivatives, definite integrals, Fundamental Theorem of Calculus, and substitution.',
  70,
  1
);
SET @mat171_a9 = LAST_INSERT_ID();

-- Week 15: Final Exam (Comprehensive)
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1003,
  'Final Exam: Comprehensive Calculus I',
  'exam',
  0.31,
  '2025-12-15 18:00:00',
  150,
  'Comprehensive final exam covering limits, differentiation, applications, and integration.',
  150,
  1
);
SET @mat171_a10 = LAST_INSERT_ID();


-- ============================
-- MAT 171 - Module Items
-- ============================

INSERT INTO course_module_items (module_id, item_type, title, assignment_id, external_url, position) VALUES
  -- Week 1
  (@mat171_mod1, 'assignment', 'Diagnostic Skills Quiz (Precalculus Review)', @mat171_a1, NULL, 1),

  -- Week 2–3: Limits
  (@mat171_mod2, 'assignment', 'Homework 1: Limits & Continuity (Sections 1.1–1.4)', @mat171_a2, NULL, 1),
  (@mat171_mod3, 'assignment', 'Quiz 1: Limits & Continuity', @mat171_a3, NULL, 1),
  (@mat171_mod3, 'assignment', 'Unit Test I: Limits & Their Properties', @mat171_a4, NULL, 2),

  -- Week 5–6: Differentiation
  (@mat171_mod5, 'assignment', 'Homework 2: Basic Differentiation Rules (Sections 2.1–2.3)', @mat171_a5, NULL, 1),
  (@mat171_mod6, 'assignment', 'Unit Test II: Differentiation', @mat171_a6, NULL, 1),

  -- Week 8–10: Applications
  (@mat171_mod8, 'assignment', 'Homework 3: Applications of Derivatives (Sections 3.1–3.7)', @mat171_a7, NULL, 1),
  (@mat171_mod10, 'assignment', 'Unit Test III: Applications of Differentiation', @mat171_a8, NULL, 1),

  -- Week 13: Integration work
  (@mat171_mod13, 'assignment', 'Homework 4: Integration & FTC', @mat171_a9, NULL, 1),

  -- Week 15: Final
  (@mat171_mod15, 'assignment', 'Final Exam: Comprehensive Calculus I', @mat171_a10, NULL, 1);
