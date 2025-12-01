-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: candace_assistant
-- ------------------------------------------------------
-- Server version	8.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ai_chat_log`
--

DROP TABLE IF EXISTS `ai_chat_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_chat_log` (
  `chat_log_id` int NOT NULL AUTO_INCREMENT,
  `student_id` int DEFAULT NULL,
  `chat_timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `ai_response` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`chat_log_id`),
  KEY `student_id` (`student_id`),
  CONSTRAINT `ai_chat_log_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai_chat_log`
--

LOCK TABLES `ai_chat_log` WRITE;
/*!40000 ALTER TABLE `ai_chat_log` DISABLE KEYS */;
INSERT INTO `ai_chat_log` VALUES (1,1000001,'2025-11-26 12:38:17','What are my courses?','You are enrolled in the following courses:\n- Intro to Programming (Class ID 1, 3 credits)\n- Data Structures (Class ID 2, 4 credits)'),(2,1000001,'2025-11-28 23:47:03','Who are all students?','I don\'t know. You can check the \"People\" page in the top navigation menu to view a list of all users in the system, or check the \"Course Roster\" page for each course to view the list of enrolled students and instructors.'),(3,1000001,'2025-11-28 23:47:51','who am I?','You are Alice Johnson, a Computer Science major with a GPA of 3.8 and 90 total credits.'),(4,1000001,'2025-11-28 23:49:45','who am I?','You are Alice Johnson, a Computer Science major with a GPA of 3.8 and 90 total credits.'),(5,1000001,'2025-11-29 13:54:25','who am I?','You are Alex Rivera, a Data Science major with a GPA of 3.70 and 14 total credits.'),(6,1000001,'2025-11-29 13:58:08','What type of questions can you answer?','I can answer questions about your courses, grades, and academic progress. I can also provide information about your enrolled courses, course details, and your overall academic standing.'),(7,1000001,'2025-11-29 14:44:35','Do I have assignments?','Yes, you have assignments in your enrolled courses. You can check the assignments for each course by going to the course navigation menu and clicking on the \"Assignments\" tab.'),(8,1000001,'2025-11-29 14:45:00','what assignments do I have?','I don\'t know. You can check the assignments for each course by going to the course navigation menu and clicking on the \"Assignments\" tab. You can also check the course syllabus or contact your instructor for more information.'),(9,1000001,'2025-11-29 15:08:49','what is my schedule?','You have the following courses enrolled: ENG 101, PSY 101, MAT 171, CST 161, ENG 102, MAT 172, PHY 111, PHYL 111, and CST 162. You can check the course schedule by going to the course navigation menu and clicking on the \"Schedule\" tab for each course. You can also check the course syllabus or contact your instructor for more information.'),(10,1000001,'2025-11-29 15:29:03','who am I?','You are Alex Rivera.'),(11,1000001,'2025-11-29 15:29:38','tell me about my profile','You are Alex Rivera, a student majoring in A.S. Data Science with a GPA of 3.70 and a total of 14 credits. You can view more information about your profile by clicking on your name in the top right corner of the screen and selecting \"Profile\" from the dropdown menu.'),(12,1000001,'2025-11-29 15:30:14','who are all people on your database?','I don\'t know. You can check the People page in Canvas by clicking on the \"People\" tab in the course navigation menu. This will show you a list of all users in your courses.'),(13,1000001,'2025-11-29 15:45:51','what are the modules of the course CST 162','I don\'t know. You can check the course settings for CST 162 by clicking on the course name in the course navigation menu and then selecting \"Settings\" from the course menu. This will show you the course details, including the modules.'),(14,1000001,'2025-11-29 15:46:22','what is the full name of the course CST 162','The full name of the course CST 162 is Computer Algorithms.'),(15,1000001,'2025-11-29 16:01:12','can you tell me about ai logs?','I don\'t know. You can check the Canvas documentation or the Help menu in Canvas for information on AI logs. Alternatively, you can contact your instructor or the Canvas support team for assistance.'),(16,1000001,'2025-11-29 16:03:58','what are the catalog of all courses?','I don\'t know. You can check the Canvas Catalog or the Institution\'s course catalog for a list of all available courses. You can also check with the Registrar\'s office or the academic department for more information.');
/*!40000 ALTER TABLE `ai_chat_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assignment_grades`
--

DROP TABLE IF EXISTS `assignment_grades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assignment_grades` (
  `student_id` int NOT NULL,
  `assignment_id` int NOT NULL,
  `score` decimal(6,2) DEFAULT NULL,
  `submitted_at` datetime DEFAULT NULL,
  `status` enum('not_assigned','not_submitted','submitted','graded','late') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'not_assigned',
  PRIMARY KEY (`student_id`,`assignment_id`),
  KEY `assignment_id` (`assignment_id`),
  CONSTRAINT `assignment_grades_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `assignment_grades_ibfk_2` FOREIGN KEY (`assignment_id`) REFERENCES `assignments` (`assignment_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assignment_grades`
--

LOCK TABLES `assignment_grades` WRITE;
/*!40000 ALTER TABLE `assignment_grades` DISABLE KEYS */;
/*!40000 ALTER TABLE `assignment_grades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assignments`
--

DROP TABLE IF EXISTS `assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assignments` (
  `assignment_id` int NOT NULL AUTO_INCREMENT,
  `class_id` int NOT NULL,
  `assignment_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `assignment_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `assignment_score_weight` decimal(4,2) DEFAULT NULL,
  `due_at` datetime DEFAULT NULL,
  `max_points` int NOT NULL DEFAULT '100',
  `description` text COLLATE utf8mb4_unicode_ci,
  `points` int DEFAULT NULL,
  `is_published` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`assignment_id`),
  KEY `class_id` (`class_id`),
  CONSTRAINT `assignments_ibfk_1` FOREIGN KEY (`class_id`) REFERENCES `classes` (`class_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3408 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assignments`
--

LOCK TABLES `assignments` WRITE;
/*!40000 ALTER TABLE `assignments` DISABLE KEYS */;
INSERT INTO `assignments` VALUES (3001,2001,'Diagnostic Essay: Literacy Narrative','Essay',0.05,'2026-02-01 23:59:00',100,'Write a 2–3 page narrative about a key experience that shaped how you read, write, or use language. Focus on clear organization and reflection.',50,1),(3002,2001,'Annotated Bibliography: Technology and Society','Essay',0.10,'2026-02-15 23:59:00',100,'Find 5–7 scholarly or credible sources about how technology impacts communication, education, or identity. Summarize each source and explain its relevance to your research question.',75,1),(3003,2001,'Research Argument Essay Draft','Essay',0.15,'2026-03-05 23:59:00',100,'Draft a 5–7 page argumentative essay using your annotated bibliography sources. Make a clear claim, support it with evidence, and address at least one counterargument.',100,1),(3101,2002,'Homework 1: Techniques of Integration','Homework',0.05,'2026-01-29 23:59:00',100,'Solve 15 problems on integration by parts, trigonometric substitution, and partial fractions. Show all work and clearly label each step.',40,1),(3102,2002,'Quiz 1: Integration Review','Quiz',0.05,'2026-02-03 10:00:00',100,'In-class quiz on basic antiderivatives, definite integrals, and the Fundamental Theorem of Calculus.',30,1),(3103,2002,'Homework 2: Sequences and Series','Homework',0.05,'2026-02-12 23:59:00',100,'Complete 12 problems on sequences, series, and convergence tests (ratio test, root test, comparison test).',40,1),(3201,2003,'Homework 1: Kinematics in One Dimension','Homework',0.04,'2026-01-30 23:59:00',100,'Solve problems on displacement, velocity, and acceleration using kinematic equations. Include diagrams where appropriate.',35,1),(3202,2004,'Lab 1: Motion on an Inclined Plane','Lab',0.06,'2026-02-04 23:59:00',100,'Collect position–time data for a cart on an inclined track, create graphs, and calculate experimental acceleration. Submit a lab report with procedure, data, graphs, and conclusions.',50,1),(3301,2005,'Programming Assignment 1: Algorithm Analysis','Programming',0.08,'2026-02-02 23:59:00',100,'Implement and compare the running time of linear search and binary search on sorted lists of different sizes. Submit your Python code and a short reflection on the observed time complexity.',100,1),(3302,2005,'Programming Assignment 2: Recursion Practice','Programming',0.08,'2026-02-09 23:59:00',100,'Write recursive solutions for computing factorial, Fibonacci numbers, and a simple file-system traversal. Include brief comments explaining the base case and recursive step for each function.',100,1),(3303,2005,'Project 1: Sorting Algorithms Comparison','Project',0.12,'2026-02-23 23:59:00',100,'Implement and empirically compare at least three sorting algorithms (e.g., bubble, insertion, merge, quicksort). Generate plots of running time vs. input size and write a short report connecting your results to Big-O notation.',150,1),(3304,1004,'Getting Started: Canvas & zyBooks Setup','homework',0.03,'2025-09-05 23:59:00',20,'Confirm access to Canvas and zyBooks, review the syllabus, and submit the introductory survey.',20,1),(3305,1004,'Lab 1: Intro to Python & Ethics Reflection','lab',0.05,'2025-09-12 23:59:00',40,'Write and run your first simple Python programs and submit a short reflection on the ACM Code of Ethics.',40,1),(3306,1004,'Homework 1: Variables & Expressions','homework',0.05,'2025-09-19 23:59:00',40,'Solve practice problems involving variables, expressions, and basic I/O in Python.',40,1),(3307,1004,'Homework 2: Decision Structures','homework',0.05,'2025-09-26 23:59:00',40,'Write programs that use if/elif/else to implement basic decision-making logic.',40,1),(3308,1004,'Semester Exam I: Chapters 1–3','exam',0.12,'2025-09-30 18:00:00',100,'In-class exam covering introduction to Python, variables and expressions, and decision structures.',100,1),(3309,1004,'Homework 3: Loops','homework',0.06,'2025-10-10 23:59:00',50,'Practice using while and for loops to solve repetition problems.',50,1),(3310,1004,'Project 1: Lists & Dictionaries Mini-Project','project',0.10,'2025-10-24 23:59:00',100,'Build a small Python application that stores and processes data using lists and dictionaries.',100,1),(3311,1004,'Quiz: Number Systems','quiz',0.04,'2025-10-31 23:59:00',30,'Short quiz on binary, octal, decimal, and hexadecimal representations and conversions.',30,1),(3312,1004,'Semester Exam II: Loops, Data Structures & Number Systems','exam',0.15,'2025-11-05 18:00:00',120,'Second semester exam covering loops, lists/dictionaries, and number systems.',120,1),(3313,1004,'Homework 4: Files, Strings & Exceptions','homework',0.07,'2025-11-19 23:59:00',60,'Write programs that read/write text files, process strings, and use basic exception handling.',60,1),(3314,1004,'Project 2: Final Programming Project','project',0.13,'2025-12-03 23:59:00',150,'Design and implement a small Python program that ties together course topics.',150,1),(3315,1004,'Final Exam: Comprehensive','exam',0.15,'2025-12-10 18:00:00',150,'Comprehensive final exam covering Chapters 1–10 plus number systems and digital logic.',150,1),(3316,2005,'Programming Assignment 1: Java Basics (Ch. 1–2)','homework',0.06,'2026-01-30 23:59:00',40,'Write several small Java programs that compile and run from the command line, demonstrating console I/O and basic variables.',40,1),(3317,2005,'Programming Assignment 2: Decisions (Ch. 5)','homework',0.06,'2026-02-06 23:59:00',40,'Programs that use selection structures (if/else, switch) and logical operators to make decisions.',40,1),(3318,2005,'Semester Exam I: Java Basics & Decisions','exam',0.12,'2026-02-11 18:00:00',100,'In-class exam covering Chapters 1, 2 and 5: basic Java programs, data, and decision structures.',100,1),(3319,2005,'Project 1: Object-Oriented Java Program','project',0.08,'2026-02-27 23:59:00',80,'Design and implement an object-oriented Java application using user-defined classes, methods, constructors, and encapsulation.',80,1),(3320,2005,'Semester Exam II: Classes & Objects','exam',0.13,'2026-03-13 18:00:00',110,'Exam on Chapter 3 and 4 topics: methods, classes, objects, overloading, and more object concepts.',110,1),(3321,2005,'Programming Assignment 3: Looping (Ch. 6)','homework',0.06,'2026-03-20 23:59:00',40,'Write Java programs using while, do-while, and for loops, including nested loops and sentinel-controlled repetition.',40,1),(3322,2005,'Programming Assignment 4: Arrays & Searching (Ch. 8–9)','homework',0.06,'2026-04-03 23:59:00',50,'Programs that use one- and two-dimensional arrays, simple searching and sorting algorithms, and array processing.',50,1),(3323,2005,'Semester Exam III: Loops & Arrays','exam',0.10,'2026-04-10 18:00:00',100,'Exam on Chapters 6, 8 and 9 covering loops, arrays, and advanced array concepts.',100,1),(3324,2005,'Programming Assignment 5: Exceptions & File I/O (Ch. 12–13)','homework',0.08,'2026-04-17 23:59:00',60,'Write programs that use try/catch blocks, exception classes, and text file input/output for persistent storage.',60,1),(3325,2005,'Project 2: Swing GUI Application','project',0.10,'2026-04-24 23:59:00',120,'Final programming project building a small GUI application using Swing components, events, and good OO design.',120,1),(3326,2005,'Final Exam: Comprehensive Java & Algorithms','exam',0.15,'2026-05-01 18:00:00',150,'Comprehensive final covering Chapters 3–14: methods, classes, loops, arrays, exceptions, file I/O, and Swing.',150,1),(3327,1001,'Diagnostic Writing','in-class',0.02,'2025-09-05 23:59:00',20,'Initial diagnostic writing sample used to assess incoming writing level.',20,1),(3328,1001,'Draft: Reflection/Narration Essay','draft',0.03,'2025-09-19 23:59:00',30,'Rough draft of the first major essay based on narrative/description.',30,1),(3329,1001,'Diagnostic Writing','in-class',0.02,'2025-09-05 23:59:00',20,'Initial diagnostic writing sample used to assess incoming writing level.',20,1),(3330,1001,'Draft: Reflection/Narration Essay','draft',0.03,'2025-09-19 23:59:00',30,'Rough draft of the first major essay based on narrative/description.',30,1),(3331,1001,'Final Reflection/Narrative Essay','essay',0.10,'2025-09-26 23:59:00',100,'Final polished version of the personal narrative/reflection essay.',100,1),(3332,1001,'Draft: Comparison/Contrast Essay','draft',0.04,'2025-10-10 23:59:00',40,'Draft of the comparison/contrast essay including peer review exercises.',40,1),(3333,1001,'Final Comparison/Contrast Essay','essay',0.12,'2025-10-17 23:59:00',100,'Revised and finalized comparison/contrast essay.',100,1),(3334,1001,'Draft: Research Essay','draft',0.05,'2025-11-01 23:59:00',40,'Draft of research-based essay including MLA citations.',40,1),(3335,1001,'Citation Quiz (MLA Format)','quiz',0.03,'2025-11-05 23:59:00',20,'Quiz assessing MLA formatting, in-text citations, and Works Cited fundamentals.',20,1),(3336,1001,'Final Research Essay','essay',0.18,'2025-11-12 23:59:00',120,'Final research essay demonstrating information literacy and proper MLA citation.',120,1),(3337,1001,'Draft: Critical Analysis Essay','draft',0.04,'2025-11-29 23:59:00',40,'Rough draft analyzing a selected written or visual text.',40,1),(3338,1001,'Final Critical Analysis Essay','essay',0.15,'2025-12-06 23:59:00',120,'Final revised version of the critical analysis essay.',120,1),(3339,1001,'Final Exam','exam',0.14,'2025-12-15 18:00:00',150,'Comprehensive final exam assessing writing process, critical thinking, and MLA skills.',150,1),(3340,2001,'Reading Response 1: Chopin & Joyce','response',0.04,'2026-02-06 23:59:00',40,'Short critical response to Chopin’s \"The Story of an Hour\" and Joyce’s \"Araby\".',40,1),(3341,2001,'Literary Terms Quiz','quiz',0.05,'2026-02-20 23:59:00',25,'Quiz on key literary terms introduced through Faulkner’s \"A Rose for Emily\".',25,1),(3342,2001,'Reading Response 2: Hurston & Baldwin','response',0.04,'2026-02-27 23:59:00',40,'Response paper comparing themes and style in Hurston’s \"Sweat\" and Baldwin’s \"Sonny’s Blues\".',40,1),(3343,2001,'Citation Quiz: MLA Documentation','quiz',0.05,'2026-03-06 23:59:00',25,'Quiz on MLA in-text citations and Works Cited formatting based on short fiction readings.',25,1),(3344,2001,'Reading Response 3: Atwood & Carver','response',0.04,'2026-03-20 23:59:00',40,'Critical response to Margaret Atwood’s and Raymond Carver’s short stories with focus on theme and style.',40,1),(3345,2001,'Midterm Literary Analysis Exam / Paper','exam',0.15,'2026-03-27 18:00:00',100,'Midterm exam or literary analysis paper synthesizing short fiction studied in the first half of the course.',100,1),(3346,2001,'Close Reading Poetry Paper','paper',0.10,'2026-04-03 23:59:00',80,'Short paper performing a close reading of one or more poems from the Poetry Unit.',80,1),(3347,2001,'Poetry Quiz','quiz',0.06,'2026-04-10 23:59:00',30,'Quiz on poetic terminology, forms, and interpretation from the Poetry Unit.',30,1),(3348,2001,'Research Paper Draft','draft',0.12,'2026-04-24 23:59:00',80,'Complete draft of the ENG 102 research paper in MLA format for peer review and instructor feedback.',80,1),(3349,2001,'Final Research Paper','paper',0.20,'2026-05-08 23:59:00',120,'Final revised ENG 102 research paper demonstrating literary analysis, research, and MLA documentation.',120,1),(3350,2001,'Final Exam: Literature & Composition','exam',0.15,'2026-05-12 18:00:00',150,'Comprehensive final exam on fiction, poetry, drama, and research writing from ENG 102.',150,1),(3351,1003,'Diagnostic Skills Quiz (Precalculus Review)','quiz',0.02,'2025-09-05 23:59:00',20,'Short quiz on prerequisite algebra and trigonometry skills to identify review needs.',20,1),(3352,1003,'Homework 1: Limits & Continuity (Sections 1.1–1.4)','homework',0.06,'2025-09-12 23:59:00',40,'Homework set on numeric, graphical, and analytic limits plus continuity and infinite limits.',40,1),(3353,1003,'Quiz 1: Limits & Continuity','quiz',0.04,'2025-09-19 23:59:00',30,'Quiz covering limit computation, continuity, and infinite limits.',30,1),(3354,1003,'Unit Test I: Limits & Their Properties','exam',0.10,'2025-09-23 18:00:00',100,'In-class exam on Unit I topics (preview of calculus, limits, continuity, infinite limits).',100,1),(3355,1003,'Homework 2: Basic Differentiation Rules (Sections 2.1–2.3)','homework',0.08,'2025-10-03 23:59:00',50,'Exercises on derivative definition, basic rules, and product/quotient rules.',50,1),(3356,1003,'Unit Test II: Differentiation','exam',0.16,'2025-10-10 18:00:00',120,'Exam on basic rules, chain rule, implicit differentiation, and related rates.',120,1),(3357,1003,'Homework 3: Applications of Derivatives (Sections 3.1–3.7)','homework',0.08,'2025-10-24 23:59:00',60,'Problems on extrema, MVT, increasing/decreasing tests, concavity, curve sketching, and optimization.',60,1),(3358,1003,'Unit Test III: Applications of Differentiation','exam',0.16,'2025-11-07 18:00:00',120,'Exam on Unit III topics including curve sketching, optimization, and differentials.',120,1),(3359,1003,'Homework 4: Integration & FTC','homework',0.09,'2025-11-28 23:59:00',70,'Exercises on antiderivatives, definite integrals, Fundamental Theorem of Calculus, and substitution.',70,1),(3360,1003,'Final Exam: Comprehensive Calculus I','exam',0.31,'2025-12-15 18:00:00',150,'Comprehensive final exam covering limits, differentiation, applications, and integration.',150,1),(3361,2002,'Quiz 1: Bases, L’Hôpital’s Rule, Inverse Trig','quiz',0.04,'2026-01-24 23:59:00',25,'Covers exponential bases other than e, L’Hôpital’s Rule, and inverse trig differentiation.',25,1),(3362,2002,'Unit Test 1: Limits, Inverse Trig, Hyperbolic, Diff Eq','exam',0.12,'2026-02-07 18:00:00',100,'Covers Chapters 5.5–5.9 and 6.2: bases, indeterminate forms, inverse trig, hyperbolic functions, growth & decay.',100,1),(3363,2002,'Homework 1: Areas, Volumes, Work, Centroids','homework',0.08,'2026-02-21 23:59:00',50,'Practice problems on area between curves, disk/shell methods, arc length, work, and centroids.',50,1),(3364,2002,'Unit Test 2: Applications of Integration','exam',0.14,'2026-02-28 18:00:00',120,'Covers Chapter 7 (Areas, Volumes, Work, Centroids).',120,1),(3365,2002,'Homework 2: Integration Techniques (Parts, Trig, Substitution)','homework',0.08,'2026-03-14 23:59:00',60,'Problems on integration by parts, trig integrals, trig substitution, and partial fractions.',60,1),(3366,2002,'Unit Test 3: Integration Techniques & Improper Integrals','exam',0.16,'2026-03-21 18:00:00',120,'Covers Chapters 8.1–8.8: integration rules, parts, trig integrals, substitution, partial fractions, improper integrals.',120,1),(3367,2002,'Homework 3: Sequences & Series Tests','homework',0.06,'2026-04-04 23:59:00',60,'Exercises on convergence tests: p-series, comparison test, alternating series, ratio/root tests.',60,1),(3368,2002,'Unit Test 4: Series & Taylor/Maclaurin','exam',0.18,'2026-04-18 18:00:00',120,'Covers Chapters 9.1–9.10: sequences, series tests, power series, Taylor/Maclaurin.',120,1),(3369,2002,'Final Exam: Comprehensive Calculus II','exam',0.22,'2026-05-02 18:00:00',150,'Covers entire MAT 172 curriculum including integration, applications, series, conics, and parametric equations.',150,1),(3370,2003,'Homework 1: Units, Vectors & 1D Kinematics','homework',0.04,'2026-02-01 23:59:00',40,'Problem set on unit conversions, vector components, and one-dimensional motion with constant acceleration.',40,1),(3371,2003,'Homework 2: 2D Motion & Newton\'s Laws','homework',0.04,'2026-02-22 23:59:00',40,'Problems on projectile motion, free-body diagrams, friction, and motion on inclines.',40,1),(3372,2003,'Homework 3: Work, Energy & Power','homework',0.04,'2026-03-15 23:59:00',40,'Exercises on work, kinetic and potential energy, conservation of mechanical energy, and power.',40,1),(3373,2003,'Homework 4: Momentum, Rotation & Equilibrium','homework',0.03,'2026-04-05 23:59:00',40,'Problems on linear momentum, collisions, rotational dynamics, static equilibrium and elasticity.',40,1),(3374,2003,'Participation & Weekly Labs','participation',0.10,'2026-05-03 23:59:00',100,'Overall participation, in-class work, and completion of weekly lab activities throughout the semester.',100,1),(3375,2003,'Test 1: Intro, Units, Vectors & Math Tools (Ch 1, 3)','exam',0.10,'2026-02-05 18:00:00',100,'Covers course introduction, units and dimensions, significant figures, and vector algebra.',100,1),(3376,2003,'Test 2: Kinematics in 1D & 2D (Ch 2, 4)','exam',0.10,'2026-02-19 18:00:00',100,'Covers 1D and 2D kinematics, graphical analysis, and projectile motion.',100,1),(3377,2003,'Test 3: Newton\'s Laws & Circular Motion (Ch 5, 6)','exam',0.10,'2026-03-08 18:00:00',100,'Covers forces, Newton’s laws, friction, free-body diagrams, and circular motion.',100,1),(3378,2003,'Test 4: Energy & Momentum (Ch 7, 8, 9)','exam',0.10,'2026-03-29 18:00:00',100,'Covers work, energy, conservation of energy, momentum, impulse, and collisions.',100,1),(3379,2003,'Test 5: Rotation, Equilibrium & Fluids (Ch 10, 11, 12)','exam',0.10,'2026-04-19 18:00:00',100,'Covers rotational dynamics, static equilibrium, elasticity, and fluid statics/dynamics.',100,1),(3380,2003,'Final Exam: Comprehensive Mechanics','exam',0.25,'2026-05-03 18:00:00',150,'Comprehensive final exam covering all PHY 111 mechanics topics.',150,1),(3381,2004,'Lab Report 1: Safety, Excel & Measurement','lab',0.05,'2026-01-24 23:59:00',40,'Group/individual lab report for Lab 1 covering safety procedures, spreadsheet use, and basic measurements.',40,1),(3382,2004,'Lab Report 2: Force Table','lab',0.05,'2026-01-31 23:59:00',40,'Lab report analyzing vector addition and equilibrium using the force table experiment.',40,1),(3383,2004,'Lab Report 3: Acceleration due to Gravity','lab',0.05,'2026-02-14 23:59:00',40,'Combined report for Lab 3 parts 1–3 determining g using different experimental setups.',40,1),(3384,2004,'Lab Report 4: Projectile Motion','lab',0.05,'2026-02-28 23:59:00',40,'Report for Lab 4 parts 1–2 analyzing projectile motion and comparison with kinematics predictions.',40,1),(3385,2004,'Lab Report 5: Newton\'s Laws','lab',0.05,'2026-03-07 23:59:00',40,'Report for Lab 5 investigating Newton’s laws using carts, masses, and force sensors.',40,1),(3386,2004,'Lab Report 6: Inclined Plane','lab',0.05,'2026-03-21 23:59:00',40,'Lab report analyzing motion on an inclined plane and comparison to theoretical predictions.',40,1),(3387,2004,'Lab Report 7: Circular Motion','lab',0.05,'2026-03-28 23:59:00',40,'Report for Lab 7 measuring centripetal force and acceleration in circular motion.',40,1),(3388,2004,'Lab Report 8: Conservation of Energy','lab',0.05,'2026-04-11 23:59:00',40,'Lab report on energy transformations and verification of mechanical energy conservation.',40,1),(3389,2004,'Lab Report 9: Torque','lab',0.05,'2026-04-18 23:59:00',40,'Report for Lab 9 exploring torque, rotational equilibrium, and center of mass.',40,1),(3390,2004,'Experiential Learning Reflection','project',0.10,'2026-04-25 23:59:00',50,'Short reflection connecting a PHYL 111 lab experience to career or real-world applications, supporting experiential learning outcomes.',50,1),(3391,2004,'Participation & Lab Skills','participation',0.15,'2026-05-02 23:59:00',100,'Overall participation, teamwork, proper lab procedures, and timely completion of group reports throughout the semester.',100,1),(3392,2004,'Final Lab Exam','exam',0.30,'2026-05-02 18:00:00',100,'Comprehensive final lab exam and/or practical evaluation covering all PHYL 111 experiments.',100,1),(3393,1002,'Quiz 1: What is Psychology?','quiz',0.03,'2025-09-05 23:59:00',20,'Quiz on Chapter 1 covering definitions, history, and major perspectives in psychology.',20,1),(3394,1002,'Quiz 2: Biology and Psychology','quiz',0.03,'2025-09-12 23:59:00',20,'Quiz on Chapter 2 covering neurons, the nervous system, and brain–behavior relationships.',20,1),(3395,1002,'Quiz 3: Sensation and Perception','quiz',0.03,'2025-09-19 23:59:00',20,'Quiz on Chapter 3 covering sensory processes and perceptual organization.',20,1),(3396,1002,'Quiz 4: Consciousness','quiz',0.03,'2025-09-26 23:59:00',20,'Quiz on Chapter 4 covering sleep, dreams, psychoactive drugs, and states of consciousness.',20,1),(3397,1002,'Quiz 5: Learning','quiz',0.03,'2025-10-03 23:59:00',20,'Quiz on Chapter 5 covering classical and operant conditioning and observational learning.',20,1),(3398,1002,'Information Literacy Project / Midterm','project',0.10,'2025-10-10 23:59:00',60,'Library-based information literacy project and/or midterm exam connecting research skills to psychology.',60,1),(3399,1002,'Quiz 6: Memory','quiz',0.03,'2025-10-17 23:59:00',20,'Quiz on Chapter 6 covering encoding, storage, retrieval, and forgetting.',20,1),(3400,1002,'Quiz 7: Thinking, Language, and Intelligence','quiz',0.03,'2025-10-24 23:59:00',20,'Quiz on Chapter 7 covering problem solving, decision making, language, and intelligence.',20,1),(3401,1002,'Quiz 8: Motivation and Emotion','quiz',0.03,'2025-10-31 23:59:00',20,'Quiz on Chapter 8 covering theories of motivation and emotion.',20,1),(3402,1002,'Evaluation Exam / Applied Paper','exam',0.12,'2025-11-07 18:00:00',100,'Evaluation exam or applied paper synthesizing major concepts from the first half of the course.',100,1),(3403,1002,'Quiz 9: The Voyage Through the Life Span','quiz',0.03,'2025-11-14 23:59:00',20,'Quiz on Chapter 9 covering developmental psychology across the life span.',20,1),(3404,1002,'Quiz 10: Personality','quiz',0.03,'2025-11-21 23:59:00',20,'Quiz on Chapter 10 covering major theories and assessment of personality.',20,1),(3405,1002,'Quiz 11: Psychological Disorders','quiz',0.03,'2025-11-28 23:59:00',20,'Quiz on Chapter 12 covering classification, symptoms, and perspectives on psychological disorders.',20,1),(3406,1002,'Quiz 12: Social Psychology','quiz',0.03,'2025-12-05 23:59:00',20,'Quiz on Chapter 14 covering attitudes, conformity, group behavior, and prejudice.',20,1),(3407,1002,'Final Exam / Research Paper','exam',0.18,'2025-12-15 18:00:00',150,'Comprehensive final exam and/or research paper integrating major topics in general psychology.',150,1);
/*!40000 ALTER TABLE `assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `classes`
--

DROP TABLE IF EXISTS `classes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `classes` (
  `class_id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL,
  `professor_id` int NOT NULL,
  `class_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`class_id`),
  KEY `course_id` (`course_id`),
  KEY `professor_id` (`professor_id`),
  CONSTRAINT `classes_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `classes_ibfk_2` FOREIGN KEY (`professor_id`) REFERENCES `professors` (`professor_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2006 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `classes`
--

LOCK TABLES `classes` WRITE;
/*!40000 ALTER TABLE `classes` DISABLE KEYS */;
INSERT INTO `classes` VALUES (1001,101,2000006,'Lecture'),(1002,102,2000006,'Lecture'),(1003,103,2000008,'Lecture'),(1004,104,2000010,'Lecture'),(2001,201,2000007,'Lecture'),(2002,202,2000009,'Lecture'),(2003,203,2000012,'Lecture'),(2004,204,2000013,'Lab'),(2005,205,2000011,'Lecture');
/*!40000 ALTER TABLE `classes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_announcements`
--

DROP TABLE IF EXISTS `course_announcements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_announcements` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_id` int NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `body` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `posted_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `author_professor_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `class_id` (`class_id`),
  KEY `author_professor_id` (`author_professor_id`),
  CONSTRAINT `course_announcements_ibfk_1` FOREIGN KEY (`class_id`) REFERENCES `classes` (`class_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `course_announcements_ibfk_2` FOREIGN KEY (`author_professor_id`) REFERENCES `professors` (`professor_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_announcements`
--

LOCK TABLES `course_announcements` WRITE;
/*!40000 ALTER TABLE `course_announcements` DISABLE KEYS */;
/*!40000 ALTER TABLE `course_announcements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_cengage_links`
--

DROP TABLE IF EXISTS `course_cengage_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_cengage_links` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_id` int NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `class_id` (`class_id`),
  CONSTRAINT `course_cengage_links_ibfk_1` FOREIGN KEY (`class_id`) REFERENCES `classes` (`class_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_cengage_links`
--

LOCK TABLES `course_cengage_links` WRITE;
/*!40000 ALTER TABLE `course_cengage_links` DISABLE KEYS */;
/*!40000 ALTER TABLE `course_cengage_links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_files`
--

DROP TABLE IF EXISTS `course_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_files` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_id` int NOT NULL,
  `folder` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_size_kb` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `class_id` (`class_id`),
  CONSTRAINT `course_files_ibfk_1` FOREIGN KEY (`class_id`) REFERENCES `classes` (`class_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_files`
--

LOCK TABLES `course_files` WRITE;
/*!40000 ALTER TABLE `course_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `course_files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_module_items`
--

DROP TABLE IF EXISTS `course_module_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_module_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `module_id` int NOT NULL,
  `item_type` enum('page','assignment','quiz','file','external') COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `assignment_id` int DEFAULT NULL,
  `external_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `position` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `module_id` (`module_id`),
  KEY `assignment_id` (`assignment_id`),
  CONSTRAINT `course_module_items_ibfk_1` FOREIGN KEY (`module_id`) REFERENCES `course_modules` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `course_module_items_ibfk_2` FOREIGN KEY (`assignment_id`) REFERENCES `assignments` (`assignment_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_module_items`
--

LOCK TABLES `course_module_items` WRITE;
/*!40000 ALTER TABLE `course_module_items` DISABLE KEYS */;
INSERT INTO `course_module_items` VALUES (1,1,'assignment','Getting Started: Canvas & zyBooks Setup',3304,NULL,1),(2,2,'assignment','Lab 1: Intro to Python & Ethics Reflection',3305,NULL,1),(3,3,'assignment','Homework 1: Variables & Expressions',3306,NULL,1),(4,4,'assignment','Homework 2: Decision Structures',3307,NULL,1),(5,5,'assignment','Semester Exam I: Chapters 1–3',3308,NULL,1),(6,6,'assignment','Homework 3: Loops',3309,NULL,1),(7,8,'assignment','Project 1: Lists & Dictionaries Mini-Project',3310,NULL,1),(8,9,'assignment','Quiz: Number Systems',3311,NULL,1),(9,10,'assignment','Semester Exam II',3312,NULL,1),(10,12,'assignment','Homework 4: Files, Strings & Exceptions',3313,NULL,1),(11,13,'assignment','Project 2: Final Programming Project',3314,NULL,1),(12,15,'assignment','Final Exam: Comprehensive',3315,NULL,1),(13,17,'assignment','Programming Assignment 1: Java Basics',3316,NULL,1),(14,18,'assignment','Programming Assignment 2: Decisions',3317,NULL,1),(15,19,'assignment','Semester Exam I: Java Basics & Decisions',3318,NULL,1),(16,22,'assignment','Project 1: Object-Oriented Java Program',3319,NULL,1),(17,23,'assignment','Semester Exam II: Classes & Objects',3320,NULL,1),(18,24,'assignment','Programming Assignment 3: Looping',3321,NULL,1),(19,26,'assignment','Programming Assignment 4: Arrays & Searching',3322,NULL,1),(20,27,'assignment','Semester Exam III: Loops & Arrays',3323,NULL,1),(21,28,'assignment','Programming Assignment 5: Exceptions & File I/O',3324,NULL,1),(22,29,'assignment','Project 2: Swing GUI Application',3325,NULL,1),(23,30,'assignment','Final Exam: Comprehensive Java & Algorithms',3326,NULL,1),(24,31,'assignment','Diagnostic Writing',3329,NULL,1),(25,33,'assignment','Draft: Reflection/Narration Essay',3330,NULL,1),(26,34,'assignment','Final Reflection/Narrative Essay',3331,NULL,1),(27,36,'assignment','Draft: Comparison/Contrast Essay',3332,NULL,1),(28,37,'assignment','Final Comparison/Contrast Essay',3333,NULL,1),(29,40,'assignment','Draft: Research Essay',3334,NULL,1),(30,41,'assignment','Citation Quiz (MLA Format)',3335,NULL,1),(31,42,'assignment','Final Research Essay',3336,NULL,1),(32,44,'assignment','Draft: Critical Analysis Essay',3337,NULL,1),(33,45,'assignment','Final Critical Analysis Essay',3338,NULL,1),(34,45,'assignment','Final Exam',3339,NULL,2),(35,47,'assignment','Reading Response 1: Chopin & Joyce',3340,NULL,1),(36,49,'assignment','Literary Terms Quiz',3341,NULL,1),(37,50,'assignment','Reading Response 2: Hurston & Baldwin',3342,NULL,1),(38,51,'assignment','Citation Quiz: MLA Documentation',3343,NULL,1),(39,53,'assignment','Reading Response 3: Atwood & Carver',3344,NULL,1),(40,54,'assignment','Midterm Literary Analysis Exam / Paper',3345,NULL,1),(41,55,'assignment','Close Reading Poetry Paper',3346,NULL,1),(42,56,'assignment','Poetry Quiz',3347,NULL,1),(43,59,'assignment','Research Paper Draft',3348,NULL,1),(44,60,'assignment','Final Research Paper',3349,NULL,1),(45,60,'assignment','Final Exam: Literature & Composition',3350,NULL,2),(46,61,'assignment','Diagnostic Skills Quiz (Precalculus Review)',3351,NULL,1),(47,62,'assignment','Homework 1: Limits & Continuity (Sections 1.1–1.4)',3352,NULL,1),(48,63,'assignment','Quiz 1: Limits & Continuity',3353,NULL,1),(49,63,'assignment','Unit Test I: Limits & Their Properties',3354,NULL,2),(50,65,'assignment','Homework 2: Basic Differentiation Rules (Sections 2.1–2.3)',3355,NULL,1),(51,66,'assignment','Unit Test II: Differentiation',3356,NULL,1),(52,68,'assignment','Homework 3: Applications of Derivatives (Sections 3.1–3.7)',3357,NULL,1),(53,70,'assignment','Unit Test III: Applications of Differentiation',3358,NULL,1),(54,73,'assignment','Homework 4: Integration & FTC',3359,NULL,1),(55,75,'assignment','Final Exam: Comprehensive Calculus I',3360,NULL,1),(56,76,'assignment','Quiz 1: Bases & L’Hôpital',3361,NULL,1),(57,78,'assignment','Unit Test 1',3362,NULL,1),(58,80,'assignment','Homework 1: Areas & Volumes',3363,NULL,1),(59,81,'assignment','Unit Test 2',3364,NULL,1),(60,83,'assignment','Homework 2: Integration Techniques',3365,NULL,1),(61,84,'assignment','Unit Test 3',3366,NULL,1),(62,86,'assignment','Homework 3: Series Tests',3367,NULL,1),(63,89,'assignment','Unit Test 4',3368,NULL,1),(64,90,'assignment','Final Exam: Comprehensive Calculus II',3369,NULL,1),(65,91,'assignment','Homework 1: Units, Vectors & 1D Kinematics',3370,NULL,1),(66,92,'assignment','Test 1: Intro, Units, Vectors & Math Tools',3375,NULL,1),(67,93,'assignment','Test 2: Kinematics in 1D & 2D',3376,NULL,1),(68,94,'assignment','Homework 2: 2D Motion & Newton\'s Laws',3371,NULL,1),(69,97,'assignment','Test 3: Newton\'s Laws & Circular Motion',3377,NULL,1),(70,98,'assignment','Homework 3: Work, Energy & Power',3372,NULL,1),(71,100,'assignment','Test 4: Energy & Momentum',3378,NULL,1),(72,102,'assignment','Homework 4: Momentum, Rotation & Equilibrium',3373,NULL,1),(73,104,'assignment','Test 5: Rotation, Equilibrium & Fluids',3379,NULL,1),(74,105,'assignment','Participation & Weekly Labs',3374,NULL,1),(75,105,'assignment','Final Exam: Comprehensive Mechanics',3380,NULL,2),(76,106,'assignment','Lab Report 1: Safety, Excel & Measurement',3381,NULL,1),(77,108,'assignment','Lab Report 2: Force Table',3382,NULL,1),(78,109,'assignment','Lab Report 3: Acceleration due to Gravity',3383,NULL,1),(79,111,'assignment','Lab Report 4: Projectile Motion',3384,NULL,1),(80,113,'assignment','Lab Report 5: Newton\'s Laws',3385,NULL,1),(81,114,'assignment','Lab Report 6: Inclined Plane',3386,NULL,1),(82,115,'assignment','Lab Report 7: Circular Motion',3387,NULL,1),(83,116,'assignment','Lab Report 8: Conservation of Energy',3388,NULL,1),(84,117,'assignment','Lab Report 9: Torque',3389,NULL,1),(85,118,'assignment','Experiential Learning Reflection',3390,NULL,1),(86,119,'assignment','Participation & Lab Skills',3391,NULL,1),(87,119,'assignment','Final Lab Exam',3392,NULL,2),(88,120,'assignment','Quiz 1: What is Psychology?',3393,NULL,1),(89,121,'assignment','Quiz 2: Biology and Psychology',3394,NULL,1),(90,122,'assignment','Quiz 3: Sensation and Perception',3395,NULL,1),(91,123,'assignment','Quiz 4: Consciousness',3396,NULL,1),(92,124,'assignment','Quiz 5: Learning',3397,NULL,1),(93,125,'assignment','Information Literacy Project / Midterm',3398,NULL,1),(94,126,'assignment','Quiz 6: Memory',3399,NULL,1),(95,127,'assignment','Quiz 7: Thinking, Language, and Intelligence',3400,NULL,1),(96,128,'assignment','Quiz 8: Motivation and Emotion',3401,NULL,1),(97,129,'assignment','Evaluation Exam / Applied Paper',3402,NULL,1),(98,130,'assignment','Quiz 9: The Voyage Through the Life Span',3403,NULL,1),(99,131,'assignment','Quiz 10: Personality',3404,NULL,1),(100,132,'assignment','Quiz 11: Psychological Disorders',3405,NULL,1),(101,133,'assignment','Quiz 12: Social Psychology',3406,NULL,1),(102,134,'assignment','Final Exam / Research Paper',3407,NULL,1);
/*!40000 ALTER TABLE `course_module_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_modules`
--

DROP TABLE IF EXISTS `course_modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_modules` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_id` int NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `position` int NOT NULL,
  `is_hidden` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `class_id` (`class_id`),
  CONSTRAINT `course_modules_ibfk_1` FOREIGN KEY (`class_id`) REFERENCES `classes` (`class_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=135 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_modules`
--

LOCK TABLES `course_modules` WRITE;
/*!40000 ALTER TABLE `course_modules` DISABLE KEYS */;
INSERT INTO `course_modules` VALUES (1,1004,'Week 1: Course Introduction & Canvas Orientation',1,0),(2,1004,'Week 2: Intro to Python & Cybersecurity Ethics',2,0),(3,1004,'Week 3: Variables & Expressions',3,0),(4,1004,'Week 4: Selection & Decision Structures',4,0),(5,1004,'Week 5: Review & Semester Exam I',5,0),(6,1004,'Week 6: Loops I – While & For',6,0),(7,1004,'Week 7: Loops II & Intro to Lists',7,0),(8,1004,'Week 8: Lists & Dictionaries',8,0),(9,1004,'Week 9: Number Systems',9,0),(10,1004,'Week 10: Review & Semester Exam II',10,0),(11,1004,'Week 11: Computer Architecture & Digital Logic',11,0),(12,1004,'Week 12: File I/O & Strings',12,0),(13,1004,'Week 13: Functions & Classes',13,0),(14,1004,'Week 14: Exceptions & Robust Programs',14,0),(15,1004,'Week 15: Final Exam & Wrap-Up',15,0),(16,2005,'Week 1: Course Introduction & Canvas / Java Setup',1,0),(17,2005,'Week 2: Creating Java Programs & Using Data (Ch. 1–2)',2,0),(18,2005,'Week 3: Making Decisions (Ch. 5)',3,0),(19,2005,'Week 4: Semester Exam I – Ch. 1, 2 & 5',4,0),(20,2005,'Week 5: Methods, Classes & Objects (Ch. 3)',5,0),(21,2005,'Week 6: More Object Concepts (Ch. 4)',6,0),(22,2005,'Week 7: Object-Oriented Programming Practice',7,0),(23,2005,'Week 8: Semester Exam II – Ch. 3 & 4; Intro to Looping',8,0),(24,2005,'Week 9: Looping (Ch. 6)',9,0),(25,2005,'Week 10: Arrays (Ch. 8)',10,0),(26,2005,'Week 11: Advanced Array Concepts (Ch. 9)',11,0),(27,2005,'Week 12: Semester Exam III – Ch. 6, 8 & 9; Exception Handling (Ch. 12)',12,0),(28,2005,'Week 13: File Input/Output (Ch. 13)',13,0),(29,2005,'Week 14: Swing GUIs (Ch. 14) & Final Project Work',14,0),(30,2005,'Week 15: Final Examination & Course Wrap-Up',15,0),(31,1001,'Week 1: Introduction, Rhetoric & Diagnostic Writing',1,0),(32,1001,'Week 2: Narrative & Descriptive Writing + MLA Basics',2,0),(33,1001,'Week 3: Narrative / Description – Drafting & Revision',3,0),(34,1001,'Week 4: Writing Workshop – Reflection Essay Due',4,0),(35,1001,'Week 5: Comparison / Contrast Readings',5,0),(36,1001,'Week 6: Comparison / Contrast Continued – Draft Due',6,0),(37,1001,'Week 7: Writing Workshop + Mid-Semester Conferences',7,0),(38,1001,'Week 8: Argumentative Readings – Research Intro',8,0),(39,1001,'Week 9: Research Skills & Library Visit',9,0),(40,1001,'Week 10: Research Essay Draft + Citation Review',10,0),(41,1001,'Week 11: Research Continued – Citation Quiz',11,0),(42,1001,'Week 12: Writing Workshop – Research Essay Due',12,0),(43,1001,'Week 13: Critical Analysis Readings',13,0),(44,1001,'Week 14: Critical Analysis Draft & Revision',14,0),(45,1001,'Week 15: Final Conferences & Final Reflection',15,0),(46,2001,'Week 1: Course Introduction & Elements of Fiction',1,0),(47,2001,'Week 2: Chopin & Joyce – Short Fiction & Critical Response',2,0),(48,2001,'Week 3: Chopin – The Awakening & Literary Analysis',3,0),(49,2001,'Week 4: Faulkner – A Rose for Emily & Literary Terms',4,0),(50,2001,'Week 5: Hurston & Baldwin – Short Fiction & Criticism',5,0),(51,2001,'Week 6: Welty & Kincaid – MLA Review & Citation Quiz',6,0),(52,2001,'Week 7: Cather & Oates – Character & Conflict',7,0),(53,2001,'Week 8: Atwood & Carver – Love, Family & Presentations',8,0),(54,2001,'Week 9: Midterm Conferences & Literary Analysis',9,0),(55,2001,'Week 10: Poetry Unit I – Close Reading',10,0),(56,2001,'Week 11: Poetry Unit II – Presentations & Quiz',11,0),(57,2001,'Week 12: Drama / Novel – Extended Literary Text',12,0),(58,2001,'Week 13: Research Paper Introduction & Library Resources',13,0),(59,2001,'Week 14: Research Paper Draft & Peer Review',14,0),(60,2001,'Week 15: Final Conferences, Research Paper & Final Exam',15,0),(61,1003,'Week 1: Precalculus Review & Preview of Calculus',1,0),(62,1003,'Week 2: Limits – Numerical & Graphical',2,0),(63,1003,'Week 3: Limits – Analytic, Continuity & Infinite Limits',3,0),(64,1003,'Week 4: Derivatives & Tangent Lines',4,0),(65,1003,'Week 5: Basic Differentiation Rules',5,0),(66,1003,'Week 6: Chain Rule, Implicit Differentiation & Related Rates',6,0),(67,1003,'Week 7: Extrema, Rolle’s Theorem & Mean Value Theorem',7,0),(68,1003,'Week 8: Increasing/Decreasing & Concavity',8,0),(69,1003,'Week 9: Limits at Infinity & Curve Sketching',9,0),(70,1003,'Week 10: Optimization & Differentials',10,0),(71,1003,'Week 11: Antiderivatives & Indefinite Integrals',11,0),(72,1003,'Week 12: Area, Riemann Sums & Definite Integrals',12,0),(73,1003,'Week 13: Fundamental Theorem of Calculus & Substitution',13,0),(74,1003,'Week 14: Logarithmic & Exponential Functions',14,0),(75,1003,'Week 15: Inverse Functions, Review & Final Exam',15,0),(76,2002,'Week 1: Bases Other Than e, L’Hôpital’s Rule, Inverse Trig',1,0),(77,2002,'Week 2: Inverse Trig Integration, Hyperbolic Functions, Diff Eq',2,0),(78,2002,'Week 3: Growth & Decay, Review & Test 1',3,0),(79,2002,'Week 4: Area Between Curves, Disk Method',4,0),(80,2002,'Week 5: Shell Method, Arc Length, Work',5,0),(81,2002,'Week 6: Centroids & Review for Test 2',6,0),(82,2002,'Week 7: Basic Integration Rules, Integration by Parts',7,0),(83,2002,'Week 8: Trig Integrals & Trig Substitution',8,0),(84,2002,'Week 9: Partial Fractions & Improper Integrals; Test 3',9,0),(85,2002,'Week 10: Sequences & Series',10,0),(86,2002,'Week 11: Integral Test, Comparison Tests, Alternating Series',11,0),(87,2002,'Week 12: Ratio/Root Tests, Taylor Polynomials & Approximations',12,0),(88,2002,'Week 13: Power Series & Representations',13,0),(89,2002,'Week 14: Taylor & Maclaurin Series; Review for Test 4',14,0),(90,2002,'Week 15: Conics, Parametric Equations & Final Review',15,0),(91,2003,'Week 1: Intro, Units, Vectors & Review Math Tools',1,0),(92,2003,'Week 2: Dimensional Analysis, Significant Figures & Test 1 Review',2,0),(93,2003,'Week 3: Kinematics in One Dimension',3,0),(94,2003,'Week 4: Kinematics in Two Dimensions & Projectile Motion',4,0),(95,2003,'Week 5: Newton’s Laws & Forces I',5,0),(96,2003,'Week 6: Newton’s Laws & Forces II – Friction & Inclines',6,0),(97,2003,'Week 7: Circular Motion & Applications of Newton’s Laws',7,0),(98,2003,'Week 8: Work, Kinetic Energy & Work–Energy Theorem',8,0),(99,2003,'Week 9: Potential Energy, Conservation of Energy & Power',9,0),(100,2003,'Week 10: Momentum, Impulse & Collisions',10,0),(101,2003,'Week 11: Rotational Kinematics & Dynamics I',11,0),(102,2003,'Week 12: Rotational Energy, Torque & Angular Momentum',12,0),(103,2003,'Week 13: Static Equilibrium & Elasticity',13,0),(104,2003,'Week 14: Fluids – Pressure, Buoyancy & Bernoulli; Test 5',14,0),(105,2003,'Week 15: Comprehensive Final Exam & Course Wrap-Up',15,0),(106,2004,'Week 1: Lab 1 – Safety, Spreadsheets & Measurement Part 1',1,0),(107,2004,'Week 2: Lab 1 – Measurement Part 2',2,0),(108,2004,'Week 3: Lab 2 – Force Table',3,0),(109,2004,'Week 4: Lab 3 – Acceleration due to Gravity (Part 1)',4,0),(110,2004,'Week 5: Lab 3 – Acceleration due to Gravity (Parts 2 & 3)',5,0),(111,2004,'Week 6: Lab 4 – Projectile Motion (Part 1)',6,0),(112,2004,'Week 7: Lab 4 – Projectile Motion (Part 2)',7,0),(113,2004,'Week 8: Lab 5 – Newton’s Laws',8,0),(114,2004,'Week 9: Lab 6 – Inclined Plane',9,0),(115,2004,'Week 10: Lab 7 – Circular Motion',10,0),(116,2004,'Week 11: Lab 8 – Conservation of Energy',11,0),(117,2004,'Week 12: Lab 9 – Torque',12,0),(118,2004,'Week 13: Problem Session & Make-Up Labs',13,0),(119,2004,'Week 14: Final Lab Exam & Course Reflection',14,0),(120,1002,'Week 1: What is Psychology?',1,0),(121,1002,'Week 2: Biology and Psychology',2,0),(122,1002,'Week 3: Sensation and Perception',3,0),(123,1002,'Week 4: Consciousness',4,0),(124,1002,'Week 5: Learning',5,0),(125,1002,'Week 6: Library Visit & Information Literacy / Midterm',6,0),(126,1002,'Week 7: Memory',7,0),(127,1002,'Week 8: Thinking, Language, and Intelligence',8,0),(128,1002,'Week 9: Motivation and Emotion',9,0),(129,1002,'Week 10: Evaluation Exam and/or Paper',10,0),(130,1002,'Week 11: The Voyage Through the Life Span',11,0),(131,1002,'Week 12: Personality',12,0),(132,1002,'Week 13: Psychological Disorders',13,0),(133,1002,'Week 14: Social Psychology',14,0),(134,1002,'Week 15: Final Exam / Research Paper',15,0);
/*!40000 ALTER TABLE `course_modules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_nav_tabs`
--

DROP TABLE IF EXISTS `course_nav_tabs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_nav_tabs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL,
  `tab_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_visible` tinyint(1) NOT NULL DEFAULT '1',
  `position` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_course_tab` (`course_id`,`tab_name`),
  CONSTRAINT `course_nav_tabs_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_nav_tabs`
--

LOCK TABLES `course_nav_tabs` WRITE;
/*!40000 ALTER TABLE `course_nav_tabs` DISABLE KEYS */;
/*!40000 ALTER TABLE `course_nav_tabs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_pages`
--

DROP TABLE IF EXISTS `course_pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_pages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_id` int NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `body` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `published` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `class_id` (`class_id`),
  CONSTRAINT `course_pages_ibfk_1` FOREIGN KEY (`class_id`) REFERENCES `classes` (`class_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_pages`
--

LOCK TABLES `course_pages` WRITE;
/*!40000 ALTER TABLE `course_pages` DISABLE KEYS */;
/*!40000 ALTER TABLE `course_pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_syllabus`
--

DROP TABLE IF EXISTS `course_syllabus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_syllabus` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_id` int NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `learning_outcomes` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `grading_policy` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `class_id` (`class_id`),
  CONSTRAINT `course_syllabus_ibfk_1` FOREIGN KEY (`class_id`) REFERENCES `classes` (`class_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_syllabus`
--

LOCK TABLES `course_syllabus` WRITE;
/*!40000 ALTER TABLE `course_syllabus` DISABLE KEYS */;
INSERT INTO `course_syllabus` VALUES (1,1004,'An introduction to problem solving, algorithmic thinking, and the fundamentals of programming using Python. Students learn variables, data types, decision structures, loops, basic data structures, file I/O, number systems, and introductory object-oriented programming. The course emphasizes computational reasoning and the foundations needed for advanced computer science coursework.','Write and run Python programs to solve computational problems.\nUnderstand and apply variables, expressions, and selection structures.\nUse loops and iterative problem-solving techniques.\nWork with lists, dictionaries, and other basic data structures.\nPerform file input/output operations in Python.\nExplain the basics of number systems and digital logic.\nDesign programs using functions and simple classes.\nDemonstrate professional coding habits and debugging strategies.','Homework – 20%\nLabs – 20%\nProjects – 20%\nQuizzes – 10%\nExams – 30%'),(2,1003,'A first course in differential and integral calculus with emphasis on limits, continuity, differentiation, curve analysis, and introductory integration techniques. Students learn to model real-world phenomena, analyze change, and apply calculus concepts to physics, engineering, and data-driven disciplines.','Evaluate limits analytically and graphically.\nDetermine continuity and understand behavior near points and asymptotes.\nDifferentiate a wide range of algebraic and transcendental functions.\nApply derivatives to optimization, related rates, curve sketching, and motion.\nUse the Mean Value Theorem and other analytic tools.\nCompute antiderivatives and definite integrals.\nApply the Fundamental Theorem of Calculus.\nModel real-world problems using calculus concepts.','Homework – 20%\nQuizzes – 15%\nUnit Exams – 40%\nFinal Exam – 25%'),(3,1001,'An introductory writing course emphasizing the writing process, rhetorical strategies, academic argumentation, revision, and effective communication. Students practice composing essays through drafting, peer review, and editing while developing critical reading and analytical skills.','Write clear, organized, thesis-driven essays.\nUse the full writing process: brainstorming, drafting, revising, editing.\nAnalyze and respond to readings using critical thinking.\nUse appropriate rhetorical strategies for narrative, comparison, and analysis.\nIntegrate sources using proper MLA format.\nRevise writing for clarity, coherence, grammar, and mechanics.','Essays – 50%\nHomework and Drafts – 20%\nQuizzes – 10%\nFinal Exam – 20%'),(4,2001,'A continuation of college-level writing with emphasis on research, argumentation, critical analysis, and information literacy. Students develop advanced reading, reasoning, and rhetorical skills through documented essays and research-based writing.','Write well-structured argumentative and analytical essays.\nEvaluate and integrate scholarly and credible sources.\nDemonstrate advanced research and information literacy skills.\nApply MLA documentation and citation conventions.\nConstruct persuasive arguments supported by evidence.\nRevise and edit writing for style, clarity, and coherence.','Essays – 55%\nResearch Paper – 25%\nQuizzes – 10%\nFinal Exam – 10%'),(5,1002,'An introduction to the scientific study of behavior and mental processes. Topics include biological bases of behavior, learning, memory, personality, psychological disorders, and research methods.','Explain major psychological theories and perspectives.\nUnderstand the biological foundations of behavior.\nDescribe learning, memory, and cognitive processes.\nInterpret basic psychological research and scientific findings.\nIdentify symptoms and treatments of major psychological disorders.\nApply psychological principles to everyday behavior.','Exams – 45%\nHomework – 20%\nProjects – 20%\nQuizzes – 15%'),(6,2002,'A continuation of Calculus I covering integration techniques, applications of integrals, sequences and series, parametric equations, and introductory differential equations. Emphasis is on analytical methods and problem solving.','Evaluate definite and indefinite integrals using standard techniques.\nApply integration to area, volume, arc length, and physical applications.\nAnalyze sequences and determine convergence of series.\nUse Taylor and Maclaurin series for function approximation.\nGraph and analyze parametric and polar curves.\nSolve basic first-order differential equations.','Homework – 20%\nQuizzes – 15%\nUnit Exams – 40%\nFinal Exam – 25%'),(7,2003,'An introduction to classical mechanics including motion in one and two dimensions, Newton’s laws, energy, momentum, rotational motion, and gravity. The course emphasizes problem-solving and applications in science and engineering.','Analyze motion using kinematic equations.\nApply Newton’s laws to real-world force problems.\nUse energy and momentum methods to solve dynamics problems.\nUnderstand rotational motion and torque.\nApply conservation principles to physical systems.\nInterpret graphs and physical representations of motion.','Homework – 20%\nQuizzes – 10%\nLab (via PHYL 111) – 20%\nExams – 50%'),(8,2004,'A laboratory course designed to accompany PHY 111, providing hands-on experiments in motion, forces, energy, momentum, and rotational dynamics. Students collect, analyze, and interpret experimental data.','Collect accurate experimental measurements.\nAnalyze motion using graphical and numerical techniques.\nApply Newtonian mechanics to real-world experiments.\nInterpret sources of error and uncertainty.\nPrepare clear, organized lab reports aligned with scientific conventions.','Lab Reports – 60%\nPractical Assessments – 20%\nParticipation & Safety – 20%'),(9,2005,'A continuation of programming fundamentals with emphasis on algorithm design, abstraction, and core data structures including arrays, lists, stacks, queues, trees, and recursion. Students write and analyze Java programs and develop problem-solving strategies used in software engineering.','Implement programs using arrays, lists, and abstract data types.\nWrite and trace recursive algorithms.\nUse stacks, queues, and linked structures to model computational processes.\nAnalyze algorithm efficiency using Big-O notation.\nApply searching and sorting algorithms.\nDesign and test multi-class Java applications following OOP principles.','Homework – 20%\nProgramming Labs – 25%\nProjects – 25%\nExams – 30%');
/*!40000 ALTER TABLE `course_syllabus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courses`
--

DROP TABLE IF EXISTS `courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `courses` (
  `course_id` int NOT NULL AUTO_INCREMENT,
  `course_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `course_credits` int NOT NULL,
  `major_id` int DEFAULT NULL,
  PRIMARY KEY (`course_id`),
  KEY `major_id` (`major_id`),
  CONSTRAINT `courses_ibfk_1` FOREIGN KEY (`major_id`) REFERENCES `majors` (`major_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=206 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courses`
--

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
INSERT INTO `courses` VALUES (101,'ENG 101 - English Composition I',3,2),(102,'PSY 101 - General Psychology',3,2),(103,'MAT 171 - Unified Calculus I',4,1),(104,'CST 161 - Computer Programming Fundamentals',4,1),(201,'ENG 102 - English Composition II',3,2),(202,'MAT 172 - Unified Calculus II',4,1),(203,'PHY 111 - Mechanics',3,1),(204,'PHYL 111 - Mechanics Laboratory',1,1),(205,'CST 162 - Computer Algorithms',4,1);
/*!40000 ALTER TABLE `courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `majors`
--

DROP TABLE IF EXISTS `majors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `majors` (
  `major_id` int NOT NULL AUTO_INCREMENT,
  `major_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `department` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`major_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `majors`
--

LOCK TABLES `majors` WRITE;
/*!40000 ALTER TABLE `majors` DISABLE KEYS */;
INSERT INTO `majors` VALUES (1,'A.S. Data Science','STEM'),(2,'General Education','Liberal Arts');
/*!40000 ALTER TABLE `majors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `professors`
--

DROP TABLE IF EXISTS `professors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `professors` (
  `professor_id` int NOT NULL AUTO_INCREMENT,
  `professor_first_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `professor_last_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `department` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`professor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2000015 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `professors`
--

LOCK TABLES `professors` WRITE;
/*!40000 ALTER TABLE `professors` DISABLE KEYS */;
INSERT INTO `professors` VALUES (2000001,'Emilio','Vasquez','STEM'),(2000002,'Karen','Liu','Mathematics'),(2000003,'Lisa','Nguyen','English'),(2000004,'James','Patel','Physics'),(2000005,'Sofia','Martinez','Computer Science'),(2000006,'Linda','Morales','English'),(2000007,'Stephen','Price','Psychology'),(2000008,'James','Patel','Mathematics'),(2000009,'Rebecca','Cho','Mathematics'),(2000010,'Alan','Greene','Computer Science'),(2000011,'Nicole','Alvarez','Computer Science'),(2000012,'Peter','Dunn','Physics'),(2000013,'Hannah','Singh','Physics'),(2000014,'Maria','Sanchez','Computer Science');
/*!40000 ALTER TABLE `professors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedule`
--

DROP TABLE IF EXISTS `schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schedule` (
  `student_id` int NOT NULL,
  `class_id` int NOT NULL,
  PRIMARY KEY (`student_id`,`class_id`),
  KEY `class_id` (`class_id`),
  CONSTRAINT `schedule_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `schedule_ibfk_2` FOREIGN KEY (`class_id`) REFERENCES `classes` (`class_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule`
--

LOCK TABLES `schedule` WRITE;
/*!40000 ALTER TABLE `schedule` DISABLE KEYS */;
INSERT INTO `schedule` VALUES (1000001,1001),(1000002,1001),(1000003,1001),(1000004,1001),(1000005,1001),(1000006,1001),(1000007,1001),(1000008,1001),(1000009,1001),(1000010,1001),(1000011,1001),(1000012,1001),(1000013,1001),(1000014,1001),(1000001,1002),(1000002,1002),(1000003,1002),(1000004,1002),(1000005,1002),(1000006,1002),(1000007,1002),(1000008,1002),(1000009,1002),(1000010,1002),(1000011,1002),(1000012,1002),(1000013,1002),(1000014,1002),(1000001,1003),(1000002,1003),(1000003,1003),(1000004,1003),(1000005,1003),(1000006,1003),(1000007,1003),(1000008,1003),(1000009,1003),(1000010,1003),(1000011,1003),(1000012,1003),(1000013,1003),(1000014,1003),(1000001,1004),(1000002,1004),(1000003,1004),(1000004,1004),(1000005,1004),(1000006,1004),(1000007,1004),(1000008,1004),(1000009,1004),(1000010,1004),(1000011,1004),(1000012,1004),(1000014,1004),(1000001,2001),(1000002,2001),(1000003,2001),(1000004,2001),(1000005,2001),(1000006,2001),(1000007,2001),(1000008,2001),(1000009,2001),(1000010,2001),(1000011,2001),(1000012,2001),(1000001,2002),(1000002,2002),(1000003,2002),(1000004,2002),(1000005,2002),(1000006,2002),(1000007,2002),(1000008,2002),(1000009,2002),(1000010,2002),(1000011,2002),(1000012,2002),(1000015,2002),(1000016,2002),(1000001,2003),(1000002,2003),(1000003,2003),(1000004,2003),(1000005,2003),(1000006,2003),(1000007,2003),(1000008,2003),(1000009,2003),(1000010,2003),(1000011,2003),(1000012,2003),(1000015,2003),(1000016,2003),(1000001,2004),(1000002,2004),(1000003,2004),(1000004,2004),(1000005,2004),(1000006,2004),(1000007,2004),(1000008,2004),(1000009,2004),(1000010,2004),(1000011,2004),(1000012,2004),(1000015,2004),(1000016,2004),(1000001,2005),(1000002,2005),(1000003,2005),(1000004,2005),(1000005,2005),(1000006,2005),(1000007,2005),(1000008,2005),(1000009,2005),(1000010,2005),(1000011,2005),(1000012,2005),(1000016,2005);
/*!40000 ALTER TABLE `schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `students` (
  `student_id` int NOT NULL AUTO_INCREMENT,
  `student_first_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `student_last_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `student_gpa` decimal(3,2) DEFAULT NULL,
  `student_total_credits` int DEFAULT NULL,
  `major_id` int DEFAULT NULL,
  `has_account` tinyint(1) NOT NULL DEFAULT '0',
  `user_id` int DEFAULT NULL,
  PRIMARY KEY (`student_id`),
  KEY `major_id` (`major_id`),
  KEY `fk_students_user` (`user_id`),
  CONSTRAINT `fk_students_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `students_ibfk_1` FOREIGN KEY (`major_id`) REFERENCES `majors` (`major_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1000017 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES (1000001,'Alex','Rivera',3.70,14,1,1,1),(1000002,'Brianna','Lopez',3.40,14,1,1,NULL),(1000003,'Jordan','Patel',3.20,14,1,1,NULL),(1000004,'Maya','Chen',3.80,14,1,1,NULL),(1000005,'Diego','Ramirez',3.10,14,1,1,NULL),(1000006,'Fatima','Khan',3.50,14,1,1,NULL),(1000007,'Lucas','Nguyen',3.25,14,1,1,NULL),(1000008,'Sofia','Martinez',3.60,14,1,1,NULL),(1000009,'Ethan','Park',3.30,14,1,1,NULL),(1000010,'Chloe','Johnson',3.45,14,1,1,NULL),(1000011,'Omar','Hassan',3.15,14,1,1,NULL),(1000012,'Emily','Rogers',3.70,14,1,1,NULL),(1000013,'Liam','Brooks',3.10,12,NULL,1,NULL),(1000014,'Ava','Morales',3.25,12,NULL,1,NULL),(1000015,'Noah','Kim',3.35,12,NULL,1,NULL),(1000016,'Grace','Howard',3.50,12,NULL,1,NULL);
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `study_guide`
--

DROP TABLE IF EXISTS `study_guide`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `study_guide` (
  `study_guide_id` int NOT NULL AUTO_INCREMENT,
  `class_id` int NOT NULL,
  PRIMARY KEY (`study_guide_id`),
  KEY `class_id` (`class_id`),
  CONSTRAINT `study_guide_ibfk_1` FOREIGN KEY (`class_id`) REFERENCES `classes` (`class_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `study_guide`
--

LOCK TABLES `study_guide` WRITE;
/*!40000 ALTER TABLE `study_guide` DISABLE KEYS */;
/*!40000 ALTER TABLE `study_guide` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('student','instructor','admin') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'student',
  `student_id` int DEFAULT NULL,
  `professor_id` int DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `student_id` (`student_id`),
  KEY `professor_id` (`professor_id`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `users_ibfk_2` FOREIGN KEY (`professor_id`) REFERENCES `professors` (`professor_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'alex.rivera@candace.local','scrypt:32768:8:1$gElQ3Ga2wUCGxhRL$31bffa1e8edd85213711561eb8ef5a7558cc0a2d3d229dc12a406aaa9f3104659c64cc945477e87ead00881dfcf3f7bfc8da209efd6e65aa284eb4ad39610d98','student',1000001,NULL,'2025-11-26 11:42:02'),(2,'linda.morales@candace.local','$2b$12$abcdefghijklmnopqrstuv','instructor',NULL,2000006,'2025-11-26 11:45:24'),(3,'stephen.price@candace.local','$2b$12$abcdefghijklmnopqrstuv','instructor',NULL,2000007,'2025-11-26 11:45:24'),(4,'james.patel@candace.local','$2b$12$abcdefghijklmnopqrstuv','instructor',NULL,2000008,'2025-11-26 11:45:24'),(5,'rebecca.cho@candace.local','$2b$12$abcdefghijklmnopqrstuv','instructor',NULL,2000009,'2025-11-26 11:45:24'),(6,'alan.greene@candace.local','$2b$12$abcdefghijklmnopqrstuv','instructor',NULL,2000010,'2025-11-26 11:45:24'),(7,'nicole.alvarez@candace.local','$2b$12$abcdefghijklmnopqrstuv','instructor',NULL,2000011,'2025-11-26 11:45:24'),(8,'peter.dunn@candace.local','$2b$12$abcdefghijklmnopqrstuv','instructor',NULL,2000012,'2025-11-26 11:45:24'),(9,'hannah.singh@candace.local','$2b$12$abcdefghijklmnopqrstuv','instructor',NULL,2000013,'2025-11-26 11:45:24'),(10,'maria.sanchez@candace.local','$2b$12$abcdefghijklmnopqrstuv','instructor',NULL,2000014,'2025-11-26 11:45:24'),(11,'brianna.lopez@candace.local','scrypt:32768:8:1$gElQ3Ga2wUCGxhRL$31bffa1e8edd85213711561eb8ef5a7558cc0a2d3d229dc12a406aaa9f3104659c64cc945477e87ead00881dfcf3f7bfc8da209efd6e65aa284eb4ad39610d98','student',1000002,NULL,'2025-11-26 11:45:34'),(12,'jordan.patel@candace.local','scrypt:32768:8:1$gElQ3Ga2wUCGxhRL$31bffa1e8edd85213711561eb8ef5a7558cc0a2d3d229dc12a406aaa9f3104659c64cc945477e87ead00881dfcf3f7bfc8da209efd6e65aa284eb4ad39610d98','student',1000003,NULL,'2025-11-26 11:45:34'),(13,'maya.chen@candace.local','scrypt:32768:8:1$gElQ3Ga2wUCGxhRL$31bffa1e8edd85213711561eb8ef5a7558cc0a2d3d229dc12a406aaa9f3104659c64cc945477e87ead00881dfcf3f7bfc8da209efd6e65aa284eb4ad39610d98','student',1000004,NULL,'2025-11-26 11:45:34'),(14,'diego.ramirez@candace.local','scrypt:32768:8:1$gElQ3Ga2wUCGxhRL$31bffa1e8edd85213711561eb8ef5a7558cc0a2d3d229dc12a406aaa9f3104659c64cc945477e87ead00881dfcf3f7bfc8da209efd6e65aa284eb4ad39610d98','student',1000005,NULL,'2025-11-26 11:45:34'),(15,'fatima.khan@candace.local','scrypt:32768:8:1$gElQ3Ga2wUCGxhRL$31bffa1e8edd85213711561eb8ef5a7558cc0a2d3d229dc12a406aaa9f3104659c64cc945477e87ead00881dfcf3f7bfc8da209efd6e65aa284eb4ad39610d98','student',1000006,NULL,'2025-11-26 11:45:34'),(16,'lucas.nguyen@candace.local','scrypt:32768:8:1$gElQ3Ga2wUCGxhRL$31bffa1e8edd85213711561eb8ef5a7558cc0a2d3d229dc12a406aaa9f3104659c64cc945477e87ead00881dfcf3f7bfc8da209efd6e65aa284eb4ad39610d98','student',1000007,NULL,'2025-11-26 11:45:34'),(17,'sofia.martinez@candace.local','scrypt:32768:8:1$gElQ3Ga2wUCGxhRL$31bffa1e8edd85213711561eb8ef5a7558cc0a2d3d229dc12a406aaa9f3104659c64cc945477e87ead00881dfcf3f7bfc8da209efd6e65aa284eb4ad39610d98','student',1000008,NULL,'2025-11-26 11:45:34'),(18,'ethan.park@candace.local','scrypt:32768:8:1$gElQ3Ga2wUCGxhRL$31bffa1e8edd85213711561eb8ef5a7558cc0a2d3d229dc12a406aaa9f3104659c64cc945477e87ead00881dfcf3f7bfc8da209efd6e65aa284eb4ad39610d98','student',1000009,NULL,'2025-11-26 11:45:34'),(19,'chloe.johnson@candace.local','scrypt:32768:8:1$gElQ3Ga2wUCGxhRL$31bffa1e8edd85213711561eb8ef5a7558cc0a2d3d229dc12a406aaa9f3104659c64cc945477e87ead00881dfcf3f7bfc8da209efd6e65aa284eb4ad39610d98','student',1000010,NULL,'2025-11-26 11:45:34'),(20,'omar.hassan@candace.local','scrypt:32768:8:1$gElQ3Ga2wUCGxhRL$31bffa1e8edd85213711561eb8ef5a7558cc0a2d3d229dc12a406aaa9f3104659c64cc945477e87ead00881dfcf3f7bfc8da209efd6e65aa284eb4ad39610d98','student',1000011,NULL,'2025-11-26 11:45:34'),(21,'emily.rogers@candace.local','scrypt:32768:8:1$gElQ3Ga2wUCGxhRL$31bffa1e8edd85213711561eb8ef5a7558cc0a2d3d229dc12a406aaa9f3104659c64cc945477e87ead00881dfcf3f7bfc8da209efd6e65aa284eb4ad39610d98','student',1000012,NULL,'2025-11-26 11:45:34'),(22,'liam.brooks@candace.local','scrypt:32768:8:1$gElQ3Ga2wUCGxhRL$31bffa1e8edd85213711561eb8ef5a7558cc0a2d3d229dc12a406aaa9f3104659c64cc945477e87ead00881dfcf3f7bfc8da209efd6e65aa284eb4ad39610d98','student',1000013,NULL,'2025-11-26 11:45:34'),(23,'ava.morales@candace.local','scrypt:32768:8:1$gElQ3Ga2wUCGxhRL$31bffa1e8edd85213711561eb8ef5a7558cc0a2d3d229dc12a406aaa9f3104659c64cc945477e87ead00881dfcf3f7bfc8da209efd6e65aa284eb4ad39610d98','student',1000014,NULL,'2025-11-26 11:45:34'),(24,'noah.kim@candace.local','scrypt:32768:8:1$gElQ3Ga2wUCGxhRL$31bffa1e8edd85213711561eb8ef5a7558cc0a2d3d229dc12a406aaa9f3104659c64cc945477e87ead00881dfcf3f7bfc8da209efd6e65aa284eb4ad39610d98','student',1000015,NULL,'2025-11-26 11:45:34'),(25,'grace.howard@candace.local','scrypt:32768:8:1$gElQ3Ga2wUCGxhRL$31bffa1e8edd85213711561eb8ef5a7558cc0a2d3d229dc12a406aaa9f3104659c64cc945477e87ead00881dfcf3f7bfc8da209efd6e65aa284eb4ad39610d98','student',1000016,NULL,'2025-11-26 11:45:34'),(26,'second.admin@candace.local','scrypt:32768:8:1$gElQ3Ga2wUCGxhRL$31bffa1e8edd85213711561eb8ef5a7558cc0a2d3d229dc12a406aaa9f3104659c64cc945477e87ead00881dfcf3f7bfc8da209efd6e65aa284eb4ad39610d98','admin',NULL,NULL,'2025-11-26 12:49:25');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `work_load`
--

DROP TABLE IF EXISTS `work_load`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_load` (
  `student_id` int NOT NULL,
  `assignment_id` int NOT NULL,
  PRIMARY KEY (`student_id`,`assignment_id`),
  KEY `assignment_id` (`assignment_id`),
  CONSTRAINT `work_load_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `work_load_ibfk_2` FOREIGN KEY (`assignment_id`) REFERENCES `assignments` (`assignment_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `work_load`
--

LOCK TABLES `work_load` WRITE;
/*!40000 ALTER TABLE `work_load` DISABLE KEYS */;
INSERT INTO `work_load` VALUES (1000001,3001),(1000001,3002),(1000001,3003),(1000001,3101),(1000001,3102),(1000001,3103),(1000001,3201),(1000001,3202),(1000001,3301),(1000001,3302),(1000001,3303);
/*!40000 ALTER TABLE `work_load` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-29 16:21:18
