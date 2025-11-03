import sqlite3

connection = sqlite3.connect("database/candace.db")

cursor = connection.cursor()

students = [
    (1679866, "Miguel", "Torres", 3.59, 60, 14),
    (1841238, "Taina", "Carrasquillo", 3.21, 45, 6),
    (4587245, "Julio", "Padilla", 3.83, 56, 14)
]

cursor.executemany("INSERT INTO STUDENT (student_id, student_first_name, student_last_name, student_gpa, student_total_credits, major_id) VALUES (?,?,?,?,?,?)", students)

cursor.execute("SELECT * FROM STUDENT")

rows = cursor.fetchall()

for row in rows:
    print(row)
