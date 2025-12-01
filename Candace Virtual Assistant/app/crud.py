# app/crud.py

from .db_utils import query_db

# Note: This file is completely rewritten to use the MySQL connection from db_utils
# and to provide specific, tool-like functions for a RAG Router.

def get_student_profile(student_id: int) -> str:
    """Gets a student's profile, GPA, and major.
    Returns a formatted string ready for an LLM context.
    """
    profile = query_db(
        """
        SELECT s.student_first_name, s.student_last_name, s.student_gpa, 
               s.student_total_credits, m.major_name
        FROM students s
        LEFT JOIN majors m ON s.major_id = m.major_id
        WHERE s.student_id = %s
        """,
        (student_id,),
        one=True
    )
    if not profile:
        return "No student profile found."

    name = f"{profile['student_first_name']} {profile['student_last_name']}"
    major = profile.get('major_name') or "Undeclared"
    gpa = profile.get('student_gpa')
    credits = profile.get('student_total_credits')
    
    response = f"Student Name: {name}\nMajor: {major}"
    if gpa is not None:
        response += f"\nGPA: {gpa}"
    if credits is not None:
        response += f"\nTotal Credits: {credits}"
    return response

def get_student_schedule(student_id: int) -> str:
    """Gets a student's current class schedule.
    Returns a formatted string ready for an LLM context.
    """
    schedule = query_db(
        """
        SELECT c.course_name, p.professor_first_name, p.professor_last_name
        FROM schedule s
        JOIN classes cl ON s.class_id = cl.class_id
        JOIN courses c ON cl.course_id = c.course_id
        JOIN professors p ON cl.professor_id = p.professor_id
        WHERE s.student_id = %s
        """,
        (student_id,)
    )
    if not schedule:
        return "The student is not enrolled in any classes."

    lines = ["Current schedule:"]
    for row in schedule:
        prof_name = f"{row['professor_first_name']} {row['professor_last_name']}"
        lines.append(f"- {row['course_name']} (Instructor: {prof_name})")
    return "\n".join(lines)

def get_upcoming_assignments(student_id: int, course_name: str = None) -> str:
    """Gets a student's upcoming assignments, optionally filtered by course.
    Returns a formatted string ready for an LLM context.
    """
    base_query = """
        SELECT a.assignment_name, c.course_name, a.due_at
        FROM assignments a
        JOIN classes cl ON a.class_id = cl.class_id
        JOIN courses c ON cl.course_id = c.course_id
        JOIN schedule s ON cl.class_id = s.class_id
        WHERE s.student_id = %s AND a.due_at > NOW() AND a.is_published = 1
    """
    params = [student_id]
    
    if course_name:
        base_query += " AND c.course_name LIKE %s"
        params.append(f"%{course_name}%")
        
    base_query += " ORDER BY a.due_at ASC LIMIT 10"
    
    assignments = query_db(base_query, tuple(params))
    
    if not assignments:
        if course_name:
            return f"No upcoming assignments found for {course_name}."
        return "No upcoming assignments found."

    lines = ["Upcoming assignments:"]
    for row in assignments:
        due_date = row['due_at'].strftime("%A, %B %d at %I:%M %p")
        lines.append(f"- {row['assignment_name']} for {row['course_name']} is due on {due_date}")
    return "\n".join(lines)

def get_recent_grades(student_id: int, limit: int = 5) -> str:
    """Gets the most recently graded assignments for a student.
    Returns a formatted string ready for an LLM context.
    """
    grades = query_db(
        """
        SELECT a.assignment_name, c.course_name, ag.score, a.max_points
        FROM assignment_grades ag
        JOIN assignments a ON ag.assignment_id = a.assignment_id
        JOIN classes cl ON a.class_id = cl.class_id
        JOIN courses c ON cl.course_id = c.course_id
        WHERE ag.student_id = %s AND ag.status = 'graded'
        ORDER BY ag.submitted_at DESC
        LIMIT %s
        """,
        (student_id, limit)
    )
    if not grades:
        return "No recently graded assignments found."

    lines = ["Recently graded assignments:"]
    for row in grades:
        score = row['score']
        max_points = row['max_points']
        lines.append(f"- {row['assignment_name']} ({row['course_name']}): {score}/{max_points}")
    return "\n".join(lines)

def get_class_professor(student_id: int, course_name: str) -> str:
    """Finds the professor for a specific course the student is enrolled in.
    Returns a formatted string ready for an LLM context.
    """
    professor = query_db(
        """
        SELECT p.professor_first_name, p.professor_last_name, c.course_name
        FROM professors p
        JOIN classes cl ON p.professor_id = cl.professor_id
        JOIN courses c ON cl.course_id = c.course_id
        JOIN schedule s ON cl.class_id = s.class_id
        WHERE s.student_id = %s AND c.course_name LIKE %s
        LIMIT 1
        """,
        (student_id, f"%{course_name}%"),
        one=True
    )
    if not professor:
        return f"Could not find a professor for a course matching '{course_name}'. Make sure you are enrolled and the course name is correct."

    prof_name = f"{professor['professor_first_name']} {professor['professor_last_name']}"
    return f"The instructor for {professor['course_name']} is Professor {prof_name}."

