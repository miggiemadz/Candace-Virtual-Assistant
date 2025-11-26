INSERT INTO majors (major_id, major_name, department)
VALUES
  (1, 'A.S. Data Science', 'STEM'),
  (2, 'General Education', 'Liberal Arts');
INSERT INTO students (
    student_id,
    student_first_name,
    student_last_name,
    student_gpa,
    student_total_credits,
    major_id,
    has_account
) VALUES
(
    1000001,
    'Alex',
    'Rivera',
    3.7,
    14,         -- finished 14 credits in 1st semester
    1,          -- A.S. Data Science
    1           -- has an account
);
INSERT INTO professors (
    professor_id,
    professor_first_name,
    professor_last_name,
    department
) VALUES
  (2000001, 'Emilio', 'Vasquez', 'STEM'),
  (2000002, 'Karen', 'Liu', 'Mathematics'),
  (2000003, 'Lisa', 'Nguyen', 'English'),
  (2000004, 'James', 'Patel', 'Physics'),
  (2000005, 'Sofia', 'Martinez', 'Computer Science');
INSERT INTO courses (
    course_id,
    course_name,
    course_credits,
    major_id
) VALUES
  -- First semester (2025FA) - completed
  (101, 'ENG 101 - English Composition I',             3, 2),
  (102, 'PSY 101 - General Psychology',                3, 2),
  (103, 'MAT 171 - Unified Calculus I',                4, 1),
  (104, 'CST 161 - Computer Programming Fundamentals', 4, 1),
  -- Second semester (2026SP) - current
  (201, 'ENG 102 - English Composition II',            3, 2),
  (202, 'MAT 172 - Unified Calculus II',               4, 1),
  (203, 'PHY 111 - Mechanics',                         3, 1),
  (204, 'PHYL 111 - Mechanics Laboratory',             1, 1),
  (205, 'CST 162 - Computer Algorithms',               4, 1);
INSERT INTO classes (
    class_id,
    course_id,
    professor_id,
    class_type
) VALUES
  -- 2025FA classes (completed)
  (1001, 101, 2000003, 'Lecture'),  -- ENG 101 with Prof. Nguyen
  (1002, 102, 2000003, 'Lecture'),  -- PSY 101 (we reuse Nguyen for demo)
  (1003, 103, 2000002, 'Lecture'),  -- MAT 171 with Prof. Liu
  (1004, 104, 2000005, 'Lecture'),  -- CST 161 with Prof. Martinez
  -- 2026SP classes (current)
  (2001, 201, 2000003, 'Lecture'),  -- ENG 102 with Prof. Nguyen
  (2002, 202, 2000002, 'Lecture'),  -- MAT 172 with Prof. Liu
  (2003, 203, 2000004, 'Lecture'),  -- PHY 111 with Prof. Patel
  (2004, 204, 2000004, 'Lab'),      -- PHYL 111 with Prof. Patel
  (2005, 205, 2000005, 'Lecture');  -- CST 162 with Prof. Martinez
INSERT INTO schedule (student_id, class_id) VALUES
  -- 2025FA (previous courses)
  (1000001, 1001),
  (1000001, 1002),
  (1000001, 1003),
  (1000001, 1004),
  -- 2026SP (current courses)
  (1000001, 2001),
  (1000001, 2002),
  (1000001, 2003),
  (1000001, 2004),
  (1000001, 2005);
INSERT INTO assignments (
    assignment_id,
    class_id,
    assignment_name,
    assignment_type,
    assignment_score_weight,
    description,
    due_at,
    points,
    is_published
) VALUES
  (3001, 2001, 'Diagnostic Essay: Literacy Narrative', 'Essay', 0.05,
   'Write a 2–3 page narrative about a key experience that shaped how you read, write, or use language. Focus on clear organization and reflection.',
   '2026-02-01 23:59:00', 50, 1),
  (3002, 2001, 'Annotated Bibliography: Technology and Society', 'Essay', 0.10,
   'Find 5–7 scholarly or credible sources about how technology impacts communication, education, or identity. Summarize each source and explain its relevance to your research question.',
   '2026-02-15 23:59:00', 75, 1),
  (3003, 2001, 'Research Argument Essay Draft', 'Essay', 0.15,
   'Draft a 5–7 page argumentative essay using your annotated bibliography sources. Make a clear claim, support it with evidence, and address at least one counterargument.',
   '2026-03-05 23:59:00', 100, 1);
