CREATE DATABASE IF NOT EXISTS candace_assistant
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE candace_assistant;

-- ----------------------------------------
-- MAJOR
-- ----------------------------------------
DROP TABLE IF EXISTS majors;
CREATE TABLE majors (
    major_id INT PRIMARY KEY AUTO_INCREMENT,
    major_name VARCHAR(100) NOT NULL,
    department VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

-- ----------------------------------------
-- STUDENT
-- ----------------------------------------
DROP TABLE IF EXISTS students;
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_first_name VARCHAR(100) NOT NULL,
    student_last_name VARCHAR(100) NOT NULL,
    student_gpa DECIMAL(3,2),
    student_total_credits INT,
    major_id INT,
    has_account TINYINT(1) NOT NULL DEFAULT 0,
    FOREIGN KEY (major_id) REFERENCES majors(major_id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

-- ----------------------------------------
-- PROFESSOR
-- ----------------------------------------
DROP TABLE IF EXISTS professors;
CREATE TABLE professors (
    professor_id INT PRIMARY KEY AUTO_INCREMENT,
    professor_first_name VARCHAR(100) NOT NULL,
    professor_last_name VARCHAR(100) NOT NULL,
    department VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

-- ----------------------------------------
-- COURSE
-- ----------------------------------------
DROP TABLE IF EXISTS courses;
CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(200) NOT NULL,
    course_credits INT NOT NULL,
    major_id INT,
    FOREIGN KEY (major_id) REFERENCES majors(major_id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

-- ----------------------------------------
-- CLASS
-- ----------------------------------------
DROP TABLE IF EXISTS classes;
CREATE TABLE classes (
    class_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT NOT NULL,
    professor_id INT NOT NULL,
    class_type VARCHAR(50) NOT NULL,
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- ----------------------------------------
-- ASSIGNMENT
-- ----------------------------------------
DROP TABLE IF EXISTS assignments;
CREATE TABLE assignments (
    assignment_id INT PRIMARY KEY AUTO_INCREMENT,
    class_id INT NOT NULL,
    assignment_name VARCHAR(200) NOT NULL,
    assignment_type VARCHAR(50) NOT NULL,
    assignment_score_weight DECIMAL(4,2),
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- ----------------------------------------
-- WORK LOAD
-- ----------------------------------------
DROP TABLE IF EXISTS work_load;
CREATE TABLE work_load (
    student_id INT NOT NULL,
    assignment_id INT NOT NULL,
    PRIMARY KEY (student_id, assignment_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (assignment_id) REFERENCES assignments(assignment_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- ----------------------------------------
-- SCHEDULE
-- ----------------------------------------
DROP TABLE IF EXISTS schedule;
CREATE TABLE schedule (
    student_id INT NOT NULL,
    class_id INT NOT NULL,
    PRIMARY KEY (student_id, class_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- ----------------------------------------
-- STUDY GUIDE
-- ----------------------------------------
DROP TABLE IF EXISTS study_guide;
CREATE TABLE study_guide (
    study_guide_id INT PRIMARY KEY AUTO_INCREMENT,
    class_id INT NOT NULL,
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- ----------------------------------------
-- AI CHAT LOG
-- ----------------------------------------
DROP TABLE IF EXISTS ai_chat_log;
CREATE TABLE ai_chat_log (
    chat_log_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    chat_timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    user_message TEXT NOT NULL,
    ai_response TEXT NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

-- ----------------------------------------
-- USERS  (REPLACES LOGIN_INFO)
-- ----------------------------------------
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('student','instructor','admin') NOT NULL DEFAULT 'student',
    student_id INT NULL,
    professor_id INT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;
