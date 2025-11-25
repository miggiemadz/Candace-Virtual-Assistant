-- ============================
-- PHY 111 – Modules (Weeks 1–15)
-- class_id = 2003
-- ============================

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2003, 'Week 1: Intro, Units, Vectors & Review Math Tools', 1, 0);
SET @phy111_mod1 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2003, 'Week 2: Dimensional Analysis, Significant Figures & Test 1 Review', 2, 0);
SET @phy111_mod2 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2003, 'Week 3: Kinematics in One Dimension', 3, 0);
SET @phy111_mod3 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2003, 'Week 4: Kinematics in Two Dimensions & Projectile Motion', 4, 0);
SET @phy111_mod4 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2003, 'Week 5: Newton’s Laws & Forces I', 5, 0);
SET @phy111_mod5 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2003, 'Week 6: Newton’s Laws & Forces II – Friction & Inclines', 6, 0);
SET @phy111_mod6 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2003, 'Week 7: Circular Motion & Applications of Newton’s Laws', 7, 0);
SET @phy111_mod7 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2003, 'Week 8: Work, Kinetic Energy & Work–Energy Theorem', 8, 0);
SET @phy111_mod8 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2003, 'Week 9: Potential Energy, Conservation of Energy & Power', 9, 0);
SET @phy111_mod9 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2003, 'Week 10: Momentum, Impulse & Collisions', 10, 0);
SET @phy111_mod10 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2003, 'Week 11: Rotational Kinematics & Dynamics I', 11, 0);
SET @phy111_mod11 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2003, 'Week 12: Rotational Energy, Torque & Angular Momentum', 12, 0);
SET @phy111_mod12 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2003, 'Week 13: Static Equilibrium & Elasticity', 13, 0);
SET @phy111_mod13 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2003, 'Week 14: Fluids – Pressure, Buoyancy & Bernoulli; Test 5', 14, 0);
SET @phy111_mod14 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2003, 'Week 15: Comprehensive Final Exam & Course Wrap-Up', 15, 0);
SET @phy111_mod15 = LAST_INSERT_ID();

-- ============================
-- PHY 111 – Assignments
-- class_id = 2003
-- ============================

-- Homework 1 – Units, Vectors, 1D Kinematics
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2003,
  'Homework 1: Units, Vectors & 1D Kinematics',
  'homework',
  0.04,
  '2026-02-01 23:59:00',
  40,
  'Problem set on unit conversions, vector components, and one-dimensional motion with constant acceleration.',
  40,
  1
);
SET @phy111_hw1 = LAST_INSERT_ID();

-- Homework 2 – 2D Kinematics & Newton''s Laws
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2003,
  'Homework 2: 2D Motion & Newton''s Laws',
  'homework',
  0.04,
  '2026-02-22 23:59:00',
  40,
  'Problems on projectile motion, free-body diagrams, friction, and motion on inclines.',
  40,
  1
);
SET @phy111_hw2 = LAST_INSERT_ID();

-- Homework 3 – Work, Energy & Power
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2003,
  'Homework 3: Work, Energy & Power',
  'homework',
  0.04,
  '2026-03-15 23:59:00',
  40,
  'Exercises on work, kinetic and potential energy, conservation of mechanical energy, and power.',
  40,
  1
);
SET @phy111_hw3 = LAST_INSERT_ID();

-- Homework 4 – Momentum, Rotation & Equilibrium
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2003,
  'Homework 4: Momentum, Rotation & Equilibrium',
  'homework',
  0.03,
  '2026-04-05 23:59:00',
  40,
  'Problems on linear momentum, collisions, rotational dynamics, static equilibrium and elasticity.',
  40,
  1
);
SET @phy111_hw4 = LAST_INSERT_ID();

-- Participation & Labs
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2003,
  'Participation & Weekly Labs',
  'participation',
  0.10,
  '2026-05-03 23:59:00',
  100,
  'Overall participation, in-class work, and completion of weekly lab activities throughout the semester.',
  100,
  1
);
SET @phy111_part = LAST_INSERT_ID();

