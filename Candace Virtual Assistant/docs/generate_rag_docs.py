import json, os

with open("student_database_final.json", "r", encoding="utf-8") as f:
    data = json.load(f)

out_dir = "docs_formatted"
os.makedirs(out_dir, exist_ok=True)

for student in data["STUDENT"]:
    sid = student["student_id"]
    name = f"{student['student_first_name']} {student['student_last_name']}"
    major = next(m['major_name'] for m in data['MAJOR'] if m['major_id'] == student['major_id'])
    courses = [
        c["course_name"]
        for sch in data["SCHEDULE"]
        if sch["student_id"] == sid
        for cls in data["CLASS"]
        if cls["class_id"] == sch["class_id"]
        for c in data["COURSE"]
        if c["course_id"] == cls["course_id"]
    ]
    text = f"""[Student] {name}
Major: {major}
Courses Enrolled: {", ".join(courses) if courses else "None"}
GPA: {student['student_gpa']}
Credits: {student['student_total_credits']}
"""
    with open(f"{out_dir}/student_{sid}_{name.replace(' ', '_')}.txt", "w", encoding="utf-8") as f_out:
        f_out.write(text)

## python ingest_rag.py "C:\Users\emilio.vasquez\Downloads\Undergraduate-Research\Candace-Virtual-Assistant\Candace Virtual Assistant\docs\docs_formatted"