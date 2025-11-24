from flask import Blueprint, redirect, url_for, request, render_template, jsonify, session, flash, current_app
from .db_utils import query_db, execute_db
from .services import rag_utils
from .services.assistant.llama_utils import generate_response as llm_generate
from .services.assistant.prompt_utils import build_prompt
import os
from werkzeug.security import generate_password_hash
from .auth_utils import login_user, logout_user, login_required, get_current_user, verify_login_credentials, role_required

bp = Blueprint("main", __name__)

@bp.route("/")
def index():
    """
    Home route: redirect to dashboard if logged in, otherwise to login.
    """
    if session.get("user_id"):
        return redirect(url_for("main.dashboard"))
    return redirect(url_for("main.login"))


@bp.route("/login", methods=["GET", "POST"])
def login():
    """
    Login page. Uses templates/login-page.html
    Expecting form fields: email, password
    """
    if request.method == "POST":
        email = request.form.get("email", "").strip().lower()
        password = request.form.get("password", "")

        if not email or not password:
            flash("Please provide both email and password.", "warning")
            return render_template("login-page.html")

        user = verify_login_credentials(email, password)
        if not user:
            flash("Invalid email or password.", "danger")
            return render_template("login-page.html")

        login_user(user)
        flash("Logged in successfully.", "success")
        return redirect(url_for("main.dashboard"))

    return render_template("login-page.html", user=get_current_user())


@bp.route("/sign-up", methods=["GET", "POST"])
def sign_up():
    """
    Registration page. Uses templates/sign-up-page.html

    Minimal version:
      - email
      - password
      - optional: student_id field to link to an existing STUDENT row
    """
    if request.method == "POST":
        email = request.form.get("email", "").strip().lower()
        password = request.form.get("password", "")
        confirm = request.form.get("confirm_password", "")
        student_id_raw = request.form.get("student_id", "").strip()  # optional

        if not email or not password or not confirm:
            flash("Please fill in all required fields.", "warning")
            return render_template("sign-up-page.html")

        if password != confirm:
            flash("Passwords do not match.", "danger")
            return render_template("sign-up-page.html")

        # Check if user already exists
        existing = query_db(
            "SELECT id FROM users WHERE email = %s",
            (email,),
            one=True,
        )
        if existing:
            flash("An account with that email already exists.", "danger")
            return render_template("sign-up-page.html")

        password_hash = generate_password_hash(password)

        # Optional student link:
        student_id = None
        if student_id_raw:
            try:
                sid = int(student_id_raw)
            except ValueError:
                sid = None

            if sid is not None:
                student = query_db(
                    "SELECT student_id FROM students WHERE student_id = %s",
                    (sid,),
                    one=True,
                )
                if student:
                    student_id = sid

        # Create user as 'student' role by default
        user_id = execute_db(
            """
            INSERT INTO users (email, password_hash, role, student_id)
            VALUES (%s, %s, 'student', %s)
            """,
            (email, password_hash, student_id),
        )

        # If linked to a student, mark has_account = 1
        if student_id is not None:
            execute_db(
                "UPDATE students SET has_account = 1 WHERE student_id = %s",
                (student_id,),
            )

        # Auto-login after registration
        new_user = query_db(
            "SELECT id, email, role, student_id, professor_id FROM users WHERE id = %s",
            (user_id,),
            one=True,
        )
        login_user(new_user)

        flash("Account created successfully.", "success")
        return redirect(url_for("main.dashboard"))

    return render_template("sign-up-page.html", user=get_current_user())


@bp.route("/logout")
@login_required
def logout():
    logout_user()
    flash("You have been logged out.", "info")
    return redirect(url_for("main.login"))


@bp.route("/dashboard")
@login_required
def dashboard():
    user = get_current_user()
    schedule = []

    if user.get("student_id"):
        schedule = query_db("""
            SELECT
                cl.class_id AS class_id,
                c.course_name,
                c.course_credits,
                cl.class_type
            FROM schedule s
            JOIN classes cl ON s.class_id = cl.class_id
            JOIN courses c ON cl.course_id = c.course_id
            WHERE s.student_id = %s
        """, (user["student_id"],))

    return render_template(
        "dashboard.html",
        user=user,
        schedule=schedule,
    )

