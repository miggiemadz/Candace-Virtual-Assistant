import os
import json
import sqlite3

base_dir = os.path.abspath(os.path.dirname(__file__))
DB_path = os.path.join(base_dir, "..", "database", "candace.db")
JSON_path = os.path.join(base_dir, "..", "database", "fake_students_data.json")

conn = sqlite3.connect(DB_path)
cur = conn.cursor()

with open(JSON_path, "r") as f:
    data = json.load(f)

students = data["STUDENT"]
logins = data["LOGIN_INFORMATION"]

cur.execute("SELECT COUNT(*) FROM STUDENT")
count_stu = cur.fetchone()[0]
if (count_stu == 0):
    print("Seeding student data into database...")
    for s in students:
        cur.execute("""
                INSERT INTO STUDENT (student_id, student_first_name, student_last_name, 
                                     student_gpa, student_total_credits, major_id, has_account) 
                VALUES (?,?,?,?,?,?,?)
                """, (
                    s["student_id"],
                    s["student_first_name"],
                    s["student_last_name"],
                    s["student_gpa"],
                    s["student_total_credits"],
                    s["major_id"],                        
                    int(s["has_account"])
                ))
        
cur.execute("SELECT COUNT(*) FROM LOGIN_INFO")
count_login = cur.fetchone()[0]
if (count_login == 0):
    print("Seeding login data into database...")
    for l in logins:
        cur.execute("""
                INSERT INTO LOGIN_INFO (login_id, student_id, login_password)
                VALUES (?,?,?)
                """, (
                    l["login_id"],
                    l["student_id"],
                    l["login_password"]
                ))
    conn.commit()
    print("Database seeding complete.")
else:
    print("Database already has data - skipping seeding..")

conn.close()