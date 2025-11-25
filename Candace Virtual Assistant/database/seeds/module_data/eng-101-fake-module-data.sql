-- ============================
-- ENG 101 - Modules (Weeks 1–15)
-- class_id = 1001
-- ============================

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1001, 'Week 1: Introduction, Rhetoric & Diagnostic Writing', 1, 0);
SET @eng101_mod1 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1001, 'Week 2: Narrative & Descriptive Writing + MLA Basics', 2, 0);
SET @eng101_mod2 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1001, 'Week 3: Narrative / Description – Drafting & Revision', 3, 0);
SET @eng101_mod3 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1001, 'Week 4: Writing Workshop – Reflection Essay Due', 4, 0);
SET @eng101_mod4 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1001, 'Week 5: Comparison / Contrast Readings', 5, 0);
SET @eng101_mod5 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1001, 'Week 6: Comparison / Contrast Continued – Draft Due', 6, 0);
SET @eng101_mod6 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1001, 'Week 7: Writing Workshop + Mid-Semester Conferences', 7, 0);
SET @eng101_mod7 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1001, 'Week 8: Argumentative Readings – Research Intro', 8, 0);
SET @eng101_mod8 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1001, 'Week 9: Research Skills & Library Visit', 9, 0);
SET @eng101_mod9 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1001, 'Week 10: Research Essay Draft + Citation Review', 10, 0);
SET @eng101_mod10 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1001, 'Week 11: Research Continued – Citation Quiz', 11, 0);
SET @eng101_mod11 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1001, 'Week 12: Writing Workshop – Research Essay Due', 12, 0);
SET @eng101_mod12 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1001, 'Week 13: Critical Analysis Readings', 13, 0);
SET @eng101_mod13 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1001, 'Week 14: Critical Analysis Draft & Revision', 14, 0);
SET @eng101_mod14 = LAST_INSERT_ID();

INSERT INTO course_modules (class_id, title, position, is_hidden)
VALUES (1001, 'Week 15: Final Conferences & Final Reflection', 15, 0);
SET @eng101_mod15 = LAST_INSERT_ID();

-- ============================
-- ENG 101 - Assignments
-- class_id = 1001
-- ============================

-- Week 1
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
)
VALUES (
  1001, 'Diagnostic Writing', 'in-class',
  0.02, '2025-09-05 23:59:00', 20,
  'Initial diagnostic writing sample used to assess incoming writing level.',
  20, 1
);
SET @eng101_a1 = LAST_INSERT_ID();


-- Week 3
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1001,
  'Draft: Reflection/Narration Essay',
  'draft',
  0.03,
  '2025-09-19 23:59:00',
  30,
  'Rough draft of the first major essay based on narrative/description.',
  30,
  1
);


-- ============================
-- ENG 101 - Assignments
-- class_id = 1001
-- ============================

-- Week 1
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1001,
  'Diagnostic Writing',
  'in-class',
  0.02,
  '2025-09-05 23:59:00',
  20,
  'Initial diagnostic writing sample used to assess incoming writing level.',
  20,
  1
);
SET @eng101_a1 = LAST_INSERT_ID();

-- Week 3
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1001,
  'Draft: Reflection/Narration Essay',
  'draft',
  0.03,
  '2025-09-19 23:59:00',
  30,
  'Rough draft of the first major essay based on narrative/description.',
  30,
  1
);
SET @eng101_a2 = LAST_INSERT_ID();

-- Week 4
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1001,
  'Final Reflection/Narrative Essay',
  'essay',
  0.10,
  '2025-09-26 23:59:00',
  100,
  'Final polished version of the personal narrative/reflection essay.',
  100,
  1
);
SET @eng101_a3 = LAST_INSERT_ID();

-- Week 6
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1001,
  'Draft: Comparison/Contrast Essay',
  'draft',
  0.04,
  '2025-10-10 23:59:00',
  40,
  'Draft of the comparison/contrast essay including peer review exercises.',
  40,
  1
);
SET @eng101_a4 = LAST_INSERT_ID();

