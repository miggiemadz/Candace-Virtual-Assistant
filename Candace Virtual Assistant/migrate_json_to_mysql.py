"""
migrate_json_to_mysql.py

One-time script to migrate the sample JSON dataset into MySQL.

- Reads DB settings from .env
- Loads JSON (MAJOR, STUDENT, etc.)
- Inserts into: majors, students, professors, courses, classes,
  assignments, work_load, schedule, study_guide, ai_chat_log
- Creates a default admin user: admin@candace.local / changeme
"""

import json
import os
from pathlib import Path
from datetime import datetime

import mysql.connector
from dotenv import load_dotenv
from werkzeug.security import generate_password_hash


BASE_DIR = Path(__file__).resolve().parent
DEFAULT_JSON_PATH = BASE_DIR / "docs" / "student_database_final.json"


def get_connection():
    load_dotenv(BASE_DIR / ".env")

    conn = mysql.connector.connect(
        host=os.getenv("DB_HOST", "localhost"),
        port=int(os.getenv("DB_PORT", "3306")),
        user=os.getenv("DB_USER", "candace_user"),
        password=os.getenv("DB_PASSWORD", ""),
        database=os.getenv("DB_NAME", "candace_assistant"),
        autocommit=False,
    )
    return conn


def safe_name_split(full_name: str):
    """
    Best-effort split of 'Dr. Karen Liu' -> ('Dr. Karen', 'Liu').
    If it can't split, puts everything in first_name and uses empty last_name.
    """
    parts = full_name.strip().split()
    if len(parts) >= 2:
        first = " ".join(parts[:-1])
        last = parts[-1]
    else:
        first = full_name.strip()
        last = ""
    return first, last


def insert_majors(conn, data):
    majors = data.get("MAJOR", [])
    if not majors:
        print("No MAJOR data found.")
        return

    sql = """
        INSERT INTO majors (major_id, major_name, department)
        VALUES (%s, %s, %s)
    """
    cur = conn.cursor()
    for row in majors:
        cur.execute(
            sql,
            (
                row["major_id"],
                row["major_name"],
                row["department"],
            ),
        )
    cur.close()
    conn.commit()
    print(f"Inserted {len(majors)} majors.")


def insert_students(conn, data):
    students = data.get("STUDENT", [])
    if not students:
        print("No STUDENT data found.")
        return

    sql = """
        INSERT INTO students (
            student_id, student_first_name, student_last_name,
            student_gpa, student_total_credits, major_id, has_account
        )
        VALUES (%s, %s, %s, %s, %s, %s, %s)
    """
    cur = conn.cursor()
    for row in students:
        cur.execute(
            sql,
            (
                row["student_id"],
                row["student_first_name"],
                row["student_last_name"],
                row.get("student_gpa"),
                row.get("student_total_credits"),
                row.get("major_id"),
                0,  # has_account default false; we'll flip to 1 when they register
            ),
        )
    cur.close()
    conn.commit()
    print(f"Inserted {len(students)} students.")


def insert_professors(conn, data):
    """
    JSON has:
      "PROFESSOR": [{"professor_id": 1, "professor_name": "Dr. Karen Liu", "department": "..."}]

    Our MySQL schema uses:
      professors(professor_first_name, professor_last_name, department)
    """
    profs = data.get("PROFESSOR", [])
    if not profs:
        print("No PROFESSOR data found.")
        return

    sql = """
        INSERT INTO professors (
            professor_id, professor_first_name, professor_last_name, department
        )
        VALUES (%s, %s, %s, %s)
    """
    cur = conn.cursor()
    for row in profs:
        full_name = row["professor_name"]
        first, last = safe_name_split(full_name)
        cur.execute(
            sql,
            (
                row["professor_id"],
                first,
                last,
                row["department"],
            ),
        )
    cur.close()
    conn.commit()
    print(f"Inserted {len(profs)} professors.")


def insert_courses(conn, data):
    courses = data.get("COURSE", [])
    if not courses:
        print("No COURSE data found.")
        return

    sql = """
        INSERT INTO courses (
            course_id, course_name, course_credits, major_id
        )
        VALUES (%s, %s, %s, %s)
    """
    cur = conn.cursor()
    for row in courses:
        cur.execute(
            sql,
            (
                row["course_id"],
                row["course_name"],
                row["course_credits"],
                row.get("major_id"),
            ),
        )
    cur.close()
    conn.commit()
    print(f"Inserted {len(courses)} courses.")


def insert_classes(conn, data):
    classes = data.get("CLASS", [])
    if not classes:
        print("No CLASS data found.")
        return

    sql = """
        INSERT INTO classes (
            class_id, course_id, professor_id, class_type
        )
        VALUES (%s, %s, %s, %s)
    """
    cur = conn.cursor()
    for row in classes:
        cur.execute(
            sql,
            (
                row["class_id"],
                row["course_id"],
                row["professor_id"],
                row["class_type"],
            ),
        )
    cur.close()
    conn.commit()
    print(f"Inserted {len(classes)} classes.")


