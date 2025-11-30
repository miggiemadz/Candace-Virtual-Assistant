# config.py

import os
from pathlib import Path
from dotenv import load_dotenv

# ---------------------------------------------------------
# Load .env from project root
# ---------------------------------------------------------
BASE_DIR = Path(__file__).resolve().parent
ENV_PATH = BASE_DIR / ".env"

if ENV_PATH.exists():
    load_dotenv(ENV_PATH)
else:
    print(f"[Config] WARNING: .env file not found at {ENV_PATH}")


def _get_int_env(name: str, default: int) -> int:
    """
    Safe integer reader for environment variables.
    Falls back to default and logs errors instead of crashing.
    """
    raw = os.getenv(name, None)
    if raw is None:
        return default
    try:
        return int(raw)
    except ValueError:
        print(f"[Config] WARNING: Invalid int for {name}={raw!r}, using default={default}")
        return default


class Config:
    # Flask
    SECRET_KEY = os.getenv("SECRET_KEY", "dev-key-change-me")
    FLASK_ENV = os.getenv("FLASK_ENV", "development")

    # -----------------------------------------------------
    # MySQL settings
    # -----------------------------------------------------
    DB_HOST = os.getenv("DB_HOST", "localhost")
    DB_PORT = _get_int_env("DB_PORT", 3306)
    DB_USER = os.getenv("DB_USER", "candace_user")
    DB_PASSWORD = os.getenv("DB_PASSWORD", "")
    DB_NAME = os.getenv("DB_NAME", "candace_assistant")

    # -----------------------------------------------------
    # LLM configuration (single source of truth)
    # -----------------------------------------------------
    # Default context window for Llama 3.1 = 8192
    LLAMA_N_CTX = _get_int_env("LLAMA_N_CTX", 8192)

    # How many tokens the assistant is allowed to generate
    LLAMA_MAX_NEW_TOKENS = _get_int_env("LLAMA_MAX_NEW_TOKENS", 400)

    # Safety check: ensure max_new_tokens < n_ctx
    if LLAMA_MAX_NEW_TOKENS >= LLAMA_N_CTX:
        print(
            f"[Config] WARNING: LLAMA_MAX_NEW_TOKENS={LLAMA_MAX_NEW_TOKENS} "
            f"is >= LLAMA_N_CTX={LLAMA_N_CTX}. Adjusting automatically."
        )
        LLAMA_MAX_NEW_TOKENS = LLAMA_N_CTX // 4  # fallback safe value