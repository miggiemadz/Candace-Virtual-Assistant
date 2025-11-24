# app/db_utils.py

import mysql.connector
from mysql.connector import Error
from flask import current_app, g

def get_db():
    """
    Returns a MySQL connection stored on g for this request.
    """
    if "db" not in g:
        try:
            g.db = mysql.connector.connect(
                host=current_app.config["DB_HOST"],
                port=current_app.config["DB_PORT"],
                user=current_app.config["DB_USER"],
                password=current_app.config["DB_PASSWORD"],
                database=current_app.config["DB_NAME"],
                autocommit=False
            )
        except Error as e:
            print(f"[DB ERROR] Could not connect to MySQL: {e}")
            raise
    return g.db


def close_db(e=None):
    """
    Closes the DB connection at the end of the request.
    """
    db = g.pop("db", None)
    if db is not None:
        db.close()


def init_app(app):
    """
    Registers teardown handler.
    """
    app.teardown_appcontext(close_db)


def query_db(query, args=None, one=False):
    """
    Runs a SELECT query. Returns list of dicts.
    """
    conn = get_db()
    cursor = conn.cursor(dictionary=True)
    cursor.execute(query, args or ())
    results = cursor.fetchall()
    cursor.close()
    return (results[0] if results else None) if one else results


def execute_db(query, args=None):
    """
    Runs INSERT/UPDATE/DELETE.
    Returns LAST_INSERT_ID.
    """
    conn = get_db()
    cursor = conn.cursor()
    cursor.execute(query, args or ())
    last_id = cursor.lastrowid
    conn.commit()
    cursor.close()
    return last_id
