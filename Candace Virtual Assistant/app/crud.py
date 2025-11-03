import sqlite3
from db_utils import get_db

def get_student_by_id(student_id):
    db = get_db()
    try:
        cursor = db.cursor()
        cursor.execute("SELECT * FROM STUDENT WHERE student_id = ?", (student_id,))
        records = cursor.fetchall()
        return records
    except sqlite3.Error as e:
        print(f"Error retrieving student by ID {student_id}: {e}")
        return False

def insert_student_info(student_id, student_first_name, student_last_name, student_gpa, student_total_credits, major_id):
    db = get_db()
    try:
        with db:
            cursor = db.cursor()
            cursor.execute(
                "Insert INTO STUDENT(student_id, student_first_name, student_last_name, student_gpa, student_total_credits, major_id) VALUES (?, ?, ?, ?, ?, ?)", (student_id, student_first_name, student_last_name, student_gpa, student_total_credits, major_id)
            )
    except sqlite3.Error as e:
        print(f"Error inserting student info for Student ID {student_id}: {e}")
        return False

def insert_chat_logs(student_id, ai_response):
    db = get_db()
    try:
        with db:
            cursor = db.cursor()
            cursor.execute(
                "INSERT INTO CHAT_LOGS (student_id, ai_response) VALUES (?, ?)", (student_id, ai_response)
            )
    except sqlite3.Error as e:
        print(f"Error inserting chat log for student ID {student_id}: {e}")
        return False
def read_chat_logs(student_id):
    db = get_db()
    try:
        with db:
            cursor = db.cursor()
            cursor.execute(
                "SELECT * FROM CHAT_LOGS WHERE student_id = ?", (student_id,)
            )
            records = cursor.fetchall()
            return records
    except sqlite3.Error as e:
        print(f"Error reading chat logs for student ID {student_id}: {e}")
        return False

def insert_login_info(login_id, login_password, student_id):
    db = get_db()
    try:
        with db:
            cursor = db.cursor()
            cursor.execute("INSERT INTO LOGIN_INFO (login_id, student_id, login_password) VALUES (?, ?, ?)", (login_id, student_id, login_password))
    except sqlite3.Error as e:
       print(f"Error inserting login info for Login ID {login_id}: {e}")
       return False

def get_login_info_by_id(login_id):
    db = get_db()
    try:
        cursor = db.cursor()
        cursor.execute("SELECT * FROM LOGIN_INFO WHERE login_id = ?", (login_id,))
        records = cursor.fetchall()
        return records
    except sqlite3.Error as e:
        print(f"Error retrieving login info by ID {login_id}: {e}")
        return False

def read_Majors(major_id):
    db = get_db()
    try:
        with db:
            cursor = db.cursor()
            cursor.execute(
                "SELECT * FROM MAJOR WHERE major_id = ?", (major_id,)
            )
            records = cursor.fetchall()
            return records
    except sqlite3.Error as e:
        print(f"Error reading majors: {e}")
        return False
def insert_majors(major_id, major_name, department):
    db = get_db()
    try:
        with db:
            cursor = db.cursor()
            cursor.execute(
                "INSERT INTO MAJOR (major_id, major_name, department) VALUES (?, ?, ?)", (major_id, major_name, department)
            )
    except sqlite3.Error as e:
        print(f"Error inserting majors: {e}")
        return False
def read_professors(professor_id):
    db = get_db()
    try:
        with db:
            cursor = db.cursor()
            cursor.execute(
                "SELECT * FROM PROFESSOR WHERE professor_id = ?", (professor_id,)
            )
            records = cursor.fetchall()
            return records
    except sqlite3.Error as e:
        print(f"Error reading professors: {e}")
        return False
def insert_professors(professor_id, professor_first_name, professor_last_name, department):
    db = get_db()
    try:
        with db:
            cursor = db.cursor()
            cursor.execute(
                "INSERT INTO PROFESSOR (professor_id, professor_first_name, professor_last_name, department) VALUES (?, ?, ?, ?)", (professor_id, professor_first_name, professor_last_name, department)
            )
    except sqlite3.Error as e:
        print(f"Error inserting professors: {e}")
        return False
def read_courses(course_id):
    db = get_db()
    try:
        with db:
            cursor = db.cursor()
            cursor.execute(
                "SELECT * FROM COURSE WHERE course_id = ?", (course_id,)
            )
            records = cursor.fetchall()
            return records
    except sqlite3.Error as e:
        print(f"Error reading courses: {e}")
        return False

