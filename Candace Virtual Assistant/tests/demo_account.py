from werkzeug.security import generate_password_hash
import mysql.connector
import os
from dotenv import load_dotenv

load_dotenv()

db = mysql.connector.connect(
    host=os.getenv("DB_HOST"),
    user=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
    database="candace_assistant"
)

cursor = db.cursor()

email = "emiliovasquez@ucc.edu"
password_hash = generate_password_hash("Password123!")
student_id = 31  # Emilio

sql = """
INSERT IGNORE INTO users (email, password_hash, role, student_id)
VALUES (%s, %s, 'student', %s)
"""

cursor.execute(sql, (email, password_hash, student_id))
db.commit()

print("Created demo user:", email)