@bp.post("/chatbot")
@login_required
def ChatbotEndpoint():
    """
    Main chatbot endpoint.

    - Requires login so we know who is asking.
    - Uses MySQL to pull the student's profile + schedule.
    - Uses RAG (rag_utils) for catalog/weekly/docs context.
    - Logs each exchange into ai_chat_log.
    """
    data = request.get_json(force=True) or {}
    user_message = (data.get("user_message") or "").strip()
    history = data.get("history") or []

    if not user_message:
        return jsonify({"chatbot_response": "Please type a message."}), 200

    # Who is asking?
    user = get_current_user()
    student_id = user.get("student_id") if user else None

    # --------------------------------------------------
    # 1) Build student-specific context from MySQL
    # --------------------------------------------------
    student_context_parts = []

    if student_id:
        # Basic profile: name, major, gpa
        profile = query_db(
            """
            SELECT s.student_first_name, s.student_last_name,
                   s.student_gpa, s.student_total_credits,
                   m.major_name, m.department
            FROM students s
            LEFT JOIN majors m ON s.major_id = m.major_id
            WHERE s.student_id = %s
            """,
            (student_id,),
            one=True,
        )

        if profile:
            name = f"{profile['student_first_name']} {profile['student_last_name']}"
            major = profile.get("major_name") or "Undeclared"
            gpa = profile.get("student_gpa")
            credits = profile.get("student_total_credits")

            student_context_parts.append(f"Student Name: {name}")
            student_context_parts.append(f"Major: {major}")
            if gpa is not None:
                student_context_parts.append(f"GPA: {gpa}")
            if credits is not None:
                student_context_parts.append(f"Total Credits: {credits}")

        # Current course schedule
        schedule_rows = query_db(
            """
            SELECT c.course_name, c.course_credits, cl.class_type
            FROM schedule s
            JOIN classes cl ON s.class_id = cl.class_id
            JOIN courses c ON cl.course_id = c.course_id
            WHERE s.student_id = %s
            """,
            (student_id,),
        )

        if schedule_rows:
            student_context_parts.append("Current Enrolled Courses:")
            for row in schedule_rows:
                student_context_parts.append(
                    f"- {row['course_name']} "
                    f"({row['course_credits']} credits, {row['class_type']})"
                )

    student_context = ""
    if student_context_parts:
        student_context = "Student Context:\n" + "\n".join(student_context_parts)

    # --------------------------------------------------
    # 2) Retrieve RAG context (catalog + weekly + docs)
    # --------------------------------------------------
    hits = rag_utils.retrieve(user_message, k=4)
    rag_context = rag_utils.format_context(hits)

    # Combine student-specific context + RAG context
    combined_context = student_context
    if student_context and rag_context:
        combined_context += "\n\n---\n\n"
    combined_context += rag_context

    # --------------------------------------------------
    # 3) Build LLM prompt and generate reply
    # --------------------------------------------------
    prompt = build_prompt(
        user_message=user_message,
        history=history,
        context=combined_context,
        max_turns=4,
    )

    reply = llm_generate(
        prompt=prompt,
        max_new_tokens=96,
        temperature=0.0,
        do_sample=False,
    )

    # --------------------------------------------------
    # 4) Log to ai_chat_log (if we have a student_id)
    # --------------------------------------------------
    try:
        execute_db(
            """
            INSERT INTO ai_chat_log (student_id, user_message, ai_response)
            VALUES (%s, %s, %s)
            """,
            (student_id, user_message, reply),
        )
    except Exception as e:
        # In dev: you can print/log this; don't break the chatbot on log failure.
        print(f"[ai_chat_log] insert failed: {e}")

    return jsonify({"chatbot_response": reply}), 200

