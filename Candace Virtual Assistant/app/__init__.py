# app/__init__.py

from flask import Flask
from config import Config
from .routes import bp
from .services import rag_utils
from . import db_utils
import os


def create_app():
    # Create the Flask app instance
    app = Flask(__name__, template_folder="templates", static_folder="static")

    # Load configuration from config.py (loads .env via Config)
    app.config.from_object(Config)

    # Apply secret key safely from environment
    app.config["SECRET_KEY"] = Config.SECRET_KEY

    # Initialize MySQL teardown logic
    db_utils.init_app(app)

    # Initialize RAG system
    index_dir = os.getenv("CANDACE_INDEX_DIR")  # optional custom location
    rag_utils.init(app_root=app.root_path, index_dir=index_dir)

    # Register all routes
    app.register_blueprint(bp)

    return app
