# models/prompt_utils.py
from typing import List, Dict

SYSTEM = (
    "You are Candace, a helpful assistant for a Canvas-like LMS. "
    "Use the provided CONTEXT verbatim when answering. "
    "If the answer is not in the context, say you don't know and suggest where to check in Canvas."
)

def build_prompt(user_message: str, history: List[Dict[str, str]] | None = None, context: str = "", max_turns: int = 4) -> str:
    history = history or []
    turns = history[-(max_turns*2):]

    lines = [f"System: {SYSTEM}"]
    if context.strip():
        lines.append("CONTEXT:\n" + context.strip())

    for m in turns:
        role = "User" if m.get("role") == "user" else "Assistant"
        content = (m.get("content") or "").strip()
        if content:
            lines.append(f"{role}: {content}")

    lines.append(f"User: {user_message.strip()}")
    lines.append("Assistant:")
    return "\n".join(lines)