-- Test 1 – Intro & Math/Vector Tools (Ch 1, 3)
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2003,
  'Test 1: Intro, Units, Vectors & Math Tools (Ch 1, 3)',
  'exam',
  0.10,
  '2026-02-05 18:00:00',
  100,
  'Covers course introduction, units and dimensions, significant figures, and vector algebra.',
  100,
  1
);
SET @phy111_t1 = LAST_INSERT_ID();

-- Test 2 – Kinematics (Ch 2, 4)
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2003,
  'Test 2: Kinematics in 1D & 2D (Ch 2, 4)',
  'exam',
  0.10,
  '2026-02-19 18:00:00',
  100,
  'Covers 1D and 2D kinematics, graphical analysis, and projectile motion.',
  100,
  1
);
SET @phy111_t2 = LAST_INSERT_ID();

-- Test 3 – Newton''s Laws & Circular Motion (Ch 5, 6)
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2003,
  'Test 3: Newton''s Laws & Circular Motion (Ch 5, 6)',
  'exam',
  0.10,
  '2026-03-08 18:00:00',
  100,
  'Covers forces, Newton’s laws, friction, free-body diagrams, and circular motion.',
  100,
  1
);
SET @phy111_t3 = LAST_INSERT_ID();

-- Test 4 – Energy & Momentum (Ch 7, 8, 9)
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2003,
  'Test 4: Energy & Momentum (Ch 7, 8, 9)',
  'exam',
  0.10,
  '2026-03-29 18:00:00',
  100,
  'Covers work, energy, conservation of energy, momentum, impulse, and collisions.',
  100,
  1
);
SET @phy111_t4 = LAST_INSERT_ID();

-- Test 5 – Rotation, Equilibrium & Fluids (Ch 10, 11, 12)
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2003,
  'Test 5: Rotation, Equilibrium & Fluids (Ch 10, 11, 12)',
  'exam',
  0.10,
  '2026-04-19 18:00:00',
  100,
  'Covers rotational dynamics, static equilibrium, elasticity, and fluid statics/dynamics.',
  100,
  1
);
SET @phy111_t5 = LAST_INSERT_ID();

-- Final Exam – Comprehensive Mechanics
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2003,
  'Final Exam: Comprehensive Mechanics',
  'exam',
  0.25,
  '2026-05-03 18:00:00',
  150,
  'Comprehensive final exam covering all PHY 111 mechanics topics.',
  150,
  1
);
SET @phy111_final = LAST_INSERT_ID();

-- ============================
-- PHY 111 – Module Items
-- ============================

INSERT INTO course_module_items
  (module_id, item_type, title, assignment_id, external_url, position)
VALUES
  -- Early weeks: foundations + first homework & tests
  (@phy111_mod1, 'assignment', 'Homework 1: Units, Vectors & 1D Kinematics', @phy111_hw1, NULL, 1),
  (@phy111_mod2, 'assignment', 'Test 1: Intro, Units, Vectors & Math Tools', @phy111_t1, NULL, 1),

  -- Kinematics & Test 2
  (@phy111_mod3, 'assignment', 'Test 2: Kinematics in 1D & 2D', @phy111_t2, NULL, 1),
  (@phy111_mod4, 'assignment', 'Homework 2: 2D Motion & Newton''s Laws', @phy111_hw2, NULL, 1),

  -- Newton''s Laws & Test 3
  (@phy111_mod7, 'assignment', 'Test 3: Newton''s Laws & Circular Motion', @phy111_t3, NULL, 1),

  -- Energy, Momentum & related homework/tests
  (@phy111_mod8, 'assignment', 'Homework 3: Work, Energy & Power', @phy111_hw3, NULL, 1),
  (@phy111_mod10, 'assignment', 'Test 4: Energy & Momentum', @phy111_t4, NULL, 1),

  -- Rotation / Equilibrium / Fluids
  (@phy111_mod12, 'assignment', 'Homework 4: Momentum, Rotation & Equilibrium', @phy111_hw4, NULL, 1),
  (@phy111_mod14, 'assignment', 'Test 5: Rotation, Equilibrium & Fluids', @phy111_t5, NULL, 1),

  -- Final week: participation + final exam
  (@phy111_mod15, 'assignment', 'Participation & Weekly Labs', @phy111_part, NULL, 1),
  (@phy111_mod15, 'assignment', 'Final Exam: Comprehensive Mechanics', @phy111_final, NULL, 2);
