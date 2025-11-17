from flask import Blueprint, redirect, url_for, request, render_template, jsonify, session
from . import db_utils
from . import auth_utils as auth
from .services.assistant.llama_utils import generate_response as llm_generate
from .services.assistant.prompt_utils import build_prompt
from .services import rag_utils
from .services import rag_router

bp = Blueprint("main", __name__)

@bp.route('/', methods=['GET', 'POST'])
def UserLoginPage():
    if request.method == 'POST':
        db = db_utils.get_db()
        username_input = request.form['username']
        password_input = request.form['password']
        if (auth.VerifyLoginCredentials(username_input, password_input, db)):
            return redirect(url_for('DashboardPage'))
        else:
            return render_template('login-page.html', error="Invalid credentials")
    else:
        return render_template('login-page.html')

@bp.route('/dashboard')
def DashboardPage():
    return "This is the student dashboard page."

@bp.route('/sign-up', methods=['GET', 'POST'])
def StudentSignUpPage():
    if request.method == 'POST':
        db = db_utils.get_db()
        student_id = request.form["studentid"]
        username = request.form["schoolemail"]
        password = request.form["password"]
        if (auth.VerifySignUpCredentials(student_id, username, password, db)):
            return redirect(url_for("UserLoginPage"))
    else:
        return render_template('sign-up-page.html')
    
@bp.post("/chatbot")
def ChatbotEndpoint():
    data = request.get_json(force=True) or {}
    user_message = (data.get("user_message") or "").strip()
    history = data.get("history") or []

    if not user_message:
        return jsonify({"chatbot_response": "Please type a message."}), 200

    student_id_raw = "1" # TODO: Get student ID from session
    try:
        student_id = int(student_id_raw) if student_id_raw is not None else None
    except (TypeError, ValueError):
        student_id = None

    # Prefer DB answers, fall back to vector retrieval automatically
    routing_result = rag_router.route(user_message, student_id=student_id)
    context = routing_result.context
    
    prompt = build_prompt(user_message=user_message, history=history, context=context, max_turns=4)

    reply = llm_generate(
        prompt=prompt,
        max_new_tokens=96,
        temperature=0.0,
        do_sample=False
    )

    payload = {
        "chatbot_response": reply,
        "source": routing_result.source,
        "metadata": routing_result.metadata,
    }
    return jsonify(payload), 200

# Optional: simple ingestion endpoint (POST form-data: folder=path)
@bp.post("/rag/ingest")
def rag_ingest():
    if "username" not in session:
        return jsonify({"ok": False, "error": "Auth required"}), 401
    folder = request.form.get("folder") or request.json.get("folder")
    if not folder or not os.path.isdir(folder):
        return jsonify({"ok": False, "error": "Valid folder path required"}), 400
    docs, chunks = rag_utils.ingest_folder(folder)
    return jsonify({"ok": True, "docs": docs, "chunks": chunks})
