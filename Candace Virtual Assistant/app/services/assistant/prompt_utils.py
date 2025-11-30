# models/prompt_utils.py
from typing import List, Dict
from config import Config
from app.services import rag_utils

LLAMA_N_CTX = Config.LLAMA_N_CTX
LLAMA_MAX_NEW_TOKENS = Config.LLAMA_MAX_NEW_TOKENS

SYSTEM = (
    "You are Candace, an academic assistant for a Canvas-like LMS. "
    "Your job is to help students understand their courses, deadlines, grades, and coursework using the provided CONTEXT. "

    # Primary rule
    "Always rely on the provided CONTEXT first. If the answer can be inferred or summarized from CONTEXT, do so. "

    # Summarization
    "If the context contains long or repetitive lists (assignments, modules, submissions), summarize them clearly and concisely rather than listing every item. "

    # If missing information
    "If the necessary information is not in the CONTEXT, say you do not have that data and suggest where the student can find it in Canvas (e.g., Assignments page, Syllabus, Modules, Grades). "
    "Never invent fake dates, grades, or course details. "

    # What Candace CAN help with
    "You may: explain course concepts, help study, give examples, simplify topics, outline steps, suggest study strategies, "
    "help with time management, clarify policies if mentioned in CONTEXT, and help the student understand their progress. "

    # What Candace must NOT do
    "You must not: write full assignments for the student, provide quiz/exam answers, generate code or essays that would constitute academic dishonesty, "
    "or fabricate information not present in the CONTEXT. If asked to do so, politely decline and offer to explain the underlying concept instead. "

    # Tone + style
    "Speak in a friendly, supportive, and clear tone. "
    "When giving instructions, be structured and organized. "
    "Keep answers concise unless the student asks for more detail. "

    # Safety
    "If a student expresses stress, confusion, or overwhelm, respond with supportive academic guidance and practical next steps. "

    # Identity
    "Always act as Candace, the course assistant—not as an AI model."
)

def _summarize_history(history: list[dict]) -> str:
    """
    Very lightweight summarizer:
    - Extracts meaning
    - Compresses previous turns
    - Does NOT depend on LLM (fast fallback)
    """
    if not history:
        return ""

    bullets = []
    for h in history:
        role = "User" if h.get("role") == "user" else "Assistant"
        text = (h.get("content") or "").strip()
        if text:
            bullets.append(f"{role}: {text}")

    # If the history is very small → no summarization needed
    if len(bullets) <= 4:
        return "\n".join(bullets)

    # Otherwise compress
    return (
        "Summary of earlier conversation:\n"
        "- The user previously asked about: "
        + ", ".join([b[6:] for b in bullets if b.startswith("User")][:3])
        + ".\n"
        "- Assistant previously explained: "
        + ", ".join([b[10:] for b in bullets if b.startswith("Assistant")][:3])
        + "."
    )


def build_prompt(
    user_message: str,
    history: list[dict] | None = None,
    context: str = "",
    max_turns: int = 4,
) -> str:
    """
    New intelligent prompt builder.
    - Summarizes older history
    - Keeps only last `max_turns` exchanges verbatim
    - Prevents prompt from exceeding context window
    - Preserves system prompt, context, and important metadata
    """

    history = history or []

    # ---------------------------------------
    # 1) Break history into old + recent
    # ---------------------------------------
    recent_turns = history[-(max_turns * 2):]   # last N exchanges
    old_turns = history[:-(max_turns * 2)]

    # ---------------------------------------
    # 2) Summarize older history
    # ---------------------------------------
    history_summary = _summarize_history(old_turns)

    # ---------------------------------------
    # 3) Build initial prompt lines
    # ---------------------------------------
    lines = []

    # System persona
    lines.append(f"System: {SYSTEM}")

    # RAG + student-specific context
    if context.strip():
        lines.append("CONTEXT:")
        lines.append(context.strip())

    # Summarized history (only if exists)
    if history_summary:
        lines.append(history_summary)

    # Recent conversation
    for m in recent_turns:
        role = "User" if m.get("role") == "user" else "Assistant"
        content = (m.get("content") or "").strip()
        if content:
            lines.append(f"{role}: {content}")

    # Final user message
    lines.append(f"User: {user_message.strip()}")
    lines.append("Assistant:")

    prompt = "\n".join(lines)

    # ---------------------------------------
    # 4) Token budgeting
    # ---------------------------------------
    prompt_tokens = rag_utils.estimate_tokens(prompt)
    allowed_tokens = LLAMA_N_CTX - LLAMA_MAX_NEW_TOKENS - 256  # safety

    if prompt_tokens > allowed_tokens:
        # final fallback (very rare): truncate context
        excess = prompt_tokens - allowed_tokens
        print(
            f"[Candace][PROMPT] Prompt too large ({prompt_tokens}), reducing context by ~{excess} tokens"
        )
        # naive trim from context block
        short_context = context[: max(200, len(context) - excess * 4)]
        lines = []
        lines.append(f"System: {SYSTEM}")
        lines.append("CONTEXT:")
        lines.append(short_context.strip())
        if history_summary:
            lines.append(history_summary)
        for m in recent_turns:
            role = "User" if m.get("role") == "user" else "Assistant"
            content = (m.get("content") or "").strip()
            if content:
                lines.append(f"{role}: {content}")
        lines.append(f"User: {user_message.strip()}")
        lines.append("Assistant:")
        prompt = "\n".join(lines)

    return prompt