INSERT INTO assignments (
    assignment_id,
    class_id,
    assignment_name,
    assignment_type,
    assignment_score_weight,
    description,
    due_at,
    points,
    is_published
) VALUES
  (3101, 2002, 'Homework 1: Techniques of Integration', 'Homework', 0.05,
   'Solve 15 problems on integration by parts, trigonometric substitution, and partial fractions. Show all work and clearly label each step.',
   '2026-01-29 23:59:00', 40, 1),
  (3102, 2002, 'Quiz 1: Integration Review', 'Quiz', 0.05,
   'In-class quiz on basic antiderivatives, definite integrals, and the Fundamental Theorem of Calculus.',
   '2026-02-03 10:00:00', 30, 1),
  (3103, 2002, 'Homework 2: Sequences and Series', 'Homework', 0.05,
   'Complete 12 problems on sequences, series, and convergence tests (ratio test, root test, comparison test).',
   '2026-02-12 23:59:00', 40, 1);
INSERT INTO assignments (
    assignment_id,
    class_id,
    assignment_name,
    assignment_type,
    assignment_score_weight,
    description,
    due_at,
    points,
    is_published
) VALUES
  (3201, 2003, 'Homework 1: Kinematics in One Dimension', 'Homework', 0.04,
   'Solve problems on displacement, velocity, and acceleration using kinematic equations. Include diagrams where appropriate.',
   '2026-01-30 23:59:00', 35, 1),
  (3202, 2004, 'Lab 1: Motion on an Inclined Plane', 'Lab', 0.06,
   'Collect position–time data for a cart on an inclined track, create graphs, and calculate experimental acceleration. Submit a lab report with procedure, data, graphs, and conclusions.',
   '2026-02-04 23:59:00', 50, 1);
INSERT INTO assignments (
    assignment_id,
    class_id,
    assignment_name,
    assignment_type,
    assignment_score_weight,
    description,
    due_at,
    points,
    is_published
) VALUES
  (3301, 2005, 'Programming Assignment 1: Algorithm Analysis', 'Programming', 0.08,
   'Implement and compare the running time of linear search and binary search on sorted lists of different sizes. Submit your Python code and a short reflection on the observed time complexity.',
   '2026-02-02 23:59:00', 100, 1),
  (3302, 2005, 'Programming Assignment 2: Recursion Practice', 'Programming', 0.08,
   'Write recursive solutions for computing factorial, Fibonacci numbers, and a simple file-system traversal. Include brief comments explaining the base case and recursive step for each function.',
   '2026-02-09 23:59:00', 100, 1),
  (3303, 2005, 'Project 1: Sorting Algorithms Comparison', 'Project', 0.12,
   'Implement and empirically compare at least three sorting algorithms (e.g., bubble, insertion, merge, quicksort). Generate plots of running time vs. input size and write a short report connecting your results to Big-O notation.',
   '2026-02-23 23:59:00', 150, 1);
INSERT INTO work_load (student_id, assignment_id) VALUES
  -- ENG 102
  (1000001, 3001),
  (1000001, 3002),
  (1000001, 3003),
  -- MAT 172
  (1000001, 3101),
  (1000001, 3102),
  (1000001, 3103),
  -- PHY 111 / PHYL 111
  (1000001, 3201),
  (1000001, 3202),
  -- CST 162
  (1000001, 3301),
  (1000001, 3302),
  (1000001, 3303);
INSERT INTO users (email, password_hash, role)
VALUES (
  'alex.rivera@candace.local',
  'scrypt:32768:8:1$gElQ3Ga2wUCGxhRL$31bffa1e8edd85213711561eb8ef5a7558cc0a2d3d229dc12a406aaa9f3104659c64cc945477e87ead00881dfcf3f7bfc8da209efd6e65aa284eb4ad39610d98',
  'student'
);
UPDATE users
SET password_hash = 'scrypt:32768:8:1$gElQ3Ga2wUCGxhRL$31bffa1e8edd85213711561eb8ef5a7558cc0a2d3d229dc12a406aaa9f3104659c64cc945477e87ead00881dfcf3f7bfc8da209efd6e65aa284eb4ad39610d98',
    role = 'student'
WHERE email = 'alex.rivera@candace.local';
UPDATE students
SET user_id = 1
WHERE student_id = 1000001;
UPDATE users
SET student_id = 1000001
WHERE email = 'alex.rivera@candace.local';