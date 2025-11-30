USE candace_assistant;

SET SQL_SAFE_UPDATES = 0;

-- Wipe any existing grades for these courses for Alex
DELETE ag
FROM assignment_grades ag
JOIN assignments a   ON ag.assignment_id = a.assignment_id
JOIN classes cl      ON a.class_id       = cl.class_id
JOIN courses c       ON cl.course_id     = c.course_id
WHERE ag.student_id = 1000001
  AND c.course_name IN (
    'CST 161 - Computer Programming Fundamentals',
    'ENG 101 - English Composition I',
    'PSY 101 - General Psychology',
    'MAT 171 - Unified Calculus I'
  );

-- =====================================================
-- CST 161 - Computer Programming Fundamentals (1004)
-- Last two: Project 2 + Final Exam -> submitted, no score yet
-- =====================================================
INSERT INTO assignment_grades (student_id, assignment_id, score, submitted_at, status)
SELECT
  1000001 AS student_id,
  a.assignment_id,
  CASE a.assignment_name
    WHEN 'Getting Started: Canvas & zyBooks Setup'           THEN 18   -- /20
    WHEN 'Lab 1: Intro to Python & Ethics Reflection'        THEN 36   -- /40
    WHEN 'Homework 1: Variables & Expressions'               THEN 37   -- /40
    WHEN 'Homework 2: Decision Structures'                   THEN 35   -- /40
    WHEN 'Semester Exam I: Chapters 1–3'                     THEN 86   -- /100
    WHEN 'Homework 3: Loops'                                 THEN 46   -- /50
    WHEN 'Project 1: Lists & Dictionaries Mini-Project'      THEN 91   -- /100
    WHEN 'Quiz: Number Systems'                              THEN 26   -- /30
    WHEN 'Semester Exam II: Loops, Data Structures & Number Systems' THEN 94  -- /120
    WHEN 'Homework 4: Files, Strings & Exceptions'           THEN 55   -- /60
    -- Last two -> no score yet
    WHEN 'Project 2: Final Programming Project'              THEN NULL
    WHEN 'Final Exam: Comprehensive'                         THEN NULL
    ELSE a.points
  END AS score,
  a.due_at AS submitted_at,
  CASE
    WHEN a.assignment_name IN ('Project 2: Final Programming Project',
                               'Final Exam: Comprehensive')
      THEN 'submitted'        -- turned in, not graded
    ELSE 'graded'
  END AS status
FROM assignments a
JOIN classes cl  ON a.class_id   = cl.class_id
JOIN courses c   ON cl.course_id = c.course_id
WHERE c.course_name = 'CST 161 - Computer Programming Fundamentals';

-- =====================================================
-- ENG 101 - English Composition I (class_id = 1001)
-- Last two: Final Critical Analysis Essay + Final Exam
-- =====================================================
INSERT INTO assignment_grades (student_id, assignment_id, score, submitted_at, status)
SELECT
  1000001 AS student_id,
  a.assignment_id,
  CASE a.assignment_name
    WHEN 'Diagnostic Writing'                     THEN 15   -- /20
    WHEN 'Draft: Reflection/Narration Essay'      THEN 25   -- /30
    WHEN 'Final Reflection/Narrative Essay'       THEN 63   -- /100
    WHEN 'Draft: Comparison/Contrast Essay'       THEN 30   -- /40
    WHEN 'Final Comparison/Contrast Essay'        THEN 72   -- /100
    WHEN 'Draft: Research Essay'                  THEN 32   -- /40
    WHEN 'Citation Quiz (MLA Format)'             THEN 12   -- /20
    WHEN 'Final Research Essay'                   THEN 75   -- /120
    WHEN 'Draft: Critical Analysis Essay'         THEN 35   -- /40
    -- Last two -> no score yet
    WHEN 'Final Critical Analysis Essay'          THEN NULL
    WHEN 'Final Exam'                             THEN NULL
    ELSE a.points
  END AS score,
  a.due_at AS submitted_at,
  CASE
    WHEN a.assignment_name IN ('Final Critical Analysis Essay',
                               'Final Exam')
      THEN 'submitted'
    ELSE 'graded'
  END AS status
