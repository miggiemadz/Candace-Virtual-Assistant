# config.py

import os
from pathlib import Path
from dotenv import load_dotenv

BASE_DIR = Path(__file__).resolve().parent
ENV_PATH = BASE_DIR / ".env"

# Load .env
if ENV_PATH.exists():
    load_dotenv(ENV_PATH)

class Config:
    # Flask
    SECRET_KEY = os.getenv("SECRET_KEY", "dev-key-change-me")
    FLASK_ENV = os.getenv("FLASK_ENV", "development")

    # MySQL database settings
    DB_HOST = os.getenv("DB_HOST", "localhost")
    DB_PORT = int(os.getenv("DB_PORT", "3306"))
    DB_USER = os.getenv("DB_USER", "candace_user")
    DB_PASSWORD = os.getenv("DB_PASSWORD", "")
    DB_NAME = os.getenv("DB_NAME", "candace_assistant")