-- Week 7
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1001,
  'Final Comparison/Contrast Essay',
  'essay',
  0.12,
  '2025-10-17 23:59:00',
  100,
  'Revised and finalized comparison/contrast essay.',
  100,
  1
);
SET @eng101_a5 = LAST_INSERT_ID();

-- Week 10
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1001,
  'Draft: Research Essay',
  'draft',
  0.05,
  '2025-11-01 23:59:00',
  40,
  'Draft of research-based essay including MLA citations.',
  40,
  1
);
SET @eng101_a6 = LAST_INSERT_ID();

-- Week 11 – Citation Quiz
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1001,
  'Citation Quiz (MLA Format)',
  'quiz',
  0.03,
  '2025-11-05 23:59:00',
  20,
  'Quiz assessing MLA formatting, in-text citations, and Works Cited fundamentals.',
  20,
  1
);
SET @eng101_a7 = LAST_INSERT_ID();

-- Week 12
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1001,
  'Final Research Essay',
  'essay',
  0.18,
  '2025-11-12 23:59:00',
  120,
  'Final research essay demonstrating information literacy and proper MLA citation.',
  120,
  1
);
SET @eng101_a8 = LAST_INSERT_ID();

-- Week 14
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1001,
  'Draft: Critical Analysis Essay',
  'draft',
  0.04,
  '2025-11-29 23:59:00',
  40,
  'Rough draft analyzing a selected written or visual text.',
  40,
  1
);
SET @eng101_a9 = LAST_INSERT_ID();

-- Week 15
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1001,
  'Final Critical Analysis Essay',
  'essay',
  0.15,
  '2025-12-06 23:59:00',
  120,
  'Final revised version of the critical analysis essay.',
  120,
  1
);
SET @eng101_a10 = LAST_INSERT_ID();

-- Final Exam
INSERT INTO assignments (
  class_id, assignment_name, assignment_type,
  assignment_score_weight, due_at, max_points,
  description, points, is_published
) VALUES (
  1001,
  'Final Exam',
  'exam',
  0.14,
  '2025-12-15 18:00:00',
  150,
  'Comprehensive final exam assessing writing process, critical thinking, and MLA skills.',
  150,
  1
);
SET @eng101_a11 = LAST_INSERT_ID();

-- ============================
-- ENG 101 - Module Items
-- ============================

INSERT INTO course_module_items (module_id, item_type, title, assignment_id, external_url, position) VALUES
  (@eng101_mod1, 'assignment', 'Diagnostic Writing', @eng101_a1, NULL, 1),

  (@eng101_mod3, 'assignment', 'Draft: Reflection/Narration Essay', @eng101_a2, NULL, 1),
  (@eng101_mod4, 'assignment', 'Final Reflection/Narrative Essay', @eng101_a3, NULL, 1),

  (@eng101_mod6, 'assignment', 'Draft: Comparison/Contrast Essay', @eng101_a4, NULL, 1),
  (@eng101_mod7, 'assignment', 'Final Comparison/Contrast Essay', @eng101_a5, NULL, 1),

  (@eng101_mod10, 'assignment', 'Draft: Research Essay', @eng101_a6, NULL, 1),
  (@eng101_mod11, 'assignment', 'Citation Quiz (MLA Format)', @eng101_a7, NULL, 1),
  (@eng101_mod12, 'assignment', 'Final Research Essay', @eng101_a8, NULL, 1),

  (@eng101_mod14, 'assignment', 'Draft: Critical Analysis Essay', @eng101_a9, NULL, 1),
  (@eng101_mod15, 'assignment', 'Final Critical Analysis Essay', @eng101_a10, NULL, 1),

  (@eng101_mod15, 'assignment', 'Final Exam', @eng101_a11, NULL, 2);