def get_recent_announcements(student_id: int, course_name: str = None) -> str:
    """Gets recent announcements from a student's courses.
    Returns a formatted string ready for an LLM context.
    """
    base_query = """
        SELECT ca.title, ca.body, c.course_name, ca.posted_at
        FROM course_announcements ca
        JOIN classes cl ON ca.class_id = cl.class_id
        JOIN courses c ON cl.course_id = c.course_id
        JOIN schedule s ON cl.class_id = s.class_id
        WHERE s.student_id = %s
    """
    params = [student_id]

    if course_name:
        base_query += " AND c.course_name LIKE %s"
        params.append(f"%{course_name}%")

    base_query += " ORDER BY ca.posted_at DESC LIMIT 5"

    announcements = query_db(base_query, tuple(params))

    if not announcements:
        return "No recent announcements found."

    lines = ["Recent announcements:"]
    for row in announcements:
        posted_date = row['posted_at'].strftime("%B %d")
        lines.append(f"- For {row['course_name']} ({posted_date}): {row['title']}\n  {row['body']}")
    return "\n".join(lines)

def get_course_syllabus_info(student_id: int, course_name: str) -> str:
    """Gets syllabus information (description, outcomes, grading) for a specific course.
    Returns a formatted string ready for an LLM context.
    """
    syllabus = query_db(
        """
        SELECT cs.description, cs.learning_outcomes, cs.grading_policy, c.course_name
        FROM course_syllabus cs
        JOIN classes cl ON cs.class_id = cl.class_id
        JOIN courses c ON cl.course_id = c.course_id
        JOIN schedule s ON cl.class_id = s.class_id
        WHERE s.student_id = %s AND c.course_name LIKE %s
        LIMIT 1
        """,
        (student_id, f"%{course_name}%"),
        one=True
    )
    if not syllabus:
        return f"No syllabus information found for a course matching '{course_name}'."

    lines = [f"Syllabus Information for {syllabus['course_name']}:"]
    lines.append("\n[Course Description]\n" + syllabus['description'])
    lines.append("\n[Learning Outcomes]\n" + syllabus['learning_outcomes'].replace('\n', '\n- '))
    lines.append("\n[Grading Policy]\n" + syllabus['grading_policy'].replace('\n', '\n- '))
    return "\n".join(lines)

def get_course_module_content(student_id: int, course_name: str, module_title: str) -> str:
    """Gets the items within a specific module for a course the student is taking.
    Returns a formatted string ready for an LLM context.
    """
    items = query_db(
        """
        SELECT cmi.title, cmi.item_type
        FROM course_module_items cmi
        JOIN course_modules cm ON cmi.module_id = cm.id
        JOIN classes cl ON cm.class_id = cl.class_id
        JOIN courses c ON cl.course_id = c.course_id
        JOIN schedule s ON cl.class_id = s.class_id
        WHERE s.student_id = %s AND c.course_name LIKE %s AND cm.title LIKE %s
        ORDER BY cmi.position ASC
        """,
        (student_id, f"%{course_name}%", f"%{module_title}%")
    )

    if not items:
        return f"Could not find content for a module matching '{module_title}' in the course '{course_name}'."

    lines = [f"Content for module '{module_title}':"]
    for item in items:
        lines.append(f"- ({item['item_type'].capitalize()}) {item['title']}")
    return "\n".join(lines)

def get_assignment_grade(student_id: int, assignment_name: str) -> str:
    """Gets the grade for a specific assignment by its name.
    Returns a formatted string ready for an LLM context.
    """
    grade = query_db(
        """
        SELECT ag.score, a.max_points, a.assignment_name, c.course_name
        FROM assignment_grades ag
        JOIN assignments a ON ag.assignment_id = a.assignment_id
        JOIN classes cl ON a.class_id = cl.class_id
        JOIN courses c ON cl.course_id = c.course_id
        WHERE ag.student_id = %s AND a.assignment_name LIKE %s
        LIMIT 1
        """,
        (student_id, f"%{assignment_name}%"),
        one=True
    )

    if not grade or grade.get('score') is None:
        return f"No grade found for an assignment matching '{assignment_name}'."

    return f"Your grade for {grade['assignment_name']} ({grade['course_name']}) was {grade['score']} out of {grade['max_points']}."

def list_course_modules(student_id: int, course_name: str) -> str:
    """Lists all modules for a given course.
    Returns a formatted string ready for an LLM context.
    """
    modules = query_db(
        """
        SELECT cm.title, cm.position
        FROM course_modules cm
        JOIN classes cl ON cm.class_id = cl.class_id
        JOIN courses c ON cl.course_id = c.course_id
        JOIN schedule s ON cl.class_id = s.class_id
        WHERE s.student_id = %s AND c.course_name LIKE %s
        ORDER BY cm.position ASC
        """,
        (student_id, f"%{course_name}%")
    )

    if not modules:
        return f"No modules found for a course matching '{course_name}'."

    lines = [f"Modules for {course_name}:"]
    for module in modules:
        lines.append(f"- {module['title']} (Module {module['position']})")
    return "\n".join(lines)

def list_course_files(student_id: int, course_name: str) -> str:
    """Lists all files available for a given course.
    Returns a formatted string ready for an LLM context.
    """
    files = query_db(
        """
        SELECT cf.file_name, cf.folder
        FROM course_files cf
        JOIN classes cl ON cf.class_id = cl.class_id
        JOIN courses c ON cl.course_id = c.course_id
        JOIN schedule s ON cl.class_id = s.class_id
        WHERE s.student_id = %s AND c.course_name LIKE %s
        ORDER BY cf.folder, cf.file_name ASC
        """,
        (student_id, f"%{course_name}%")
    )

    if not files:
        return f"No files found for a course matching '{course_name}'."

    lines = [f"Files for {course_name}:"]
    for file_item in files:
        lines.append(f"- {file_item['file_name']} (in folder: {file_item['folder']})")
    return "\n".join(lines)