@bp.post("/rag/ingest")
@role_required("admin")
def rag_ingest():
    """
    Admin-only endpoint to trigger RAG ingestion from a folder on the server.

    Expects:
      - JSON: { "folder": "/path/to/docs" }
        or
      - form-data: folder=/path/to/docs
    """
    # Role is already checked by @role_required("admin")

    # Accept either JSON or form
    data = request.get_json(silent=True) or {}
    folder = data.get("folder") or request.form.get("folder")

    if not folder:
        return jsonify({"ok": False, "error": "Missing 'folder' parameter."}), 400

    folder = folder.strip()
    if not os.path.isdir(folder):
        return jsonify({"ok": False, "error": f"Folder does not exist: {folder}"}), 400

    # If your rag_utils uses ingest_folder:
    try:
        docs, chunks = rag_utils.ingest_folder(folder)
    except AttributeError:
        # Fallback if you only have rag_utils.ingest(paths)
        docs, chunks = rag_utils.ingest([folder])

    return jsonify(
        {
            "ok": True,
            "folder": folder,
            "docs": docs,
            "chunks": chunks,
        }
    ), 200

@bp.route("/admin")
@role_required("admin")
def admin_dashboard():
    """
    Admin-only overview page.
    Shows counts of students, users, courses, and recent chat activity.
    """
    # Basic counts
    student_count = query_db("SELECT COUNT(*) AS c FROM students", one=True)["c"]
    user_count = query_db("SELECT COUNT(*) AS c FROM users", one=True)["c"]
    course_count = query_db("SELECT COUNT(*) AS c FROM courses", one=True)["c"]
    class_count = query_db("SELECT COUNT(*) AS c FROM classes", one=True)["c"]

    recent_logs = query_db(
        """
        SELECT l.chat_timestamp, l.user_message, l.ai_response, s.student_first_name, s.student_last_name
        FROM ai_chat_log l
        LEFT JOIN students s ON l.student_id = s.student_id
        ORDER BY l.chat_timestamp DESC
        LIMIT 10
        """
    )

    user = get_current_user()

    return render_template(
        "admin/admin_dashboard.html",
        user=user,
        student_count=student_count,
        user_count=user_count,
        course_count=course_count,
        class_count=class_count,
        recent_logs=recent_logs,
    )

@bp.route("/admin/courses")
@role_required("admin")
def admin_courses():
    """
    Admin-only: view all courses and how many classes/sections exist for each.
    """
    user = get_current_user()

    major_filter = request.args.get("major", "").strip()
    search = request.args.get("q", "").strip()

    params = []
    where_clauses = []

    if major_filter:
        where_clauses.append("m.major_name = %s")
        params.append(major_filter)

    if search:
        where_clauses.append("c.course_name LIKE %s")
        params.append(f"%{search}%")

    where_sql = ""
    if where_clauses:
        where_sql = "WHERE " + " AND ".join(where_clauses)

    sql = f"""
        SELECT
            c.course_id,
            c.course_name,
            c.course_credits,
            m.major_name,
            COUNT(cl.class_id) AS num_classes
        FROM courses c
        LEFT JOIN majors m ON c.major_id = m.major_id
        LEFT JOIN classes cl ON cl.course_id = c.course_id
        {where_sql}
        GROUP BY c.course_id, c.course_name, c.course_credits, m.major_name
        ORDER BY c.course_name
    """

    courses = query_db(sql, tuple(params))

    # For a future dropdown filter of majors:
    majors = query_db(
        "SELECT DISTINCT major_name FROM majors ORDER BY major_name"
    )

    return render_template(
        "admin/courses.html",
        user=user,
        courses=courses,
        majors=majors,
        major_filter=major_filter,
        search=search,
    )

