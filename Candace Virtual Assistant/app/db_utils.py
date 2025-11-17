import os
import sqlite3
from flask import current_app, g

def _default_db_path():
    """
    Default: <project>/app/database/candace.db
    You can override with app.config['DATABASE'] in create_app().
    """
    return os.path.join(current_app.root_path, "database", "candace.db")

def get_db():
    """
    Per-request connection stored on g['db'].
    Enforces foreign keys and returns rows as dict-like objects.
    """
    if "db" not in g:
        db_path = current_app.config.get("DATABASE") or _default_db_path()
        # Ensure parent directory exists
        os.makedirs(os.path.dirname(db_path), exist_ok=True)

        conn = sqlite3.connect(db_path)
        conn.execute("PRAGMA foreign_keys = ON")
        conn.row_factory = sqlite3.Row
        g.db = conn
    return g.db

def close_db(e=None):
    """
    Closes the per-request connection.
    Registered via app.teardown_appcontext in init_app().
    """
    db = g.pop("db", None)
    if db is not None:
        db.close()

def init_app(app):
    """
    Call this in create_app(app) to register teardown and ensure DB dir exists.
    Optionally set app.config['DATABASE'] before calling.
    """
    # Ensure default path exists if user didn’t set DATABASE
    db_path = app.config.get("DATABASE")
    if not db_path:
        db_path = os.path.join(app.root_path, "database", "candace.db")
        app.config["DATABASE"] = db_path
    os.makedirs(os.path.dirname(db_path), exist_ok=True)

    app.teardown_appcontext(close_db)

def init_schema(app, schema_path=None):
    """
    One-time schema creation helper. Call this from a CLI command or once at startup.
    """
    schema_path = schema_path or os.path.join(app.root_path, "database", "schema.sql")
    if not os.path.exists(schema_path):
        # Optional: create a minimal schema if schema.sql is missing.
        # Comment this block out if you prefer to require schema.sql.
        ddl = """
        PRAGMA foreign_keys = ON;
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            student_id TEXT,
            email TEXT UNIQUE,
            password_hash TEXT,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        );
        CREATE TABLE IF NOT EXISTS chat_logs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_email TEXT,
            role TEXT CHECK(role IN ('user','assistant')),
            content TEXT,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        );
        """
        with app.app_context():
            db = get_db()
            db.executescript(ddl)
            db.commit()
        return

    with app.app_context():
        db = get_db()
        with open(schema_path, "r", encoding="utf-8") as f:
            db.executescript(f.read())
        db.commit()
