-- ========================================
-- Candace Assistant - Final Schema
-- ========================================

CREATE DATABASE IF NOT EXISTS candace_assistant
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE candace_assistant;

-- ----------------------------------------
-- Drop tables in FK-safe order
-- ----------------------------------------
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS assignment_grades;
DROP TABLE IF EXISTS course_module_items;
DROP TABLE IF EXISTS course_modules;
DROP TABLE IF EXISTS course_nav_tabs;
DROP TABLE IF EXISTS course_cengage_links;
DROP TABLE IF EXISTS course_files;
DROP TABLE IF EXISTS course_pages;
DROP TABLE IF EXISTS course_announcements;
DROP TABLE IF EXISTS course_syllabus;

DROP TABLE IF EXISTS ai_chat_log;
DROP TABLE IF EXISTS study_guide;
DROP TABLE IF EXISTS schedule;
DROP TABLE IF EXISTS work_load;

DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS professors;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS majors;

SET FOREIGN_KEY_CHECKS = 1;

-- ----------------------------------------
-- MAJORS
-- ----------------------------------------
CREATE TABLE majors (
    major_id     INT PRIMARY KEY AUTO_INCREMENT,
    major_name   VARCHAR(100) NOT NULL,
    department   VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

-- ----------------------------------------
-- STUDENTS
-- ----------------------------------------
CREATE TABLE students (
    student_id           INT PRIMARY KEY AUTO_INCREMENT,
    student_first_name   VARCHAR(100) NOT NULL,
    student_last_name    VARCHAR(100) NOT NULL,
    student_gpa          DECIMAL(3,2),
    student_total_credits INT,
    major_id             INT,
    has_account          TINYINT(1) NOT NULL DEFAULT 0,
    -- linked to users later via ALTER (user_id FK)
    user_id              INT NULL,
    FOREIGN KEY (major_id) REFERENCES majors(major_id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

-- ----------------------------------------
-- PROFESSORS
-- ----------------------------------------
CREATE TABLE professors (
    professor_id        INT PRIMARY KEY AUTO_INCREMENT,
    professor_first_name VARCHAR(100) NOT NULL,
    professor_last_name  VARCHAR(100) NOT NULL,
    department          VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

-- ----------------------------------------
-- COURSES
-- ----------------------------------------
CREATE TABLE courses (
    course_id      INT PRIMARY KEY AUTO_INCREMENT,
    course_name    VARCHAR(200) NOT NULL,
    course_credits INT NOT NULL,
    major_id       INT,
    FOREIGN KEY (major_id) REFERENCES majors(major_id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

-- ----------------------------------------
-- CLASSES (course offerings / sections)
-- ----------------------------------------
CREATE TABLE classes (
    class_id     INT PRIMARY KEY AUTO_INCREMENT,
    course_id    INT NOT NULL,
    professor_id INT NOT NULL,
    class_type   VARCHAR(50) NOT NULL,
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- ----------------------------------------
-- ASSIGNMENTS
-- ----------------------------------------
CREATE TABLE assignments (
    assignment_id           INT PRIMARY KEY AUTO_INCREMENT,
    class_id                INT NOT NULL,
    assignment_name         VARCHAR(200) NOT NULL,
    assignment_type         VARCHAR(50) NOT NULL,
    assignment_score_weight DECIMAL(4,2),
    due_at                  DATETIME NULL,
    max_points              INT NOT NULL DEFAULT 100,
    description             TEXT NULL,
    points                  INT NULL,
    is_published            TINYINT(1) NOT NULL DEFAULT 0,
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- ----------------------------------------
-- WORK LOAD (kept for compatibility, not required by views)
-- ----------------------------------------
CREATE TABLE work_load (
    student_id    INT NOT NULL,
    assignment_id INT NOT NULL,
    PRIMARY KEY (student_id, assignment_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (assignment_id) REFERENCES assignments(assignment_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- ----------------------------------------
-- SCHEDULE (enrollment)
-- ----------------------------------------
CREATE TABLE schedule (
    student_id INT NOT NULL,
    class_id   INT NOT NULL,
    PRIMARY KEY (student_id, class_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- ----------------------------------------
-- STUDY GUIDE
-- ----------------------------------------
CREATE TABLE study_guide (
    study_guide_id INT PRIMARY KEY AUTO_INCREMENT,
    class_id       INT NOT NULL,
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- ----------------------------------------
-- AI CHAT LOG
-- ----------------------------------------
CREATE TABLE ai_chat_log (
    chat_log_id    INT PRIMARY KEY AUTO_INCREMENT,
    student_id     INT,
    chat_timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    user_message   TEXT NOT NULL,
    ai_response    TEXT NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

-- ----------------------------------------
-- USERS (auth + role)
-- ----------------------------------------
CREATE TABLE users (
    id           INT PRIMARY KEY AUTO_INCREMENT,
    email        VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role         ENUM('student','instructor','admin') NOT NULL DEFAULT 'student',
    student_id   INT NULL,
    professor_id INT NULL,
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

-- ----------------------------------------
-- COURSE ANNOUNCEMENTS
-- ----------------------------------------
CREATE TABLE course_announcements (
    id                  INT PRIMARY KEY AUTO_INCREMENT,
    class_id            INT NOT NULL,
    title               VARCHAR(255) NOT NULL,
    body                TEXT NOT NULL,
    posted_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    author_professor_id INT NULL,
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (author_professor_id) REFERENCES professors(professor_id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

-- ----------------------------------------
-- COURSE MODULES (Canvas-style weekly units)
-- ----------------------------------------
CREATE TABLE course_modules (
    id        INT PRIMARY KEY AUTO_INCREMENT,
    class_id  INT NOT NULL,
    title     VARCHAR(255) NOT NULL,
    position  INT NOT NULL,
    is_hidden TINYINT(1) NOT NULL DEFAULT 0,
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- ----------------------------------------
-- COURSE MODULE ITEMS
-- ----------------------------------------
CREATE TABLE course_module_items (
    id            INT PRIMARY KEY AUTO_INCREMENT,
    module_id     INT NOT NULL,
    item_type     ENUM('page','assignment','quiz','file','external') NOT NULL,
    title         VARCHAR(255) NOT NULL,
    assignment_id INT NULL,
    external_url  VARCHAR(500) NULL,
    position      INT NOT NULL,
    FOREIGN KEY (module_id) REFERENCES course_modules(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (assignment_id) REFERENCES assignments(assignment_id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

-- ----------------------------------------
-- COURSE FILES
-- ----------------------------------------
CREATE TABLE course_files (
    id           INT PRIMARY KEY AUTO_INCREMENT,
    class_id     INT NOT NULL,
    folder       VARCHAR(255) NOT NULL,
    file_name    VARCHAR(255) NOT NULL,
    file_size_kb INT NULL,
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- ----------------------------------------
-- COURSE PAGES
-- ----------------------------------------
CREATE TABLE course_pages (
    id        INT PRIMARY KEY AUTO_INCREMENT,
    class_id  INT NOT NULL,
    title     VARCHAR(255) NOT NULL,
    body      MEDIUMTEXT NOT NULL,
    published TINYINT(1) NOT NULL DEFAULT 1,
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- ----------------------------------------
-- COURSE CENGAGE LINKS
-- ----------------------------------------
CREATE TABLE course_cengage_links (
    id      INT PRIMARY KEY AUTO_INCREMENT,
    class_id INT NOT NULL,
    name    VARCHAR(255) NOT NULL,
    status  VARCHAR(255),
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- ----------------------------------------
-- ASSIGNMENT GRADES
-- ----------------------------------------
CREATE TABLE assignment_grades (
    student_id    INT NOT NULL,
    assignment_id INT NOT NULL,
    score         DECIMAL(6,2),
    submitted_at  DATETIME NULL,
    status        ENUM('not_assigned','not_submitted','submitted','graded','late')
        NOT NULL DEFAULT 'not_assigned',
    PRIMARY KEY (student_id, assignment_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (assignment_id) REFERENCES assignments(assignment_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- ----------------------------------------
-- COURSE SYLLABUS
-- ----------------------------------------
CREATE TABLE course_syllabus (
    id               INT PRIMARY KEY AUTO_INCREMENT,
    class_id         INT NOT NULL UNIQUE,
    description      TEXT NOT NULL,
    learning_outcomes TEXT NOT NULL, -- newline-separated bullets
    grading_policy   TEXT NOT NULL,  -- newline-separated bullets
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- ----------------------------------------
-- COURSE NAV TABS (optional, for dynamic nav)
-- ----------------------------------------
CREATE TABLE course_nav_tabs (
    id        INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT NOT NULL,
    tab_name  VARCHAR(50) NOT NULL,      -- 'people','assignments','modules','grades', etc.
    is_visible TINYINT(1) NOT NULL DEFAULT 1,
    position   INT NOT NULL DEFAULT 0,
    UNIQUE KEY uniq_course_tab (course_id, tab_name),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- ----------------------------------------
-- Link students.user_id -> users.id
-- (circular relation handled via ALTER)
-- ----------------------------------------
ALTER TABLE students
    ADD CONSTRAINT fk_students_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE SET NULL ON UPDATE CASCADE;