@bp.route("/admin/users")
@role_required("admin")
def admin_users():
    """
    Admin-only: view all users, with simple filters.
    """
    user = get_current_user()

    role_filter = request.args.get("role", "").strip().lower()
    search = request.args.get("q", "").strip()

    params = []
    where_clauses = []

    if role_filter in ("student", "instructor", "admin"):
        where_clauses.append("u.role = %s")
        params.append(role_filter)

    if search:
        where_clauses.append("u.email LIKE %s")
        params.append(f"%{search}%")

    where_sql = ""
    if where_clauses:
        where_sql = "WHERE " + " AND ".join(where_clauses)

    sql = f"""
        SELECT
            u.id,
            u.email,
            u.role,
            u.student_id,
            u.professor_id,
            u.created_at,
            s.student_first_name,
            s.student_last_name,
            p.professor_first_name,
            p.professor_last_name
        FROM users u
        LEFT JOIN students s ON u.student_id = s.student_id
        LEFT JOIN professors p ON u.professor_id = p.professor_id
        {where_sql}
        ORDER BY u.created_at DESC
    """

    users = query_db(sql, tuple(params))

    return render_template(
        "admin/users.html",
        user=user,
        users=users,
        role_filter=role_filter,
        search=search,
    )

@bp.route("/admin/rag")
@role_required("admin")
def admin_rag():
    """
    Admin-only: simple UI to trigger RAG ingestion and see where the index lives.
    """
    user = get_current_user()

    # Where the index is stored (mirrors your __init__.py logic)
    index_dir = os.getenv("CANDACE_INDEX_DIR") or os.path.join(
        current_app.root_path, "vector_store"
    )

    return render_template(
        "admin/rag_tools.html",
        user=user,
        index_dir=index_dir,
    )

@bp.route("/admin/chat-logs")
@role_required("admin")
def admin_chat_logs():
    """
    Admin-only: view recent chatbot logs with simple filters.
    """
    user = get_current_user()

    student_id = request.args.get("student_id", "").strip()
    search = request.args.get("q", "").strip()

    params = []
    where_clauses = []

    if student_id:
        where_clauses.append("l.student_id = %s")
        params.append(student_id)

    if search:
        where_clauses.append("l.user_message LIKE %s")
        params.append(f"%{search}%")

    where_sql = "WHERE " + " AND ".join(where_clauses) if where_clauses else ""

    sql = f"""
        SELECT
            l.chat_timestamp,
            l.user_message,
            l.ai_response,
            l.student_id,
            s.student_first_name,
            s.student_last_name
        FROM ai_chat_log l
        LEFT JOIN students s ON l.student_id = s.student_id
        {where_sql}
        ORDER BY l.chat_timestamp DESC
        LIMIT 100
    """

    logs = query_db(sql, tuple(params))

    return render_template(
        "admin/chat_logs.html",
        user=user,
        logs=logs,
        student_id=student_id,
        search=search,
    )

@bp.route("/admin/students")
@role_required("admin")
def admin_students():
    """
    Admin-only: view all students and their details (name, major, GPA, credits).
    """
    user = get_current_user()

    search = request.args.get("q", "").strip()
    major_filter = request.args.get("major", "").strip()

    params = []
    where_clauses = []

    if search:
        where_clauses.append("(s.student_first_name LIKE %s OR s.student_last_name LIKE %s)")
        params.extend([f"%{search}%", f"%{search}%"])

    if major_filter:
        where_clauses.append("m.major_name = %s")
        params.append(major_filter)

    where_sql = "WHERE " + " AND ".join(where_clauses) if where_clauses else ""

    sql = f"""
        SELECT
            s.student_id,
            s.student_first_name,
            s.student_last_name,
            s.student_gpa,
            s.student_total_credits,
            s.has_account,
            m.major_name,
            m.department
        FROM students s
        LEFT JOIN majors m ON s.major_id = m.major_id
        {where_sql}
        ORDER BY s.student_last_name, s.student_first_name
    """

    students = query_db(sql, tuple(params))

    majors = query_db("SELECT major_name FROM majors ORDER BY major_name")

    return render_template(
        "admin/students.html",
        user=user,
        students=students,
        majors=majors,
        search=search,
        major_filter=major_filter,
    )

