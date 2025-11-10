from flask import Blueprint, redirect, url_for, request, render_template, jsonify, session
from . import db_utils
from . import auth_utils as auth
from .services.assistant.llama_utils import generate_response as llm_generate
from .services.assistant.prompt_utils import build_prompt

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
    """
    Expects JSON:
      {
        "user_message": "string",
        "history": [{"role":"user|assistant","content":"..."}]
      }
    Returns:
      { "chatbot_response": "string" }
    """
    try:
        data = request.get_json(force=True) or {}
        user_message = (data.get("user_message") or "").strip()
        history = data.get("history") or []

        if not user_message:
            return jsonify({"chatbot_response": "Please type a message."}), 200

        # If you want to add DB-derived context, fetch here (e.g., from session['username'])
        # context_text = main.fetch_student_context(session.get('username'))
        # Then add to system prompt or preface the prompt string.

        prompt = build_prompt(user_message=user_message, history=history, max_turns=5)

        reply = llm_generate(
            prompt=prompt,
            # You can tune these:
            max_new_tokens=64,
            temperature=0.0,
            do_sample=False,
            top_p=0.9,
            top_k=40,
        )

        return jsonify({"chatbot_response": reply}), 200
    except Exception as e:
        # Optionally log e
        return jsonify({"chatbot_response": "Sorry, something went wrong."}), 500
