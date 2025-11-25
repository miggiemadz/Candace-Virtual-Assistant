-- ============================
-- PSY 101 - Modules (Weeks 1–15)
-- class_id = 1002
-- ============================

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1002, 'Week 1: What is Psychology?', 1, 0);
SET @psy101_mod1 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1002, 'Week 2: Biology and Psychology', 2, 0);
SET @psy101_mod2 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1002, 'Week 3: Sensation and Perception', 3, 0);
SET @psy101_mod3 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1002, 'Week 4: Consciousness', 4, 0);
SET @psy101_mod4 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1002, 'Week 5: Learning', 5, 0);
SET @psy101_mod5 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1002, 'Week 6: Library Visit & Information Literacy / Midterm', 6, 0);
SET @psy101_mod6 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1002, 'Week 7: Memory', 7, 0);
SET @psy101_mod7 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1002, 'Week 8: Thinking, Language, and Intelligence', 8, 0);
SET @psy101_mod8 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1002, 'Week 9: Motivation and Emotion', 9, 0);
SET @psy101_mod9 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1002, 'Week 10: Evaluation Exam and/or Paper', 10, 0);
SET @psy101_mod10 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1002, 'Week 11: The Voyage Through the Life Span', 11, 0);
SET @psy101_mod11 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1002, 'Week 12: Personality', 12, 0);
SET @psy101_mod12 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1002, 'Week 13: Psychological Disorders', 13, 0);
SET @psy101_mod13 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1002, 'Week 14: Social Psychology', 14, 0);
SET @psy101_mod14 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1002, 'Week 15: Final Exam / Research Paper', 15, 0);
SET @psy101_mod15 = LAST_INSERT_ID();

-- ============================
-- PSY 101 - Assignments
-- class_id = 1002
-- ============================

-- Week 1 – Quiz 1
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1002,
  'Quiz 1: What is Psychology?',
  'quiz',
  0.03,
  '2025-09-05 23:59:00',
  20,
  'Quiz on Chapter 1 covering definitions, history, and major perspectives in psychology.',
  20,
  1
);
SET @psy101_q1 = LAST_INSERT_ID();

-- Week 2 – Quiz 2
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1002,
  'Quiz 2: Biology and Psychology',
  'quiz',
  0.03,
  '2025-09-12 23:59:00',
  20,
  'Quiz on Chapter 2 covering neurons, the nervous system, and brain–behavior relationships.',
  20,
  1
);
SET @psy101_q2 = LAST_INSERT_ID();

-- Week 3 – Quiz 3
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1002,
  'Quiz 3: Sensation and Perception',
  'quiz',
  0.03,
  '2025-09-19 23:59:00',
  20,
  'Quiz on Chapter 3 covering sensory processes and perceptual organization.',
  20,
  1
);
SET @psy101_q3 = LAST_INSERT_ID();

-- Week 4 – Quiz 4
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1002,
  'Quiz 4: Consciousness',
  'quiz',
  0.03,
  '2025-09-26 23:59:00',
  20,
  'Quiz on Chapter 4 covering sleep, dreams, psychoactive drugs, and states of consciousness.',
  20,
  1
);
SET @psy101_q4 = LAST_INSERT_ID();

-- Week 5 – Quiz 5
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1002,
  'Quiz 5: Learning',
  'quiz',
  0.03,
  '2025-10-03 23:59:00',
  20,
  'Quiz on Chapter 5 covering classical and operant conditioning and observational learning.',
  20,
  1
);
SET @psy101_q5 = LAST_INSERT_ID();

-- Week 6 – Information Literacy Project / Midterm
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1002,
  'Information Literacy Project / Midterm',
  'project',
  0.10,
  '2025-10-10 23:59:00',
  60,
  'Library-based information literacy project and/or midterm exam connecting research skills to psychology.',
  60,
  1
);
SET @psy101_ilp = LAST_INSERT_ID();

-- Week 7 – Quiz 6 (Memory)
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1002,
  'Quiz 6: Memory',
  'quiz',
  0.03,
  '2025-10-17 23:59:00',
  20,
  'Quiz on Chapter 6 covering encoding, storage, retrieval, and forgetting.',
  20,
  1
);
SET @psy101_q6 = LAST_INSERT_ID();

-- Week 8 – Quiz 7 (Thinking, Language & Intelligence)
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1002,
  'Quiz 7: Thinking, Language, and Intelligence',
  'quiz',
  0.03,
  '2025-10-24 23:59:00',
  20,
  'Quiz on Chapter 7 covering problem solving, decision making, language, and intelligence.',
  20,
  1
);
SET @psy101_q7 = LAST_INSERT_ID();