FROM assignments a
JOIN classes cl  ON a.class_id   = cl.class_id
JOIN courses c   ON cl.course_id = c.course_id
WHERE c.course_name = 'ENG 101 - English Composition I';

-- =====================================================
-- PSY 101 - General Psychology (class_id = 1002)
-- Last two: Quiz 12 + Final Exam / Research Paper
-- =====================================================
INSERT INTO assignment_grades (student_id, assignment_id, score, submitted_at, status)
SELECT
  1000001 AS student_id,
  a.assignment_id,
  CASE a.assignment_name
    WHEN 'Quiz 1: What is Psychology?'                     THEN 18  -- /20
    WHEN 'Quiz 2: Biology and Psychology'                  THEN 17  -- /20
    WHEN 'Quiz 3: Sensation and Perception'                THEN 19  -- /20
    WHEN 'Quiz 4: Consciousness'                           THEN 16  -- /20
    WHEN 'Quiz 5: Learning'                                THEN 18  -- /20
    WHEN 'Information Literacy Project / Midterm'          THEN 54  -- /60
    WHEN 'Quiz 6: Memory'                                  THEN 17  -- /20
    WHEN 'Quiz 7: Thinking, Language, and Intelligence'    THEN 18  -- /20
    WHEN 'Quiz 8: Motivation and Emotion'                  THEN 19  -- /20
    WHEN 'Evaluation Exam / Applied Paper'                 THEN 87  -- /100
    WHEN 'Quiz 9: The Voyage Through the Life Span'        THEN 18  -- /20
    WHEN 'Quiz 10: Personality'                            THEN 17  -- /20
    WHEN 'Quiz 11: Psychological Disorders'                THEN 16  -- /20
    -- Last two -> no score yet
    WHEN 'Quiz 12: Social Psychology'                      THEN NULL
    WHEN 'Final Exam / Research Paper'                     THEN NULL
    ELSE a.points
  END AS score,
  a.due_at AS submitted_at,
  CASE
    WHEN a.assignment_name IN ('Quiz 12: Social Psychology',
                               'Final Exam / Research Paper')
      THEN 'submitted'
    ELSE 'graded'
  END AS status
FROM assignments a
JOIN classes cl  ON a.class_id   = cl.class_id
JOIN courses c   ON cl.course_id = c.course_id
WHERE c.course_name = 'PSY 101 - General Psychology';

-- =====================================================
-- MAT 171 - Unified Calculus I (class_id = 1003)
-- Last two: Homework 4 + Final Exam Comprehensive
-- =====================================================
INSERT INTO assignment_grades (student_id, assignment_id, score, submitted_at, status)
SELECT
  1000001 AS student_id,
  a.assignment_id,
  CASE a.assignment_name
    WHEN 'Diagnostic Skills Quiz (Precalculus Review)'                   THEN 17  -- /20
    WHEN 'Homework 1: Limits & Continuity (Sections 1.1–1.4)'            THEN 36  -- /40
    WHEN 'Quiz 1: Limits & Continuity'                                   THEN 26  -- /30
    WHEN 'Unit Test I: Limits & Their Properties'                        THEN 88  -- /100
    WHEN 'Homework 2: Basic Differentiation Rules (Sections 2.1–2.3)'    THEN 44  -- /50
    WHEN 'Unit Test II: Differentiation'                                 THEN 96  -- /120
    WHEN 'Homework 3: Applications of Derivatives (Sections 3.1–3.7)'    THEN 52  -- /60
    WHEN 'Unit Test III: Applications of Differentiation'                THEN 90  -- /120
    -- Last two -> no score yet
    WHEN 'Homework 4: Integration & FTC'                                 THEN NULL
    WHEN 'Final Exam: Comprehensive Calculus I'                          THEN NULL
    ELSE a.points
  END AS score,
  a.due_at AS submitted_at,
  CASE
    WHEN a.assignment_name IN ('Homework 4: Integration & FTC',
                               'Final Exam: Comprehensive Calculus I')
      THEN 'submitted'
    ELSE 'graded'
  END AS status
FROM assignments a
JOIN classes cl  ON a.class_id   = cl.class_id
JOIN courses c   ON cl.course_id = c.course_id
WHERE c.course_name = 'MAT 171 - Unified Calculus I';

SET SQL_SAFE_UPDATES = 1;
