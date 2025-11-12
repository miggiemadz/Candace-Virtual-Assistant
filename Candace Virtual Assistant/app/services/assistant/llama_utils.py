import os
import threading
from llama_cpp import Llama

# Default path to your quantized model
DEFAULT_GGUF_PATH = os.getenv(
    "LLAMA_GGUF_PATH",
    r".\models\Meta-Llama-3.1-8B-Instruct-Q4_K_M.gguf"
)

_model = None
_lock = threading.Lock()

def _resolve_path(p: str) -> str:
    # If relative, resolve from repo root (this file’s parent’s parent)
    if not os.path.isabs(p):
        base = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
        p = os.path.abspath(os.path.join(base, p))
    return p

def _ensure_loaded(gguf_path: str = DEFAULT_GGUF_PATH):
    global _model
    if _model is not None:
        return
    with _lock:
        if _model is not None:
            return
        gguf_path = _resolve_path(gguf_path)
        if not os.path.exists(gguf_path):
            raise ValueError(f"[Candace] GGUF not found at: {gguf_path}")
        _model = Llama(
            model_path=gguf_path,
            n_ctx=int(os.getenv("LLAMA_N_CTX", "8192")),
            n_threads=os.cpu_count(),
            verbose=False
        )


def load(gguf_path: str = DEFAULT_GGUF_PATH):
    """
    Explicit loader if you want to preload the model at app startup.
    """
    _ensure_loaded(gguf_path)
    return _model, None, "cpu"


def generate_response(
    prompt: str,
    gguf_path: str = DEFAULT_GGUF_PATH,
    max_new_tokens: int = 160,
    temperature: float = 0.2,
    top_p: float = 0.9,
    top_k: int = 40,
    stop_strings: list[str] | None = None,
    **_
) -> str:
    """
    Generates text using Meta-Llama-3.1-8B-Instruct GGUF via llama.cpp.

    Args:
        prompt (str): The formatted system+user prompt.
        max_new_tokens (int): Max new tokens to generate.
        temperature (float): Creativity level (0.0–1.0 typical).
        top_p (float): Nucleus sampling cutoff.
        top_k (int): Top-k sampling cutoff.
        stop_strings (list): Strings that signal stop (e.g. "User:", "Assistant:").

    Returns:
        str: The model's generated text.
    """
    _ensure_loaded(gguf_path)

    stop = stop_strings or ["\nUser:", "User:", "\nAssistant:", "Assistant:"]
    result = _model(
        prompt,
        max_tokens=max_new_tokens,
        temperature=temperature,
        top_p=top_p,
        top_k=top_k,
        stop=stop,
    )

    text = result["choices"][0]["text"]
    if text:
        text = text.strip()

    return text


def free():
    """
    Releases model memory manually if needed.
    """
    global _model
    _model = None
