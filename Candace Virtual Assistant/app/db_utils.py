import os
import sqlite3
from flask import current_app, g

def get_db():
    db = g.get("db")
    if db is None:
        base_dir = os.path.abspath(os.path.dirname(__file__))
        db_path = os.path.join(base_dir, "..", "database", "candace.db")
        db = g.db = sqlite3.connect(db_path)
        db.execute("PRAGMA foreign_keys = ON")
        db.row_factory = sqlite3.Row
    return db
def close_db(exception):
    db = g.pop("db", None)
    if db is not None:
        db.close()
def init_db():
    app.teardown_appcontext(close_db)