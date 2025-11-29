"""
Export database data into text files under docs/ so they can be ingested by ingest_rag.py

- Global data -> docs/db_global/
- Per-student data -> docs/db_students/

Usage:
    python export_db_rag_docs.py
"""

import os
from pathlib import Path

import mysql.connector

from config import Config  # adjust if your config class is elsewhere


# ---------- DB HELPERS ----------

def get_connection():
    cfg = Config()
    return mysql.connector.connect(
        host=cfg.DB_HOST,
        user=cfg.DB_USER,
        password=cfg.DB_PASSWORD,
        database=cfg.DB_NAME,
        port=getattr(cfg, "DB_PORT", 3306),
    )


# ---------- FETCHERS (MATCHED TO YOUR SCHEMA) ----------

def fetch_all_courses(conn):
    """
    Global: all courses (not class sections).
    """
    sql = """
        SELECT
            c.course_id,
            c.course_name,
            c.course_credits,
            m.major_name,
            m.department
        FROM courses c
        LEFT JOIN majors m ON c.major_id = m.major_id
        ORDER BY m.department, c.course_name
    """
    cur = conn.cursor(dictionary=True)
    cur.execute(sql)
    rows = cur.fetchall()
    cur.close()
    return rows


def fetch_all_syllabi(conn):
    """
    Global: all course_syllabus entries joined to classes, courses, and professors.
    Each row represents ONE class with its syllabus.
    """
    sql = """
        SELECT
            cs.id AS syllabus_id,
            cs.class_id,
            cs.description,
            cs.learning_outcomes,
            cs.grading_policy,
            c.course_id,
            c.course_name,
            c.course_credits,
            m.major_name,
            m.department,
            p.professor_first_name,
            p.professor_last_name
        FROM course_syllabus cs
        JOIN classes cl       ON cs.class_id = cl.class_id
        JOIN courses c        ON cl.course_id = c.course_id
        LEFT JOIN majors m    ON c.major_id = m.major_id
        LEFT JOIN professors p ON cl.professor_id = p.professor_id
        ORDER BY c.course_name, cs.class_id
    """
    cur = conn.cursor(dictionary=True)
    cur.execute(sql)
    rows = cur.fetchall()
    cur.close()
    return rows


def fetch_all_students(conn):
    """
    Per-student: basic profile info.
    """
    sql = """
        SELECT
            s.student_id,
            s.student_first_name,
            s.student_last_name,
            s.student_gpa,
            s.student_total_credits,
            s.has_account,
            s.user_id,
            m.major_name,
            m.department
        FROM students s
        LEFT JOIN majors m ON s.major_id = m.major_id
        ORDER BY s.student_id
    """
    cur = conn.cursor(dictionary=True)
    cur.execute(sql)
    rows = cur.fetchall()
    cur.close()
    return rows


def fetch_schedule_for_student(conn, student_id: int):
    """
    Per-student: enrolled classes (schedule).
    """
    sql = """
        SELECT
            sch.class_id,
            cl.class_type,
            c.course_id,
            c.course_name,
            c.course_credits,
            p.professor_first_name,
            p.professor_last_name
        FROM schedule sch
        JOIN classes cl      ON sch.class_id = cl.class_id
        JOIN courses c       ON cl.course_id = c.course_id
        LEFT JOIN professors p ON cl.professor_id = p.professor_id
        WHERE sch.student_id = %s
        ORDER BY c.course_name, sch.class_id
    """
    cur = conn.cursor(dictionary=True)
    cur.execute(sql, (student_id,))
    rows = cur.fetchall()
    cur.close()
    return rows


def fetch_assignment_overview_for_student(conn, student_id: int):
    """
    Optional: per-student assignment/grade summary.
    """
    sql = """
        SELECT
            ag.assignment_id,
            ag.score,
            ag.submitted_at,
            ag.status,
            a.assignment_name,
            a.assignment_type,
            a.due_at,
            a.max_points,
            a.assignment_score_weight,
            c.course_name,
            c.course_credits
        FROM assignment_grades ag
        JOIN assignments a ON ag.assignment_id = a.assignment_id
        JOIN classes cl    ON a.class_id = cl.class_id
        JOIN courses c     ON cl.course_id = c.course_id
        WHERE ag.student_id = %s
        ORDER BY c.course_name, a.due_at, a.assignment_name
    """
    cur = conn.cursor(dictionary=True)
    cur.execute(sql, (student_id,))
    rows = cur.fetchall()
    cur.close()
    return rows


# ---------- TEXT FORMATTERS ----------

def format_global_courses(courses):
    """
    Turn the courses table into a text block for RAG.
    """
    lines = []
    lines.append("GLOBAL COURSE CATALOG")
    lines.append("========================================\n")

    for row in courses:
        lines.append(f"COURSE_ID: {row['course_id']}")
        lines.append(f"COURSE_NAME: {row['course_name']}")
        lines.append(f"CREDITS: {row['course_credits']}")
        if row.get("major_name"):
            lines.append(f"MAJOR: {row['major_name']}")
        if row.get("department"):
            lines.append(f"DEPARTMENT: {row['department']}")
        lines.append("")  # blank line between courses

    return "\n".join(lines).strip() + "\n"


