import sqlite3
from flask import current_app, g

def get_db():
    db = g.get("db")
    if db is None:
        path = current_app.config.get("DATABASE", "candace.db")
        db = g.db = sqlite3.connect(path)
        db.execute("PRAGMA foreign_keys = ON")
        db.row_factory = sqlite3.Row
    return db
def close_db(exception):
    db = g.pop("db", None)
    if db is not None:
        db.close()
def init_db():
    app.teardown_appcontext(close_db)