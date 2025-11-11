"""
Required Methods

get_db()
Opens or reuses a per-request SQLite connection and stores it on Flask’s `g` object.
If no connection exists, it builds a path to `../database/candace.db`,
connects, enables foreign keys, and sets a row factory so rows act like dicts.

Parameters:
None

Return:
A live sqlite3 connection object stored as `db`.
-----------------------------------------------------------------------------------------------------------

close_db(exception)
Safely closes the per-request SQLite connection at the end of the request.
If no connection is present, it does nothing.

Parameters:
exception -- The exception raised during the request. Required by Flask’s teardown signature.

Return:
None *Closes the connection if it exists
---------------------------------------------------------------------------------------------------------------

teardown_db(app)
Registers the `close_db` function with the Flask app so it runs after each request
and frees the database connection automatically.

Parameters:
(app) -- The Flask application instance that will call `close_db` on teardown.

Return:
None *tears down the database connection
---------------------------------------------------------------------------------------------------------------
Foreign Key Enforcement
Executed immediately after connecting. Ensures SQLite enforces FK constraints so
your schema relationships are respected

Return:
None (PRAGMA applies to the current connection).

Row Factory Behavior
Configures `db.row_factory = sqlite3.Row` so you can access columns by name


Return:
None *affects how fetched rows are shaped
------------------------------------------------------------------------------------------------------------

Notes
- Call `teardown_db(app)` once during app setup to register teardown behavior.
- Inside request handlers, call `get_db()` to read/write the database; the same connection
  is reused for the lifetime of that request.
- `close_db` is called automatically by Flask after the request finishes, so you don’t
  have to close the connection manually.

"""

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
def teardown_db():
    app.teardown_appcontext(close_db)