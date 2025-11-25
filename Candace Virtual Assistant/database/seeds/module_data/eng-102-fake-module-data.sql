-- ============================
-- ENG 102 - Modules (Weeks 1–15)
-- class_id = 2001
-- ============================

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2001, 'Week 1: Course Introduction & Elements of Fiction', 1, 0);
SET @eng102_mod1 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2001, 'Week 2: Chopin & Joyce – Short Fiction & Critical Response', 2, 0);
SET @eng102_mod2 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2001, 'Week 3: Chopin – The Awakening & Literary Analysis', 3, 0);
SET @eng102_mod3 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2001, 'Week 4: Faulkner – A Rose for Emily & Literary Terms', 4, 0);
SET @eng102_mod4 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2001, 'Week 5: Hurston & Baldwin – Short Fiction & Criticism', 5, 0);
SET @eng102_mod5 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2001, 'Week 6: Welty & Kincaid – MLA Review & Citation Quiz', 6, 0);
SET @eng102_mod6 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2001, 'Week 7: Cather & Oates – Character & Conflict', 7, 0);
SET @eng102_mod7 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2001, 'Week 8: Atwood & Carver – Love, Family & Presentations', 8, 0);
SET @eng102_mod8 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2001, 'Week 9: Midterm Conferences & Literary Analysis', 9, 0);
SET @eng102_mod9 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2001, 'Week 10: Poetry Unit I – Close Reading', 10, 0);
SET @eng102_mod10 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2001, 'Week 11: Poetry Unit II – Presentations & Quiz', 11, 0);
SET @eng102_mod11 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2001, 'Week 12: Drama / Novel – Extended Literary Text', 12, 0);
SET @eng102_mod12 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2001, 'Week 13: Research Paper Introduction & Library Resources', 13, 0);
SET @eng102_mod13 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2001, 'Week 14: Research Paper Draft & Peer Review', 14, 0);
SET @eng102_mod14 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (2001, 'Week 15: Final Conferences, Research Paper & Final Exam', 15, 0);
SET @eng102_mod15 = LAST_INSERT_ID();

-- ============================
-- ENG 102 - Assignments
-- class_id = 2001
-- ============================

-- Week 2 – Reading Response 1
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2001,
  'Reading Response 1: Chopin & Joyce',
  'response',
  0.04,
  '2026-02-06 23:59:00',
  40,
  'Short critical response to Chopin’s "The Story of an Hour" and Joyce’s "Araby".',
  40,
  1
);
SET @eng102_rr1 = LAST_INSERT_ID();

-- Week 4 – Literary Terms Quiz
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2001,
  'Literary Terms Quiz',
  'quiz',
  0.05,
  '2026-02-20 23:59:00',
  25,
  'Quiz on key literary terms introduced through Faulkner’s "A Rose for Emily".',
  25,
  1
);
SET @eng102_ltquiz = LAST_INSERT_ID();

-- Week 5 – Reading Response 2
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2001,
  'Reading Response 2: Hurston & Baldwin',
  'response',
  0.04,
  '2026-02-27 23:59:00',
  40,
  'Response paper comparing themes and style in Hurston’s "Sweat" and Baldwin’s "Sonny’s Blues".',
  40,
  1
);
SET @eng102_rr2 = LAST_INSERT_ID();

-- Week 6 – Citation / MLA Quiz
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2001,
  'Citation Quiz: MLA Documentation',
  'quiz',
  0.05,
  '2026-03-06 23:59:00',
  25,
  'Quiz on MLA in-text citations and Works Cited formatting based on short fiction readings.',
  25,
  1
);
SET @eng102_citquiz = LAST_INSERT_ID();

-- Week 8 – Reading Response 3
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2001,
  'Reading Response 3: Atwood & Carver',
  'response',
  0.04,
  '2026-03-20 23:59:00',
  40,
  'Critical response to Margaret Atwood’s and Raymond Carver’s short stories with focus on theme and style.',
  40,
  1
);
SET @eng102_rr3 = LAST_INSERT_ID();

