PRAGMA foreign_keys=ON;
DROP TABLE IF EXISTS MAJOR;
CREATE TABLE MAJOR (
    major_id INT PRIMARY KEY,
    major_name TEXT NOT NULL,
    department TEXT NOT NULL
);
DROP TABLE IF EXISTS STUDENT;
CREATE TABLE STUDENT (
    student_id INT PRIMARY KEY,
    student_first_name TEXT NOT NULL,
    student_last_name TEXT NOT NULL,
    student_gpa REAL check (student_gpa BETWEEN 0.0 AND 4.0),
    student_total_credits INT check (student_total_credits >= 0),
    major_id INT,
    FOREIGN KEY (major_id) REFERENCES MAJOR(major_id)
);
DROP TABLE IF EXISTS PROFESSOR;
CREATE TABLE PROFESSOR (
    professor_id INT PRIMARY KEY,
    professor_first_name TEXT NOT NULL,
    professor_last_name TEXT NOT NULL,
    department TEXT NOT NULL
);
DROP TABLE IF EXISTS COURSE;
CREATE TABLE COURSE (
    course_id INT PRIMARY KEY,
    course_name TEXT NOT NULL,
    course_credits INT NOT NULL check (course_credits > 0),
    major_id INT,
    FOREIGN KEY (major_id) REFERENCES MAJOR(major_id)
);
DROP TABLE IF EXISTS CLASS;
CREATE TABLE CLASS (
    class_id INT PRIMARY KEY,
    course_id INT NOT NULL,
    professor_id INT NOT NULL,
    class_type TEXT NOT NULL,
    FOREIGN KEY (course_id) REFERENCES COURSE(course_id),
    FOREIGN KEY (professor_id) REFERENCES PROFESSOR(professor_id)
);
DROP TABLE IF EXISTS ASSIGNMENT;
CREATE TABLE ASSIGNMENT (
    assignment_id INT PRIMARY KEY,
    class_id INT NOT NULL,
    assignment_name TEXT NOT NULL,
    assignment_type TEXT NOT NULL,
    assignment_score_weight REAL NOT NULL,
    FOREIGN KEY (class_id) REFERENCES CLASS(class_id)
);
DROP TABLE IF EXISTS WORK_LOAD;
CREATE TABLE WORK_LOAD (
    student_id INT NOT NULL,
    assignment_id INT NOT NULL,
    PRIMARY KEY (student_id, assignment_id),
    FOREIGN KEY (student_id) REFERENCES STUDENT(student_id),
    FOREIGN KEY (assignment_id) REFERENCES ASSIGNMENT(assignment_id)
);
DROP TABLE IF EXISTS SCHEDULE;
CREATE TABLE SCHEDULE (
    student_id INT NOT NULL,
    class_id INT NOT NULL,
    PRIMARY KEY (student_id, class_id),
    FOREIGN KEY (student_id) REFERENCES STUDENT(student_id),
    FOREIGN KEY (class_id) REFERENCES CLASS(class_id)
);
DROP TABLE IF EXISTS STUDY_GUIDE;
CREATE TABLE STUDY_GUIDE (
    study_guide_id INT PRIMARY KEY,
    class_id INT NOT NULL,
    FOREIGN KEY (class_id) REFERENCES CLASS(class_id)
);
DROP TABLE IF EXISTS AI_CHAT_LOG;
CREATE TABLE AI_CHAT_LOG (
    chat_log_id INT PRIMARY KEY,
    student_id INT NOT NULL,
    chat_timestamp TEXT NOT NULL,
    user_message TEXT NOT NULL,
    ai_response TEXT NOT NULL,
    FOREIGN KEY (student_id) REFERENCES STUDENT(student_id)
);