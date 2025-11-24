# app/auth_utils.py

from functools import wraps
from flask import session, redirect, url_for, flash, g
from werkzeug.security import check_password_hash
from .db_utils import query_db


def get_current_user():
    """
    Loads the current logged-in user from the DB using session['user_id'].
    Caches it on flask.g for this request.
    """
    if hasattr(g, "current_user"):
        return g.current_user

    user_id = session.get("user_id")
    if not user_id:
        g.current_user = None
        return None

    user = query_db(
        "SELECT id, email, role, student_id, professor_id FROM users WHERE id = %s",
        (user_id,),
        one=True,
    )
    g.current_user = user
    return user


def login_user(user_row):
    """
    Stores user identity in the session.
    user_row is a dict from query_db.
    """
    session["user_id"] = user_row["id"]
    session["role"] = user_row["role"]
    session["student_id"] = user_row.get("student_id")
    session["professor_id"] = user_row.get("professor_id")


def logout_user():
    """
    Clears the session.
    """
    session.clear()


def login_required(view):
    """
    Decorator: require any logged-in user.
    """

    @wraps(view)
    def wrapped_view(*args, **kwargs):
        if not session.get("user_id"):
            flash("Please log in to access this page.", "warning")
            return redirect(url_for("main.login"))
        return view(*args, **kwargs)

    return wrapped_view


def role_required(*roles):
    """
    Decorator: require that the current user has one of the given roles.
    Example: @role_required('admin', 'instructor')
    """

    def decorator(view):
        @wraps(view)
        def wrapped_view(*args, **kwargs):
            user = get_current_user()
            if not user:
                flash("Please log in first.", "warning")
                return redirect(url_for("main.login"))

            if user["role"] not in roles:
                flash("You do not have permission to access this page.", "danger")
                return redirect(url_for("main.dashboard"))
            return view(*args, **kwargs)

        return wrapped_view

    return decorator


def verify_login_credentials(email: str, password: str):
    """
    Looks up the user by email and checks the password hash.
    Returns the user row dict if valid, otherwise None.
    """
    user = query_db(
        "SELECT id, email, password_hash, role, student_id, professor_id "
        "FROM users WHERE email = %s",
        (email,),
        one=True,
    )
    if not user:
        return None

    if not check_password_hash(user["password_hash"], password):
        return None

    return user
