"""Utility script to load student_database_final.json into candace.db.

Run with:  python database/load_student_dataset.py
"""

from __future__ import annotations

import json
import sqlite3
from pathlib import Path
from typing import Dict, Iterable, List, Tuple

BASE_DIR = Path(__file__).resolve().parents[1]
DEFAULT_DB = BASE_DIR / "database" / "candace.db"
DEFAULT_DATASET = Path(__file__).with_name("student_database_final.json")


def _read_dataset(path: Path) -> Dict[str, List[Dict[str, object]]]:
    with path.open("r", encoding="utf-8") as fh:
        return json.load(fh)


def _split_name(full_name: str) -> Tuple[str, str]:
    parts = (full_name or "").strip().split()
    if not parts:
        return "", ""
    first = parts[0]
    last = " ".join(parts[1:]) or first
    return first, last


def _clear_tables(conn: sqlite3.Connection, tables: Iterable[str]) -> None:
    for table in tables:
        conn.execute(f"DELETE FROM {table}")


def _insert_rows(conn: sqlite3.Connection, dataset: Dict[str, List[Dict[str, object]]]) -> None:
    conn.executemany(
        """
        INSERT INTO MAJOR (major_id, major_name, department)
        VALUES (:major_id, :major_name, :department)
        """,
        dataset.get("MAJOR", []),
    )

    students = [dict(item, has_account=0) for item in dataset.get("STUDENT", [])]
    conn.executemany(
        """
        INSERT INTO STUDENT (
            student_id, student_first_name, student_last_name,
            student_gpa, student_total_credits, major_id, has_account
        ) VALUES (
            :student_id, :student_first_name, :student_last_name,
            :student_gpa, :student_total_credits, :major_id, :has_account
        )
        """,
        students,
    )

    professors_payload = []
    for professor in dataset.get("PROFESSOR", []):
        first, last = _split_name(professor.get("professor_name", ""))
        professors_payload.append(
            {
                "professor_id": professor.get("professor_id"),
                "professor_first_name": first,
                "professor_last_name": last,
                "department": professor.get("department"),
            }
        )
    conn.executemany(
        """
        INSERT INTO PROFESSOR (professor_id, professor_first_name, professor_last_name, department)
        VALUES (:professor_id, :professor_first_name, :professor_last_name, :department)
        """,
        professors_payload,
    )

    conn.executemany(
        """
        INSERT INTO COURSE (course_id, course_name, course_credits, major_id)
        VALUES (:course_id, :course_name, :course_credits, :major_id)
        """,
        dataset.get("COURSE", []),
    )

    conn.executemany(
        """
        INSERT INTO CLASS (class_id, course_id, professor_id, class_type)
        VALUES (:class_id, :course_id, :professor_id, :class_type)
        """,
        dataset.get("CLASS", []),
    )

    conn.executemany(
        """
        INSERT INTO ASSIGNMENT (
            assignment_id, class_id, assignment_name, assignment_type, assignment_score_weight
        ) VALUES (
            :assignment_id, :class_id, :assignment_name, :assignment_type, :assignment_score_weight
        )
        """,
        dataset.get("ASSIGNMENT", []),
    )

    conn.executemany(
        """
        INSERT INTO WORK_LOAD (student_id, assignment_id)
        VALUES (:student_id, :assignment_id)
        """,
        dataset.get("WORK_LOAD", []),
    )

    conn.executemany(
        """
        INSERT INTO SCHEDULE (student_id, class_id)
        VALUES (:student_id, :class_id)
        """,
        dataset.get("SCHEDULE", []),
    )

    study_guides = [
        {
            "study_guide_id": item.get("sg_id"),
            "class_id": item.get("class_id"),
        }
        for item in dataset.get("STUDY_GUIDE", [])
    ]
    conn.executemany(
        """
        INSERT INTO STUDY_GUIDE (study_guide_id, class_id)
        VALUES (:study_guide_id, :class_id)
        """,
        study_guides,
    )

    chat_logs = [
        {
            "chat_log_id": item.get("log_id"),
            "student_id": item.get("student_id"),
            "chat_timestamp": item.get("timestamp"),
            "user_message": item.get("user_message"),
            "ai_response": item.get("ai_response"),
        }
        for item in dataset.get("AI_CHAT_LOG", [])
    ]
    conn.executemany(
        """
        INSERT INTO AI_CHAT_LOG (
            chat_log_id, student_id, chat_timestamp, user_message, ai_response
        ) VALUES (
            :chat_log_id, :student_id, :chat_timestamp, :user_message, :ai_response
        )
        """,
        chat_logs,
    )


def main(json_path: Path = DEFAULT_DATASET, db_path: Path = DEFAULT_DB) -> None:
    if not json_path.exists():
        raise SystemExit(f"Dataset file not found: {json_path}")
    db_path.parent.mkdir(parents=True, exist_ok=True)

    dataset = _read_dataset(json_path)
    with sqlite3.connect(db_path) as conn:
        conn.execute("PRAGMA foreign_keys = ON")
        _clear_tables(
            conn,
            [
                "AI_CHAT_LOG",
                "STUDY_GUIDE",
                "SCHEDULE",
                "WORK_LOAD",
                "ASSIGNMENT",
                "CLASS",
                "COURSE",
                "PROFESSOR",
                "STUDENT",
                "MAJOR",
            ],
        )
        _insert_rows(conn, dataset)
        conn.commit()
    print(f"Loaded sample dataset from {json_path} into {db_path}")


if __name__ == "__main__":
    main()