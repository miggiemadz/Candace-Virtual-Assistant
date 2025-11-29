import os
import threading
from llama_cpp import Llama

# Default path to your quantized model.  You can override this via the
# LLAMA_GGUF_PATH environment variable.  Use an absolute path or a
# path relative to the repository root.  When targeting GPU, make sure
# the model is small enough to fit into your GPU memory.
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
        # Determine how many layers of the model should be offloaded to the GPU.
        # When n_gpu_layers is set to 0 the model will run entirely on CPU.
        # Set LLAMA_N_GPU_LAYERS in your environment (e.g. via .env) to a
        # positive integer or -1 to offload all layers to the GPU.  See
        # https://github.com/ggerganov/llama.cpp for details.  Note that
        # using GPU requires a CUDA-enabled build of llama-cpp-python.
        n_gpu_layers_env = os.getenv("LLAMA_N_GPU_LAYERS", "-1")
        try:
            n_gpu_layers = int(n_gpu_layers_env)
        except ValueError:
            # Fallback to CPU if the env var cannot be parsed
            n_gpu_layers = 0

        n_ctx = int(os.getenv("LLAMA_N_CTX", "8192"))
        # Use all available CPU cores for CPU-side work.  Even when using
        # GPU offload, llama.cpp still uses CPU threads for some tasks.
        n_threads = os.cpu_count() or 1

        _model = Llama(
            model_path=gguf_path,
            n_ctx=n_ctx,
            n_threads=n_threads,
            n_gpu_layers=n_gpu_layers,
            verbose=False,
        )


def load(gguf_path: str = DEFAULT_GGUF_PATH):
    """
    Explicit loader if you want to preload the model at app startup.
    """
    _ensure_loaded(gguf_path)
    # Determine if the model is offloading any layers to GPU based on env. If
    # LLAMA_N_GPU_LAYERS > 0, return 'gpu' as the device string. Otherwise
    # return 'cpu'. This is purely informational; the device selection
    # happens in _ensure_loaded.
    device = "cpu"
    try:
        if int(os.getenv("LLAMA_N_GPU_LAYERS", "-1")) > 0:
            device = "gpu"
    except ValueError:
        pass
    return _model, None, device


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
