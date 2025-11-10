from flask import Flask
from .routes import bp
from . import db_utils

def create_app():
    app = Flask(__name__, template_folder="templates", static_folder="static")
    app.secret_key = "weshouldputthisintheenv"
    
    app.register_blueprint(bp)

    # Register DB teardown + ensure folder exists
    db_utils.init_app(app)

    return app