@bp.route("/admin/classes")
@role_required("admin")
def admin_classes():
    """
    Admin-only: view all class sections (CLASS table), including course + professor.
    """
    user = get_current_user()

    search = request.args.get("q", "").strip()

    params = []
    where_clause = ""

    if search:
        where_clause = "WHERE c.course_name LIKE %s OR p.professor_last_name LIKE %s"
        params = [f"%{search}%", f"%{search}%"]

    sql = f"""
        SELECT
            cl.class_id,
            cl.class_type,
            c.course_name,
            c.course_credits,
            p.professor_first_name,
            p.professor_last_name,
            m.major_name
        FROM classes cl
        JOIN courses c ON cl.course_id = c.course_id
        LEFT JOIN majors m ON c.major_id = m.major_id
        JOIN professors p ON cl.professor_id = p.professor_id
        {where_clause}
        ORDER BY c.course_name, cl.class_id
    """

    classes = query_db(sql, tuple(params))

    return render_template(
        "admin/classes.html",
        user=user,
        classes=classes,
        search=search,
    )

@bp.route("/account")
@login_required
def account():
    user = get_current_user()

    student = None
    if user.get("student_id"):
        student = query_db("""
            SELECT s.*, m.major_name, m.department
            FROM students s
            LEFT JOIN majors m ON s.major_id = m.major_id
            WHERE s.student_id = %s
        """, (user["student_id"],), one=True)

    return render_template("student/account.html", user=user, student=student)

@bp.route("/courses")
@login_required
def courses():
    user = get_current_user()

    current_courses = []
    if user.get("student_id"):
        current_courses = query_db("""
            SELECT
                cl.class_id AS class_id,
                c.course_name,
                c.course_credits,
                cl.class_type
            FROM schedule s
            JOIN classes cl ON s.class_id = cl.class_id
            JOIN courses c ON cl.course_id = c.course_id
            WHERE s.student_id = %s
        """, (user["student_id"],))

    completed_courses = []
    if user.get("student_id"):
        completed_courses = query_db("""
            SELECT DISTINCT
                cl.class_id AS class_id,
                c.course_name,
                c.course_credits
            FROM work_load w
            JOIN assignments a ON w.assignment_id = a.assignment_id
            JOIN classes cl ON a.class_id = cl.class_id
            JOIN courses c ON cl.course_id = c.course_id
            WHERE w.student_id = %s
        """, (user["student_id"],))

    return render_template(
        "student/courses.html",
        user=user,
        current=current_courses,
        completed=completed_courses,
    )

@bp.route("/course/<int:class_id>")
@login_required
def course_shell(class_id):
    # Home / Modules tab
    user, course = _get_course_context_or_redirect(class_id)
    if not course:
        return redirect(url_for("main.courses"))

    # 1) Fetch modules for this class
    module_rows = query_db("""
        SELECT id, title, is_hidden
        FROM course_modules
        WHERE class_id = %s
        ORDER BY position
    """, (class_id,))

    # 2) Fetch items for those modules
    module_ids = [m["id"] for m in module_rows]
    items_by_module = {mid: [] for mid in module_ids}

    if module_ids:
        placeholders = ",".join(["%s"] * len(module_ids))
        item_rows = query_db(f"""
            SELECT module_id, title
            FROM course_module_items
            WHERE module_id IN ({placeholders})
            ORDER BY position
        """, module_ids)

        for row in item_rows:
            items_by_module[row["module_id"]].append(row["title"])

    # 3) Transform into structure expected by template
    modules = [
        {
            "title": m["title"],
            "hidden": bool(m["is_hidden"]),
            "items": items_by_module.get(m["id"], []),
        }
        for m in module_rows
    ]

    return render_template(
        "student/course_modules.html",
        user=user,
        course=course,
        modules=modules,
    )

@bp.route("/course/<int:class_id>/announcements")
@login_required
def course_announcements(class_id):
    user, course = _get_course_context_or_redirect(class_id)
    if not course:
        return redirect(url_for("main.courses"))

    announcements = query_db("""
        SELECT
            ca.title,
            ca.body,
            ca.posted_at,
            CONCAT(p.professor_first_name, ' ', p.professor_last_name) AS author
        FROM course_announcements ca
        LEFT JOIN professors p
            ON ca.author_professor_id = p.professor_id
        WHERE ca.class_id = %s
        ORDER BY ca.posted_at DESC
    """, (class_id,))

    return render_template(
        "student/course_announcements.html",
        user=user,
        course=course,
        announcements=announcements,
    )