def insert_courses(course_id, course_name, course_credits, major_id):
    db = get_db()
    try:
        with db:
            cursor = db.cursor()
            cursor.execute(
                "INSERT INTO COURSE (course_id, course_name, course_credits, major_id) VALUES (?, ?, ?, ?)", (course_id, course_name, course_credits, major_id)
            )
    except sqlite3.Error as e:
        print(f"Error inserting courses: {e}")
        return False
def read_class(class_id):
    db = get_db()
    try:
        with db:
            cursor = db.cursor()
            cursor.execute(
                "SELECT * FROM CLASS WHERE class_id = ?", (class_id,)
            )
            records = cursor.fetchall()
            return records
    except sqlite3.Error as e:
        print(f"Error reading class: {e}")
        return False
def insert_class(class_id, course_id, professor_id, class_type):
    db = get_db()
    try:
        with db:
            cursor = db.cursor()
            cursor.execute(
                "INSERT INTO CLASS (class_id, course_id, professor_id, class_type) VALUES (?, ?, ?, ?)", (class_id, course_id, professor_id, class_type)
            )
    except sqlite3.Error as e:
        print(f"Error inserting class: {e}")
        return False
def read_assignments(assignment_id):
    db = get_db()
    try:
        with db:
            cursor = db.cursor()
            cursor.execute(
                "SELECT * FROM ASSIGNMENT WHERE assignment_id = ?", (assignment_id,)
            )
            records = cursor.fetchall()
            return records
    except sqlite3.Error as e:
        print(f"Error reading assignments: {e}")
        return False
def insert_assignments(assignment_id, class_id, assignment_name, assignment_type, assignment_score_weight):
    db = get_db()
    try:
        with db:
            cursor = db.cursor()
            cursor.execute(
                "INSERT INTO ASSIGNMENT (assignment_id, class_id, assignment_name, assignment_type, assignment_score_weight) VALUES (?, ?, ?, ?, ?)", (assignment_id, class_id, assignment_name, assignment_type, assignment_score_weight)
            )
    except sqlite3.Error as e:
        print(f"Error inserting assignments: {e}")
        return False
def read_work_load(student_id):
    db = get_db()
    try:
        with db:
            cursor = db.cursor()
            cursor.execute(
                "SELECT * FROM WORK_LOAD WHERE student_id = ?", (student_id,)
            )
            records = cursor.fetchall()
            return records
    except sqlite3.Error as e:
        print(f"Error reading work load: {e}")
        return False
def insert_work_load(student_id, assignment_id):
    db = get_db()
    try:
        with db:
            cursor = db.cursor()
            cursor.execute(
                "INSERT INTO WORK_LOAD (student_id, assignment_id) VALUES (?, ?)", (student_id, assignment_id)
            )
    except sqlite3.Error as e:
        print(f"Error inserting work load: {e}")
        return False
def read_schedule(student_id):          
    db = get_db()
    try:
        with db:
            cursor = db.cursor()
            cursor.execute(
                "SELECT * FROM SCHEDULE WHERE student_id = ?", (student_id,)
            )
            records = cursor.fetchall()
            return records
    except sqlite3.Error as e:
        print(f"Error reading schedules: {e}")
        return False
    
def insert_schedule(student_id, class_id):
    db = get_db()
    try:
        with db:
            cursor = db.cursor()
            cursor.execute(
                "INSERT INTO SCHEDULE (student_id, class_id) VALUES (?, ?)", (student_id, class_id)
            )
    except sqlite3.Error as e:
        print(f"Error inserting schedules: {e}")
        return False
def read_study_guide(study_guide_id=None, class_id=None):
    db = get_db()
    try:
        with db:
            cursor = db.cursor()
            if study_guide_id:
                cursor.execute(
                    "SELECT * FROM STUDY_GUIDE WHERE study_guide_id = ?", (study_guide_id,)
                )
            elif class_id:
                cursor.execute(
                    "SELECT * FROM STUDY_GUIDE WHERE class_id = ?", (class_id,)
                )
            records = cursor.fetchall()
            return records
    except sqlite3.Error as e:
        print(f"Error reading study guides: {e}")
        return False
def insert_study_guide(study_guide_id, class_id):
    db = get_db()
    try:
        with db:
            cursor = db.cursor()
            cursor.execute(
                "INSERT INTO STUDY_GUIDE (study_guide_id, class_id) VALUES (?, ?)", (study_guide_id, class_id)
            )
    except sqlite3.Error as e:
        print(f"Error inserting study guides: {e}")
        return False

