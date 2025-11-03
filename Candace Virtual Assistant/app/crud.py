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

def insert_login_info(login_id, login_password):
    db = get_db()
    try:
        with db:
            cursor = db.cursor()
            cursor.execute("INSERT INTO LOGIN_INFO (login_id, login_password) VALUES (?,?) ",(login_id, login_password,) )
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