def insert_assignments(conn, data):
    assignments = data.get("ASSIGNMENT", [])
    if not assignments:
        print("No ASSIGNMENT data found.")
        return

    sql = """
        INSERT INTO assignments (
            assignment_id, class_id, assignment_name,
            assignment_type, assignment_score_weight
        )
        VALUES (%s, %s, %s, %s, %s)
    """
    cur = conn.cursor()
    for row in assignments:
        cur.execute(
            sql,
            (
                row["assignment_id"],
                row["class_id"],
                row["assignment_name"],
                row["assignment_type"],
                row["assignment_score_weight"],
            ),
        )
    cur.close()
    conn.commit()
    print(f"Inserted {len(assignments)} assignments.")


def insert_work_load(conn, data):
    wl = data.get("WORK_LOAD", [])
    if not wl:
        print("No WORK_LOAD data found.")
        return

    sql = """
        INSERT INTO work_load (student_id, assignment_id)
        VALUES (%s, %s)
    """
    cur = conn.cursor()
    for row in wl:
        cur.execute(sql, (row["student_id"], row["assignment_id"]))
    cur.close()
    conn.commit()
    print(f"Inserted {len(wl)} work_load records.")


def insert_schedule(conn, data):
    sched = data.get("SCHEDULE", [])
    if not sched:
        print("No SCHEDULE data found.")
        return

    sql = """
        INSERT INTO schedule (student_id, class_id)
        VALUES (%s, %s)
    """
    cur = conn.cursor()
    for row in sched:
        cur.execute(sql, (row["student_id"], row["class_id"]))
    cur.close()
    conn.commit()
    print(f"Inserted {len(sched)} schedule records.")


def insert_study_guide(conn, data):
    sgs = data.get("STUDY_GUIDE", [])
    if not sgs:
        print("No STUDY_GUIDE data found.")
        return

    # JSON: sg_id, class_id
    # DB: study_guide_id (AUTO_INCREMENT), class_id
    sql = """
        INSERT INTO study_guide (study_guide_id, class_id)
        VALUES (%s, %s)
    """
    cur = conn.cursor()
    for row in sgs:
        cur.execute(
            sql,
            (
                row["sg_id"],
                row["class_id"],
            ),
        )
    cur.close()
    conn.commit()
    print(f"Inserted {len(sgs)} study_guide records.")


def insert_ai_chat_log(conn, data):
    logs = data.get("AI_CHAT_LOG", [])
    if not logs:
        print("No AI_CHAT_LOG data found.")
        return

    sql = """
        INSERT INTO ai_chat_log (
            chat_log_id, student_id, chat_timestamp,
            user_message, ai_response
        )
        VALUES (%s, %s, %s, %s, %s)
    """
    cur = conn.cursor()
    for row in logs:
        # Convert "2025-10-15T09:30:00" -> "2025-10-15 09:30:00"
        ts = row["timestamp"].replace("T", " ")
        cur.execute(
            sql,
            (
                row["log_id"],
                row["student_id"],
                ts,
                row["user_message"],
                row["ai_response"],
            ),
        )
    cur.close()
    conn.commit()
    print(f"Inserted {len(logs)} ai_chat_log records.")


def create_default_admin(conn):
    """
    Create a default admin user if none exists.
    Email: admin@candace.local
    Password: changeme
    """
    cur = conn.cursor(dictionary=True)
    cur.execute("SELECT id FROM users WHERE role = 'admin' LIMIT 1")
    existing = cur.fetchone()
    if existing:
        print("Admin user already exists, skipping admin creation.")
        cur.close()
        return

    email = "admin@candace.local"
    raw_password = "changeme"
    password_hash = generate_password_hash(raw_password)

    cur.execute(
        """
        INSERT INTO users (email, password_hash, role)
        VALUES (%s, %s, 'admin')
        """,
        (email, password_hash),
    )
    conn.commit()
    cur.close()
    print("Created default admin user:")
    print("  email:    admin@candace.local")
    print("  password: changeme  (please change this!)")


def main(json_path: Path | None = None):
    json_path = json_path or DEFAULT_JSON_PATH
    if not json_path.exists():
        print(f"JSON file not found at: {json_path}")
        return

    with open(json_path, "r", encoding="utf-8") as f:
        data = json.load(f)

    conn = get_connection()
    try:
        insert_majors(conn, data)
        insert_students(conn, data)
        insert_professors(conn, data)
        insert_courses(conn, data)
        insert_classes(conn, data)
        insert_assignments(conn, data)
        insert_work_load(conn, data)
        insert_schedule(conn, data)
        insert_study_guide(conn, data)
        insert_ai_chat_log(conn, data)

        create_default_admin(conn)

        print("\n✅ Migration complete.")
        conn.close()
    except Exception as e:
        conn.rollback()
        conn.close()
        print(f"\n❌ Migration failed, rolled back. Error: {e}")


if __name__ == "__main__":
    main()
