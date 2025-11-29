from flask import Blueprint, redirect, url_for, request, render_template, jsonify, session, flash, current_app
from .db_utils import query_db, execute_db
from .services import rag_utils
from .services.assistant.llama_utils import generate_response as llm_generate
from .services.assistant.prompt_utils import build_prompt
import os
from werkzeug.security import generate_password_hash
from .auth_utils import login_user, logout_user, login_required, get_current_user, verify_login_credentials, role_required
from datetime import datetime
import re

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
    - Uses MySQL to pull the student's profile + schedule (+ optional assignments/grades).
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

    profile = None
    schedule_rows = []

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

        # If we have a student_id from users table but
        # no matching row in students → account not matched.
        if not profile:
            return jsonify({
                "chatbot_response": (
                    "Your account is not matched to any student record in the system. "
                    "Please contact your instructor or support so they can fix your enrollment."
                )
            }), 200

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
    # 1.5) Course-specific assignments and grades
    #      (ENG 101 / ENG-101 etc.)
    # --------------------------------------------------
    assignment_block = ""
    grade_block = ""

    # Detect intent
    assignment_question = bool(
        re.search(r"\bassignments?\b|\bhomework\b|\bessay\b", user_message, re.IGNORECASE)
    )
    grade_question = bool(
        re.search(r"\bgrade\b|\baverage\b|\bpercent\b|\bscore\b", user_message, re.IGNORECASE)
    )

    # Try to detect a course code like ENG 101 / ENG-101
    course_code_hint = detect_course_code(user_message)

    # --- Assignments for a specific course ---
    if assignment_question and student_id and course_code_hint:
        like_pattern = f"{course_code_hint}%"
        assignment_rows = query_db(
            """
            SELECT
                c.course_name,
                a.assignment_name,
                a.assignment_type,
                a.due_at,
                a.max_points,
                a.assignment_score_weight,
                a.description
            FROM schedule s
            JOIN classes cl    ON s.class_id = cl.class_id
            JOIN courses c     ON cl.course_id = c.course_id
            JOIN assignments a ON a.class_id = cl.class_id
            WHERE s.student_id = %s
              AND c.course_name LIKE %s
            ORDER BY a.due_at, a.assignment_name
            """,
            (student_id, like_pattern),
        )

        if assignment_rows:
            lines = []
            course_label = assignment_rows[0]["course_name"]
            lines.append(f"Assignments for {course_label}:")
            for row in assignment_rows:
                line = f"- {row['assignment_name']} [{row['assignment_type']}]"
                if row.get("due_at"):
                    line += f" (Due: {row['due_at']})"
                line += f" | Max Points: {row['max_points']}"
                if row.get("assignment_score_weight") is not None:
                    line += f" | Weight: {row['assignment_score_weight']}"
                lines.append(line)
            assignment_block = "\n".join(lines)
        else:
            # They clearly asked about assignments for a parsed course code,
            # and DB has none → answer directly instead of hallucinating.
            return jsonify({
                "chatbot_response": (
                    f"I checked the system, but I couldn't find any assignments "
                    f"for {course_code_hint} in your current enrollment. "
                    "It might be that assignments haven't been entered yet, or "
                    "they're only visible directly in Canvas."
                )
            }), 200

    # --- Grade summary for a specific course ---
    if grade_question and student_id and course_code_hint:
        summary = get_course_grade_summary(student_id, course_code_hint)
        if summary is None:
            return jsonify({
                "chatbot_response": (
                    f"I checked your record but couldn't find any graded assignments "
                    f"for {course_code_hint} linked to your enrollment. "
                    "It might be that grades haven't been entered yet or the course "
                    "is tracked only in Canvas."
                )
            }), 200

        lines = []
        cname = summary["course_name"]
        lines.append(f"Grade Summary for {cname}:")

        if summary["current_percent"] is not None:
            lines.append(
                f"- Current weighted average: {summary['current_percent']:.1f}% "
                f"(covering {summary['covered_weight']*100:.0f}% of the total grade)."
            )
        else:
            lines.append(
                "- There are no graded, weighted assignments yet, so a current average "
                "cannot be calculated."
            )

        if summary["assignments"]:
            lines.append("Assignments and scores:")
            for a in summary["assignments"]:
                line = f"  • {a['name']} [{a['type']}]"
                if a["due_at"]:
                    line += f" (Due: {a['due_at']})"
                line += f" | Max: {a['max_points']}"
                if a["score"] is not None:
                    line += f" | Score: {a['score']} (status: {a['status']})"
                else:
                    line += f" | Score: — (status: {a['status']})"
                if a["weight"] is not None:
                    line += f" | Weight: {a['weight']}"
                lines.append(line)

        grade_block = "\n".join(lines)

    # Attach blocks to student_context if present
    extra_blocks = []
    if assignment_block:
        extra_blocks.append(assignment_block)
    if grade_block:
        extra_blocks.append(grade_block)

    if extra_blocks:
        if student_context:
            student_context += "\n\n"
        student_context += "\n\n".join(extra_blocks)

    # --------------------------------------------------
    # 2) Retrieve RAG context (catalog + weekly + docs)
    #    and FILTER it so student-specific docs only
    #    show for the logged-in student.
    # --------------------------------------------------
    raw_hits = rag_utils.retrieve(user_message, k=8)  # a bit more context than 4

    def _get_hit_text(hit):
        # Be robust to different rag_utils shapes
        if isinstance(hit, dict):
            return (
                hit.get("chunk")
                or hit.get("text")
                or hit.get("content")
                or ""
            )
        return str(hit)

    filtered_hits = []
    if raw_hits:
        for h in raw_hits:
            text = _get_hit_text(h)

            # If chunk clearly has a STUDENT_ID marker, only keep if it matches.
            m = re.search(r"STUDENT_ID:\s*(\d+)", text)
            if m:
                try:
                    sid_in_doc = int(m.group(1))
                except ValueError:
                    continue
                if student_id and sid_in_doc == student_id:
                    filtered_hits.append(h)
                # if it's another student's doc, skip it
                continue

            # Otherwise treat as global (catalog, weekly, pages, etc.) → keep
            filtered_hits.append(h)

    rag_context = rag_utils.format_context(filtered_hits)

    # --------------------------------------------------
    # 2.5) Handle "no data" case:
    #      no student-specific context AND no RAG hits
    # --------------------------------------------------
    if not student_context_parts and not filtered_hits:
        return jsonify({
            "chatbot_response": (
                "I checked your account and the available course documents, "
                "but I couldn't find any information related to your question. "
                "You may need to check your course syllabus or Canvas directly "
                "for more details, or try asking in a different way."
            )
        }), 200

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
        max_turns=6,
    )

    reply = llm_generate(
        prompt=prompt,
        max_new_tokens=192,
        temperature=0.2,
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
        print(f"[ai_chat_log] insert failed: {e}")

    return jsonify({"chatbot_response": reply}), 200

def get_course_grade_summary(student_id: int, course_code_hint: str):
    """
    Compute a grade summary for one course for a given student.

    course_code_hint: something like "ENG 101" or "ENG-101" (we'll use LIKE).
    Returns dict or None if no matching enrollment/assignments.
    """

    like_pattern = f"{course_code_hint}%"  # matches "ENG 101 - English Composition I"

    rows = query_db(
        """
        SELECT
            c.course_name,
            a.assignment_name,
            a.assignment_type,
            a.assignment_score_weight,
            a.max_points,
            a.due_at,
            ag.score,
            ag.status
        FROM schedule s
        JOIN classes cl      ON s.class_id = cl.class_id
        JOIN courses c       ON cl.course_id = c.course_id
        JOIN assignments a   ON a.class_id = cl.class_id
        LEFT JOIN assignment_grades ag
               ON ag.assignment_id = a.assignment_id
              AND ag.student_id = s.student_id
        WHERE s.student_id = %s
          AND c.course_name LIKE %s
        ORDER BY a.due_at, a.assignment_name
        """,
        (student_id, like_pattern),
    )

    if not rows:
        return None

    course_name = rows[0]["course_name"]

    # Compute weighted average from assignments that have a score + weight.
    total_weight = 0.0
    weighted_sum = 0.0
    assignments = []

    for r in rows:
        w = float(r["assignment_score_weight"] or 0.0)
        max_pts = float(r["max_points"] or 0.0)
        score = r["score"]
        status = r["status"] or "not_assigned"

        # Build a per-assignment summary line
        assignments.append({
            "name": r["assignment_name"],
            "type": r["assignment_type"],
            "due_at": r["due_at"],
            "max_points": r["max_points"],
            "weight": r["assignment_score_weight"],
            "score": r["score"],
            "status": status,
        })

        # Only count graded/submitted work with weight and max_points
        if (
            score is not None
            and max_pts > 0
            and w > 0
            and status in ("submitted", "graded", "late")
        ):
            pct = float(score) / max_pts  # fraction
            weighted_sum += pct * w
            total_weight += w

    current_percent = None
    if total_weight > 0:
        current_percent = (weighted_sum / total_weight) * 100.0

    remaining_weight = max(0.0, 1.0 - total_weight)

    return {
        "course_name": course_name,
        "assignments": assignments,
        "current_percent": current_percent,   # e.g. 88.5
        "covered_weight": total_weight,       # e.g. 0.60 (60% of grade)
        "remaining_weight": remaining_weight, # e.g. 0.40
    }

def detect_course_code(msg: str) -> str | None:
    """
    Try to detect a course code like ENG 101 or ENG-101 in the message.
    Returns a normalized 'ENG 101' or None.
    """
    m = re.search(r"\b([A-Z]{2,4})[-\s]?(\d{3})\b", msg.upper())
    if not m:
        return None
    return f"{m.group(1)} {m.group(2)}"

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
    completed_courses = []

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

        # 🔑 NEW: don’t show the same class as both current *and* completed
        current_ids = {c["class_id"] for c in current_courses}
        completed_courses = [
            c for c in completed_courses
            if c["class_id"] not in current_ids
        ]

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
            LEFT JOIN assignment_grades ag
                ON ag.assignment_id = a.assignment_id
            AND ag.student_id = %s
            WHERE a.class_id = %s
            ORDER BY a.due_at IS NULL, a.due_at
        """, (student_id, class_id))
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
        if not dt:
            return "No due date"
        return dt.strftime("%b %d, %Y · %I:%M %p")

    from datetime import datetime
    now = datetime.utcnow()  # MySQL DATETIME is stored in UTC

    formatted = []
    for a in assignments:
        raw_due = a["due_at"]

        # Determine bucket
        if raw_due:
            due_str = format_due(raw_due)
            is_past = raw_due < now
            bucket = "past" if is_past else "upcoming"
        else:
            due_str = "No due date"
            bucket = "undated"

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
                "bucket": bucket,  # 🔑 ADD THIS
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
    from datetime import datetime

    user, course = _get_course_context_or_redirect(class_id)
    if not course:
        return redirect(url_for("main.courses"))

    student_id = user.get("student_id")
    if user["role"] != "student" or not student_id:
        flash("Grades are only available for student accounts.", "error")
        return redirect(url_for("main.course_assignments", class_id=class_id))

    rows = query_db("""
        SELECT
            a.assignment_id,
            a.assignment_name AS name,
            a.assignment_type AS type,
            a.due_at,
            a.max_points,
            ag.score,
            ag.submitted_at,
            ag.status
        FROM assignments a
        LEFT JOIN assignment_grades ag
            ON ag.assignment_id = a.assignment_id
        AND ag.student_id = %s
        WHERE a.class_id = %s
        ORDER BY a.due_at IS NULL, a.due_at
    """, (student_id, class_id))

    # ================================
    # Format + Compute Assignment Rows
    # ================================
    grade_items = []

    def format_ts(ts):
        if not ts:
            return "—"
        return ts.strftime("%b %d at %I:%M%p")

    now = datetime.utcnow()

    for r in rows:
        # Determine status (missing, graded, not submitted)
        if r["score"] is None:
            if r["due_at"] and r["due_at"] < now:
                status = "missing"
            else:
                status = "not submitted"
        else:
            status = "graded"

        grade_items.append({
            "assignment_id": r["assignment_id"],
            "name": r["name"],
            "type": r["type"],
            "due": format_ts(r["due_at"]),
            "submitted": format_ts(r["submitted_at"]),
            "status": status,
            "score": r["score"],
            "points": r["max_points"],
        })

    # ======================================
    # GROUPING (Canvas-style grade categories)
    # ======================================

    # Auto-build groups by assignment_type
    groups = {}  # { "homework": {earned, possible}, ... }

    for g in grade_items:
        grp = g["type"] or "Other"
        if grp not in groups:
            groups[grp] = {"earned": 0.0, "possible": 0.0}

        groups[grp]["possible"] += g["points"]
        if g["score"] is not None:
            groups[grp]["earned"] += g["score"]

    # Convert to list for the template
    grade_groups = []
    overall_earned = 0.0
    overall_possible = 0.0

    for grp_name, totals in groups.items():
        earned = totals["earned"]
        possible = totals["possible"]
        grade_groups.append({
            "name": grp_name,
            "earned": earned,
            "possible": possible,
        })
        overall_earned += earned
        overall_possible += possible

    # ============================
    # Overall course grade summary
    # ============================
    if overall_possible > 0:
        pct = overall_earned / overall_possible * 100
        current_grade = f"{pct:.1f}%"
        total_points = f"{overall_earned:.0f} / {overall_possible:.0f}"
    else:
        current_grade = "—"
        total_points = "—"

    return render_template(
        "student/course_grades.html",
        user=user,
        course=course,
        grade_items=grade_items,
        grade_groups=grade_groups,
        current_grade=current_grade,
        total_points=total_points,
        overall_earned=overall_earned,
        overall_possible=overall_possible,
    )

@bp.route("/course/<int:class_id>/people")
@login_required
def course_people(class_id):
    user, course = _get_course_context_or_redirect(class_id)
    if not course:
        return redirect(url_for("main.courses"))

    # Build a friendly section name like "CST 161 – Computer Programming Fundamentals (Class 1004)"
    section_name = f"{course['course_name']} (Class {class_id})"

    # Fetch instructor
    instructor = query_db(
        """
        SELECT 
            p.professor_first_name AS first,
            p.professor_last_name AS last,
            u.email
        FROM classes c
        JOIN professors p ON c.professor_id = p.professor_id
        LEFT JOIN users u ON u.professor_id = p.professor_id
        WHERE c.class_id = %s
        """,
        (class_id,),
        one=True,
    )

    # Fetch roster
    students = query_db(
        """
        SELECT 
            s.student_first_name AS first,
            s.student_last_name AS last,
            u.email
        FROM schedule sc
        JOIN students s ON sc.student_id = s.student_id
        LEFT JOIN users u ON u.student_id = s.student_id
        WHERE sc.class_id = %s
        ORDER BY s.student_last_name, s.student_first_name
        """,
        (class_id,),
    )

    return render_template(
        "student/course_people.html",
        user=user,
        course=course,
        section_name=section_name,
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

def get_course_modules_for_class(class_id):
    rows = query_db(
        """
        SELECT
            m.id          AS module_id,
            m.title       AS module_title,
            m.position    AS module_position,
            m.is_hidden   AS module_hidden,

            mi.id         AS item_id,
            mi.item_type  AS item_type,
            mi.title      AS item_title,
            mi.assignment_id,

            a.due_at      AS assignment_due_at,
            a.assignment_name AS assignment_name
        FROM course_modules m
        LEFT JOIN course_module_items mi
               ON mi.module_id = m.id
        LEFT JOIN assignments a
               ON a.assignment_id = mi.assignment_id
        WHERE m.class_id = %s
        ORDER BY m.position ASC, mi.position ASC, mi.id ASC
        """,
        (class_id,),
    )

    modules = []
    current = None
    current_id = None

    for row in rows:
        mid = row["module_id"]
        if current_id != mid:
            # start new module
            current = {
                "id": mid,
                "title": row["module_title"],
                "position": row["module_position"],
                "hidden": bool(row["module_hidden"]),
                "items": [],
            }
            modules.append(current)
            current_id = mid

        if row["item_id"] is None:
            # module with no items yet
            continue

        due_at = row["assignment_due_at"]
        if due_at is not None:
            # format as a nice string for the template
            due_display = due_at.strftime("%b %-d, %Y")  # e.g. "Sep 19, 2025"
        else:
            due_display = None

        item = {
            "type": row["item_type"],  # 'assignment', 'quiz', 'page', etc.
            "title": row["assignment_name"] or row["item_title"],
            "assignment_id": row["assignment_id"],
            "due_display": due_display,
        }
        current["items"].append(item)

    return modules

@bp.route("/courses/<int:class_id>/modules")
def course_modules(class_id):
    course = get_course_info(class_id)  # whatever you already use
    modules = get_course_modules_for_class(class_id)
    return render_template(
        "student/course_modules.html",
        course=course,
        modules=modules,
    )