-- Week 9 – Quiz 8 (Motivation & Emotion)
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1002,
  'Quiz 8: Motivation and Emotion',
  'quiz',
  0.03,
  '2025-10-31 23:59:00',
  20,
  'Quiz on Chapter 8 covering theories of motivation and emotion.',
  20,
  1
);
SET @psy101_q8 = LAST_INSERT_ID();

-- Week 10 – Evaluation Exam and/or Paper
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1002,
  'Evaluation Exam / Applied Paper',
  'exam',
  0.12,
  '2025-11-07 18:00:00',
  100,
  'Evaluation exam or applied paper synthesizing major concepts from the first half of the course.',
  100,
  1
);
SET @psy101_eval = LAST_INSERT_ID();

-- Week 11 – Quiz 9 (Life Span)
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1002,
  'Quiz 9: The Voyage Through the Life Span',
  'quiz',
  0.03,
  '2025-11-14 23:59:00',
  20,
  'Quiz on Chapter 9 covering developmental psychology across the life span.',
  20,
  1
);
SET @psy101_q9 = LAST_INSERT_ID();

-- Week 12 – Quiz 10 (Personality)
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1002,
  'Quiz 10: Personality',
  'quiz',
  0.03,
  '2025-11-21 23:59:00',
  20,
  'Quiz on Chapter 10 covering major theories and assessment of personality.',
  20,
  1
);
SET @psy101_q10 = LAST_INSERT_ID();

-- Week 13 – Quiz 11 (Psychological Disorders)
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1002,
  'Quiz 11: Psychological Disorders',
  'quiz',
  0.03,
  '2025-11-28 23:59:00',
  20,
  'Quiz on Chapter 12 covering classification, symptoms, and perspectives on psychological disorders.',
  20,
  1
);
SET @psy101_q11 = LAST_INSERT_ID();

-- Week 14 – Quiz 12 (Social Psychology)
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1002,
  'Quiz 12: Social Psychology',
  'quiz',
  0.03,
  '2025-12-05 23:59:00',
  20,
  'Quiz on Chapter 14 covering attitudes, conformity, group behavior, and prejudice.',
  20,
  1
);
SET @psy101_q12 = LAST_INSERT_ID();

-- Week 15 – Final Exam / Research Paper
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1002,
  'Final Exam / Research Paper',
  'exam',
  0.18,
  '2025-12-15 18:00:00',
  150,
  'Comprehensive final exam and/or research paper integrating major topics in general psychology.',
  150,
  1
);
SET @psy101_final = LAST_INSERT_ID();

-- ============================
-- PSY 101 - Module Items
-- ============================

INSERT INTO course_module_items (module_id, item_type, title, assignment_id, external_url, position) VALUES
  -- Weeks 1–5: Chapter quizzes
  (@psy101_mod1, 'assignment', 'Quiz 1: What is Psychology?', @psy101_q1, NULL, 1),
  (@psy101_mod2, 'assignment', 'Quiz 2: Biology and Psychology', @psy101_q2, NULL, 1),
  (@psy101_mod3, 'assignment', 'Quiz 3: Sensation and Perception', @psy101_q3, NULL, 1),
  (@psy101_mod4, 'assignment', 'Quiz 4: Consciousness', @psy101_q4, NULL, 1),
  (@psy101_mod5, 'assignment', 'Quiz 5: Learning', @psy101_q5, NULL, 1),

  -- Week 6: Info Literacy Project / Midterm
  (@psy101_mod6, 'assignment', 'Information Literacy Project / Midterm', @psy101_ilp, NULL, 1),

  -- Weeks 7–9: more quizzes
  (@psy101_mod7, 'assignment', 'Quiz 6: Memory', @psy101_q6, NULL, 1),
  (@psy101_mod8, 'assignment', 'Quiz 7: Thinking, Language, and Intelligence', @psy101_q7, NULL, 1),
  (@psy101_mod9, 'assignment', 'Quiz 8: Motivation and Emotion', @psy101_q8, NULL, 1),

  -- Week 10: evaluation exam / paper
  (@psy101_mod10, 'assignment', 'Evaluation Exam / Applied Paper', @psy101_eval, NULL, 1),

  -- Weeks 11–14: remaining quizzes
  (@psy101_mod11, 'assignment', 'Quiz 9: The Voyage Through the Life Span', @psy101_q9, NULL, 1),
  (@psy101_mod12, 'assignment', 'Quiz 10: Personality', @psy101_q10, NULL, 1),
  (@psy101_mod13, 'assignment', 'Quiz 11: Psychological Disorders', @psy101_q11, NULL, 1),
  (@psy101_mod14, 'assignment', 'Quiz 12: Social Psychology', @psy101_q12, NULL, 1),

  -- Week 15: Final Exam / Research Paper
  (@psy101_mod15, 'assignment', 'Final Exam / Research Paper', @psy101_final, NULL, 1);