def format_global_syllabi(syllabi):
    """
    Turn course_syllabus + course/class/professor into a big global text block.
    """
    lines = []
    lines.append("GLOBAL COURSE SYLLABI")
    lines.append("========================================\n")

    for row in syllabi:
        lines.append(f"SYLLABUS_ID: {row['syllabus_id']}")
        lines.append(f"CLASS_ID: {row['class_id']}")
        lines.append(
            f"COURSE: {row['course_name']} "
            f"({row['course_credits']} credits)"
        )
        if row.get("major_name"):
            lines.append(f"MAJOR: {row['major_name']}")
        if row.get("department"):
            lines.append(f"DEPARTMENT: {row['department']}")
        prof = (
            f"{row.get('professor_first_name') or ''} "
            f"{row.get('professor_last_name') or ''}"
        ).strip()
        if prof:
            lines.append(f"INSTRUCTOR: {prof}")
        lines.append("\nDESCRIPTION:")
        lines.append(row["description"] or "")
        lines.append("\nLEARNING OUTCOMES:")
        lines.append(row["learning_outcomes"] or "")
        lines.append("\nGRADING POLICY:")
        lines.append(row["grading_policy"] or "")
        lines.append("")  # blank line between syllabi

    return "\n".join(lines).strip() + "\n"


def format_student_doc(student, schedule_rows, assignments_rows):
    """
    Build a per-student context file with:
    - Profile
    - Schedule
    - Assignment/grade overview
    """
    lines = []

    # --- Profile ---
    lines.append("STUDENT PROFILE")
    lines.append("========================================")
    lines.append(f"STUDENT_ID: {student['student_id']}")
    full_name = f"{student['student_first_name']} {student['student_last_name']}"
    lines.append(f"NAME: {full_name}")
    if student.get("major_name"):
        lines.append(f"MAJOR: {student['major_name']}")
    if student.get("department"):
        lines.append(f"DEPARTMENT: {student['department']}")
    if student.get("student_gpa") is not None:
        lines.append(f"GPA: {student['student_gpa']}")
    if student.get("student_total_credits") is not None:
        lines.append(f"TOTAL_CREDITS: {student['student_total_credits']}")
    lines.append(f"HAS_ACCOUNT: {student['has_account']}")
    if student.get("user_id") is not None:
        lines.append(f"LINKED_USER_ID: {student['user_id']}")
    lines.append("")

    # --- Schedule ---
    lines.append("CURRENT SCHEDULE")
    lines.append("========================================")
    if not schedule_rows:
        lines.append("No classes on record.")
    else:
        for row in schedule_rows:
            lines.append(
                f"- CLASS_ID: {row['class_id']} | "
                f"{row['course_name']} "
                f"({row['course_credits']} credits) "
                f"[TYPE: {row['class_type']}]"
            )
            prof = (
                f"{row.get('professor_first_name') or ''} "
                f"{row.get('professor_last_name') or ''}"
            ).strip()
            if prof:
                lines.append(f"  INSTRUCTOR: {prof}")
            lines.append("")  # blank line between classes
    lines.append("")

    # --- Assignments / Grades ---
    lines.append("ASSIGNMENTS & GRADES OVERVIEW")
    lines.append("========================================")
    if not assignments_rows:
        lines.append("No assignment grades on record.")
    else:
        for row in assignments_rows:
            lines.append(
                f"- {row['course_name']} | {row['assignment_name']} "
                f"[TYPE: {row['assignment_type']}]"
            )
            lines.append(
                f"  MAX_POINTS: {row['max_points']} | "
                f"WEIGHT: {row['assignment_score_weight']}"
            )
            lines.append(f"  STATUS: {row['status']}")
            if row.get("score") is not None:
                lines.append(f"  SCORE: {row['score']}")
            if row.get("due_at"):
                lines.append(f"  DUE_AT: {row['due_at']}")
            if row.get("submitted_at"):
                lines.append(f"  SUBMITTED_AT: {row['submitted_at']}")
            lines.append("")  # blank line between assignments

    return "\n".join(lines).strip() + "\n"


# ---------- MAIN EXPORT LOGIC ----------

def main():
    root = Path(__file__).resolve().parent
    docs_dir = root / "docs"
    db_global_dir = docs_dir / "db_global"
    db_students_dir = docs_dir / "db_students"

    db_global_dir.mkdir(parents=True, exist_ok=True)
    db_students_dir.mkdir(parents=True, exist_ok=True)

    conn = get_connection()
    try:
        # 1) Global: courses
        print("[export_db_rag_docs] Fetching courses...")
        courses = fetch_all_courses(conn)
        global_courses_text = format_global_courses(courses)
        courses_path = db_global_dir / "courses_global.txt"
        courses_path.write_text(global_courses_text, encoding="utf-8")
        print(f"[export_db_rag_docs] Wrote global courses to: {courses_path}")

        # 2) Global: syllabi
        print("[export_db_rag_docs] Fetching syllabi...")
        syllabi = fetch_all_syllabi(conn)
        syllabi_text = format_global_syllabi(syllabi)
        syllabi_path = db_global_dir / "syllabi_global.txt"
        syllabi_path.write_text(syllabi_text, encoding="utf-8")
        print(f"[export_db_rag_docs] Wrote global syllabi to: {syllabi_path}")

        # 3) Per-student docs
        print("[export_db_rag_docs] Fetching students...")
        students = fetch_all_students(conn)
        print(f"[export_db_rag_docs] Found {len(students)} students")

        for student in students:
            sid = student["student_id"]
            schedule_rows = fetch_schedule_for_student(conn, sid)
            assignments_rows = fetch_assignment_overview_for_student(conn, sid)
            content = format_student_doc(student, schedule_rows, assignments_rows)
            out_path = db_students_dir / f"student_{sid}.txt"
            out_path.write_text(content, encoding="utf-8")
            # If you want logs:
            # print(f"[export_db_rag_docs] Wrote {out_path}")

        print("[export_db_rag_docs] Done exporting DB → docs/.")

    finally:
        conn.close()


if __name__ == "__main__":
    main()