@bp.route("/course/<int:class_id>/assignments")
@login_required
def course_assignments(class_id):
    user, course = _get_course_context_or_redirect(class_id)
    if not course:
        return redirect(url_for("main.courses"))

    student_id = user.get("student_id") if user["role"] == "student" else None

    if student_id:
        assignments = query_db("""
            SELECT
                a.assignment_id,
                a.assignment_name AS name,
                a.assignment_type AS type,
                a.due_at,
                a.max_points,
                ag.status,
                ag.score
            FROM assignments a
            JOIN work_load w
                ON w.assignment_id = a.assignment_id
               AND w.student_id = %s
            LEFT JOIN assignment_grades ag
                ON ag.assignment_id = a.assignment_id
               AND ag.student_id = %s
            WHERE a.class_id = %s
            ORDER BY a.due_at IS NULL, a.due_at
        """, (student_id, student_id, class_id))
    else:
        # Instructor/admin view: just show assignments
        assignments = query_db("""
            SELECT
                a.assignment_id,
                a.assignment_name AS name,
                a.assignment_type AS type,
                a.due_at,
                a.max_points,
                NULL AS status,
                NULL AS score
            FROM assignments a
            WHERE a.class_id = %s
            ORDER BY a.due_at IS NULL, a.due_at
        """, (class_id,))

    # Format for template
    def format_due(dt):
        return dt.strftime("%b %-d, %Y · %I:%M %p") if dt else "No due date"

    formatted = []
    for a in assignments:
        due_str = format_due(a["due_at"]) if a["due_at"] else "No due date"
        status = a["status"] or ("Not submitted" if student_id else "")
        score_display = None
        if a["score"] is not None:
            score_display = f"{a['score']:.0f} / {a['max_points']}"
        formatted.append(
            {
                "name": a["name"],
                "type": a["type"],
                "due": due_str,
                "points": a["max_points"],
                "status": status,
                "score": score_display,
            }
        )

    return render_template(
        "student/course_assignments.html",
        user=user,
        course=course,
        assignments=formatted,
    )

@bp.route("/course/<int:class_id>/quizzes")
@login_required
def course_quizzes(class_id):
    user, course = _get_course_context_or_redirect(class_id)
    if not course:
        return redirect(url_for("main.courses"))

    student_id = user.get("student_id") if user["role"] == "student" else None

    if student_id:
        quizzes = query_db("""
            SELECT
                a.assignment_name AS name,
                a.due_at,
                a.max_points,
                ag.status,
                ag.score
            FROM assignments a
            JOIN work_load w
                ON w.assignment_id = a.assignment_id
               AND w.student_id = %s
            LEFT JOIN assignment_grades ag
                ON ag.assignment_id = a.assignment_id
               AND ag.student_id = %s
            WHERE a.class_id = %s
              AND a.assignment_type = 'Quiz'
            ORDER BY a.due_at IS NULL, a.due_at
        """, (student_id, student_id, class_id))
    else:
        quizzes = query_db("""
            SELECT
                a.assignment_name AS name,
                a.due_at,
                a.max_points,
                NULL AS status,
                NULL AS score
            FROM assignments a
            WHERE a.class_id = %s
              AND a.assignment_type = 'Quiz'
            ORDER BY a.due_at IS NULL, a.due_at
        """, (class_id,))

    def format_due(dt):
        return dt.strftime("%b %-d, %Y · %I:%M %p") if dt else "No due date"

    formatted = []
    for q in quizzes:
        formatted.append(
            {
                "name": q["name"],
                "due": format_due(q["due_at"]),
                "points": q["max_points"],
                "status": q["status"] or "Not taken",
            }
        )

    return render_template(
        "student/course_quizzes.html",
        user=user,
        course=course,
        quizzes=formatted,
    )

