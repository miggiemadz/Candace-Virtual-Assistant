from flask import Flask

def create_app():
    app = Flask(__name__, template_folder="templates", static_folder="static")
    app.secret_key = "change-me"  # set a real secret in prod

    from .routes import bp
    app.register_blueprint(bp)

    return app