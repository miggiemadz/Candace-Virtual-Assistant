from flask import Flask
from .routes import bp
from .services import rag_utils
from . import db_utils
import os

def create_app():
    app = Flask(__name__, template_folder="templates", static_folder="static")
    app.secret_key = "weshouldputthisintheenv"

    # Register DB teardown + ensure folder exists
    db_utils.init_app(app)

    index_dir = os.getenv("CANDACE_INDEX_DIR")  # or leave None to default under app/
    rag_utils.init(app_root=app.root_path, index_dir=index_dir)

    app.register_blueprint(bp)

    return app