-- Week 9 – Midterm Literary Analysis / Exam
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2001,
  'Midterm Literary Analysis Exam / Paper',
  'exam',
  0.15,
  '2026-03-27 18:00:00',
  100,
  'Midterm exam or literary analysis paper synthesizing short fiction studied in the first half of the course.',
  100,
  1
);
SET @eng102_midterm = LAST_INSERT_ID();

-- Week 10 – Close Reading Poetry Paper
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2001,
  'Close Reading Poetry Paper',
  'paper',
  0.10,
  '2026-04-03 23:59:00',
  80,
  'Short paper performing a close reading of one or more poems from the Poetry Unit.',
  80,
  1
);
SET @eng102_poetrypaper = LAST_INSERT_ID();

-- Week 11 – Poetry Quiz
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2001,
  'Poetry Quiz',
  'quiz',
  0.06,
  '2026-04-10 23:59:00',
  30,
  'Quiz on poetic terminology, forms, and interpretation from the Poetry Unit.',
  30,
  1
);
SET @eng102_poetryquiz = LAST_INSERT_ID();

-- Week 14 – Research Paper Draft
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2001,
  'Research Paper Draft',
  'draft',
  0.12,
  '2026-04-24 23:59:00',
  80,
  'Complete draft of the ENG 102 research paper in MLA format for peer review and instructor feedback.',
  80,
  1
);
SET @eng102_rpdraft = LAST_INSERT_ID();

-- Week 15 – Final Research Paper
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2001,
  'Final Research Paper',
  'paper',
  0.20,
  '2026-05-08 23:59:00',
  120,
  'Final revised ENG 102 research paper demonstrating literary analysis, research, and MLA documentation.',
  120,
  1
);
SET @eng102_rpfinal = LAST_INSERT_ID();

-- Week 15 – Final Exam
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  2001,
  'Final Exam: Literature & Composition',
  'exam',
  0.15,
  '2026-05-12 18:00:00',
  150,
  'Comprehensive final exam on fiction, poetry, drama, and research writing from ENG 102.',
  150,
  1
);
SET @eng102_finalexam = LAST_INSERT_ID();

-- ============================
-- ENG 102 - Module Items
-- ============================

INSERT INTO course_module_items
  (module_id, item_type, title, assignment_id, external_url, position)
VALUES
  -- Week 2: first response
  (@eng102_mod2, 'assignment', 'Reading Response 1: Chopin & Joyce', @eng102_rr1, NULL, 1),

  -- Week 4: literary terms quiz
  (@eng102_mod4, 'assignment', 'Literary Terms Quiz', @eng102_ltquiz, NULL, 1),

  -- Week 5: second response
  (@eng102_mod5, 'assignment', 'Reading Response 2: Hurston & Baldwin', @eng102_rr2, NULL, 1),

  -- Week 6: citation quiz
  (@eng102_mod6, 'assignment', 'Citation Quiz: MLA Documentation', @eng102_citquiz, NULL, 1),

  -- Week 8: third response
  (@eng102_mod8, 'assignment', 'Reading Response 3: Atwood & Carver', @eng102_rr3, NULL, 1),

  -- Week 9: midterm analysis / exam
  (@eng102_mod9, 'assignment', 'Midterm Literary Analysis Exam / Paper', @eng102_midterm, NULL, 1),

  -- Week 10: poetry paper
  (@eng102_mod10, 'assignment', 'Close Reading Poetry Paper', @eng102_poetrypaper, NULL, 1),

  -- Week 11: poetry quiz
  (@eng102_mod11, 'assignment', 'Poetry Quiz', @eng102_poetryquiz, NULL, 1),

  -- Week 14: research draft
  (@eng102_mod14, 'assignment', 'Research Paper Draft', @eng102_rpdraft, NULL, 1),

  -- Week 15: final paper + final exam
  (@eng102_mod15, 'assignment', 'Final Research Paper', @eng102_rpfinal, NULL, 1),
  (@eng102_mod15, 'assignment', 'Final Exam: Literature & Composition', @eng102_finalexam, NULL, 2);
