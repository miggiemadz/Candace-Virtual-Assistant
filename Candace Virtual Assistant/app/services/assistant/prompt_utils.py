# models/prompt_utils.py
from typing import List, Dict

SYSTEM = (
    "You are Candace, a helpful assistant for a Canvas-like LMS. "
    "Always answer using only the provided course/student context when available. "
    "Be concise and actionable for students."
)

def build_prompt(user_message: str, history: List[Dict[str, str]] | None = None, max_turns: int = 5) -> str:
    """
    Formats a simple dialogue with a system header.
    history: list like [{"role":"user","content":"..."},{"role":"assistant","content":"..."}]
    """
    history = history or []
    turns = history[-(max_turns*2):]  # last N pairs
    lines = [f"System: {SYSTEM}"]

    for m in turns:
        role = m.get("role", "user")
        content = (m.get("content") or "").strip()
        prefix = "User" if role == "user" else "Assistant"
        if content:
            lines.append(f"{prefix}: {content}")

    lines.append(f"User: {user_message.strip()}")
    lines.append("Assistant:")
    return "\n".join(lines)