@bp.route("/course/<int:class_id>/cengage")
@login_required
def course_cengage(class_id):
    user, course = _get_course_context_or_redirect(class_id)
    if not course:
        return redirect(url_for("main.courses"))

    cengage_links = query_db("""
        SELECT name, status
        FROM course_cengage_links
        WHERE class_id = %s
        ORDER BY id
    """, (class_id,))

    return render_template(
        "student/course_cengage.html",
        user=user,
        course=course,
        cengage_links=cengage_links,
    )

@bp.route("/course/<int:class_id>/grades")
@login_required
def course_grades(class_id):
    user, course = _get_course_context_or_redirect(class_id)
    if not course:
        return redirect(url_for("main.courses"))

    student_id = user.get("student_id")
    if user["role"] != "student" or not student_id:
        flash("Grades are only available for student accounts.", "error")
        return redirect(url_for("main.course_assignments", class_id=class_id))

    rows = query_db("""
        SELECT
            a.assignment_name AS name,
            a.assignment_type AS type,
            a.max_points,
            ag.score
        FROM assignments a
        JOIN work_load w
            ON w.assignment_id = a.assignment_id
           AND w.student_id = %s
        LEFT JOIN assignment_grades ag
            ON ag.assignment_id = a.assignment_id
           AND ag.student_id = %s
        WHERE a.class_id = %s
        ORDER BY a.due_at IS NULL, a.due_at
    """, (student_id, student_id, class_id))

    grade_items = []
    earned = 0.0
    possible = 0.0

    for r in rows:
        pts = r["max_points"] or 0
        score = r["score"]
        grade_items.append(
            {
                "name": r["name"],
                "type": r["type"],
                "score": score,
                "points": pts,
            }
        )
        possible += pts
        if score is not None:
            earned += score

    if possible > 0:
        pct = earned / possible * 100
        current_grade = f"{pct:.1f}%"
        total_points = f"{earned:.0f} / {possible:.0f}"
    else:
        current_grade = "—"
        total_points = "—"

    return render_template(
        "student/course_grades.html",
        user=user,
        course=course,
        grade_items=grade_items,
        current_grade=current_grade,
        total_points=total_points,
    )

@bp.route("/course/<int:class_id>/people")
@login_required
def course_people(class_id):
    user, course = _get_course_context_or_redirect(class_id)
    if not course:
        return redirect(url_for("main.courses"))

    # Fetch instructor
    instructor = query_db("""
        SELECT p.professor_first_name AS first, p.professor_last_name AS last, 
               u.email
        FROM classes c
        JOIN professors p ON c.professor_id = p.professor_id
        LEFT JOIN users u ON u.professor_id = p.professor_id
        WHERE c.class_id = %s
    """, (class_id,), one=True)

    # Fetch roster
    students = query_db("""
        SELECT s.student_first_name AS first, s.student_last_name AS last,
               u.email
        FROM schedule sc
        JOIN students s ON sc.student_id = s.student_id
        LEFT JOIN users u ON u.student_id = s.student_id
        WHERE sc.class_id = %s
    """, (class_id,))
    
    return render_template(
        "student/course_people.html",
        user=user,
        course=course,
        instructor=instructor,
        students=students,
    )

@bp.route("/course/<int:class_id>/files")
@login_required
def course_files(class_id):
    user, course = _get_course_context_or_redirect(class_id)
    if not course:
        return redirect(url_for("main.courses"))

    files = query_db("""
        SELECT file_name AS name,
               folder,
               CONCAT(file_size_kb, ' KB') AS size
        FROM course_files
        WHERE class_id = %s
        ORDER BY folder, file_name
    """, (class_id,))

    return render_template(
        "student/course_files.html",
        user=user,
        course=course,
        files=files,
    )

@bp.route("/course/<int:class_id>/pages")
@login_required
def course_pages(class_id):
    user, course = _get_course_context_or_redirect(class_id)
    if not course:
        return redirect(url_for("main.courses"))

    pages = query_db("""
        SELECT title, published
        FROM course_pages
        WHERE class_id = %s
        ORDER BY title
    """, (class_id,))

    return render_template(
        "student/course_pages.html",
        user=user,
        course=course,
        pages=pages,
    )

