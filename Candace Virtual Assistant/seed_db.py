# database/seed_db.py

import sys
from pathlib import Path

import mysql.connector
from config import Config   # <-- USE YOUR CONFIG


BASE_DIR = Path(__file__).resolve().parent
SCHEMA_FILE = BASE_DIR / "database/schema.sql"

SECOND_FILE = BASE_DIR / "database/second_run.sql"

SEEDS_DIR = BASE_DIR / "database/seeds"
MODULE_DATA_DIR = SEEDS_DIR / "module_data"

# Additional seed files
LECTURERS_FILE = SEEDS_DIR / "lecturers-fake-data.sql"
STUDENTS_FILE = SEEDS_DIR / "student-fake-data.sql"
COURSE_SYLLABUS_FILE = SEEDS_DIR / "course-syllabus-fake-data.sql"


# ------------------------------------------
# Build DB config from config.py
# ------------------------------------------

DB_CONFIG = {
    "host": Config.DB_HOST,
    "user": Config.DB_USER,
    "password": Config.DB_PASSWORD,
    "database": Config.DB_NAME,
    "port": Config.DB_PORT,
}


def load_sql(path: Path) -> str:
    if not path.exists():
        raise FileNotFoundError(f"SQL file not found: {path}")
    return path.read_text(encoding="utf-8")


def run_sql_file(cursor, path: Path):
    print(f"\n=== Running {path.relative_to(BASE_DIR)} ===")
    sql = load_sql(path)

    # Split statements (safe for our schema + inserts)
    stmts = [s.strip() for s in sql.split(";") if s.strip()]
    for stmt in stmts:
        cursor.execute(stmt)


def main():
    print("\n🔌 Connecting to MySQL using config.py...")
    print(DB_CONFIG)

    # connect with multi-statements enabled
    cnx = mysql.connector.connect(**DB_CONFIG)
    cursor = cnx.cursor()

    try:
        # 1) Schema
        print("\n===========================")
        print("  Running schema.sql")
        print("===========================")
        run_sql_file(cursor, SCHEMA_FILE)
        cnx.commit()

        print("\n===========================")
        print("  Running setting up tables second_.sql")
        print("===========================")
        run_sql_file(cursor, SECOND_FILE)
        cnx.commit()

        # 2) Module / assignment / item data
        module_files = sorted(MODULE_DATA_DIR.glob("*.sql"))
        print("\n===========================")
        print("  Running module seed files")
        print("===========================")
        for f in module_files:
            run_sql_file(cursor, f)
            cnx.commit()

        # 3) Professors + instructor logins
        if LECTURERS_FILE.exists():
            print("\n===========================")
            print("  Running lecturer seeds")
            print("===========================")
            run_sql_file(cursor, LECTURERS_FILE)
            cnx.commit()

        # 4) Students + schedule + workload
        if STUDENTS_FILE.exists():
            print("\n===========================")
            print("  Running student seeds")
            print("===========================")
            run_sql_file(cursor, STUDENTS_FILE)
            cnx.commit()

        # 5) Course syllabus data
        if COURSE_SYLLABUS_FILE.exists():
            print("\n===========================")
            print("  Running syllabus seeds")
            print("===========================")
            run_sql_file(cursor, COURSE_SYLLABUS_FILE)
            cnx.commit()

        print("\n🎉 SUCCESS! Database seeding is complete.\n")

    except Exception as e:
        cnx.rollback()
        print("\n❌ ERROR during seeding:", e)
        sys.exit(1)
    finally:
        cursor.close()
        cnx.close()


if __name__ == "__main__":
    main()

## Run: python seed_db.py