@bp.route("/course/<int:class_id>/syllabus")
@login_required
def course_syllabus(class_id):
    user, course = _get_course_context_or_redirect(class_id)
    if not course:
        return redirect(url_for("main.courses"))

    row = query_db("""
        SELECT description, learning_outcomes, grading_policy
        FROM course_syllabus
        WHERE class_id = %s
    """, (class_id,), one=True)

    if row:
        course_description = row["description"]
        learning_outcomes = [line.strip() for line in row["learning_outcomes"].split("\n") if line.strip()]
        grading_policy = [line.strip() for line in row["grading_policy"].split("\n") if line.strip()]
    else:
        course_description = "Syllabus for this course has not been added yet."
        learning_outcomes = []
        grading_policy = []

    return render_template(
        "student/course_syllabus.html",
        user=user,
        course=course,
        course_description=course_description,
        learning_outcomes=learning_outcomes,
        grading_policy=grading_policy,
    )

@bp.route("/course/<int:class_id>/analytics")
@login_required
def course_analytics(class_id):
    user, course = _get_course_context_or_redirect(class_id)
    if not course:
        return redirect(url_for("main.courses"))

    # Average grade across all students with scores
    avg_row = query_db("""
        SELECT AVG(ag.score / a.max_points) * 100 AS avg_pct
        FROM assignment_grades ag
        JOIN assignments a ON ag.assignment_id = a.assignment_id
        WHERE a.class_id = %s
          AND ag.score IS NOT NULL
    """, (class_id,), one=True)

    average_grade = f"{avg_row['avg_pct']:.1f}%" if avg_row and avg_row["avg_pct"] is not None else "—"

    # Total/completed assignments for current student (if student)
    completed = total = None
    if user["role"] == "student" and user.get("student_id"):
        row = query_db("""
            SELECT
                COUNT(*) AS total,
                SUM(CASE WHEN ag.status IN ('submitted','graded','late') THEN 1 ELSE 0 END) AS completed
            FROM assignments a
            JOIN work_load w
                ON w.assignment_id = a.assignment_id
               AND w.student_id = %s
            LEFT JOIN assignment_grades ag
                ON ag.assignment_id = a.assignment_id
               AND ag.student_id = %s
            WHERE a.class_id = %s
        """, (user["student_id"], user["student_id"], class_id), one=True)
        total = row["total"]
        completed = row["completed"]

    analytics = {
        "average_grade": average_grade,
        "completed_assignments": completed,
        "total_assignments": total,
        # You can later add more stats (on-time rate, last_login, etc.)
    }

    return render_template(
        "student/course_analytics.html",
        user=user,
        course=course,
        analytics=analytics,
    )

@bp.route("/calendar")
@login_required
def calendar():
    return render_template("student/calendar.html", user=get_current_user())

@bp.route("/inbox")
@login_required
def inbox():
    return render_template("student/inbox.html", user=get_current_user())

@bp.route("/history")
@login_required
def history():
    user = get_current_user()

    logs = []
    if user.get("student_id"):
        logs = query_db("""
            SELECT *
            FROM ai_chat_log
            WHERE student_id = %s
            ORDER BY chat_timestamp DESC
            LIMIT 100
        """, (user["student_id"],))

    return render_template("student/history.html", logs=logs, user=user)

def _get_course_context_or_redirect(class_id):
    """Fetch course + user; ensure student is enrolled."""
    user = get_current_user()

    course_row = query_db("""
        SELECT
            cl.class_id,
            cl.class_type,
            c.course_id,
            c.course_name,
            c.course_credits
        FROM classes cl
        JOIN courses c ON cl.course_id = c.course_id
        WHERE cl.class_id = %s
    """, (class_id,), one=True)

    if not course_row:
        flash("Course not found.", "error")
        return None, None

    # Optional safety: student must be enrolled
    if user["role"] == "student" and user.get("student_id"):
        enrolled = query_db("""
            SELECT 1
            FROM schedule
            WHERE student_id = %s AND class_id = %s
        """, (user["student_id"], class_id), one=True)

        if not enrolled:
            flash("You are not enrolled in this course.", "error")
            return None, None

    return user, course_row
