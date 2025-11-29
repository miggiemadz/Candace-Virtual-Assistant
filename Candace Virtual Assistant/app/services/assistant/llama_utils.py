import os
import threading
from llama_cpp import Llama

# ---------------------------------------------------------------------------
# Configuration: paths and environment variables
# ---------------------------------------------------------------------------

# Default path to your quantized model. You can override this via the
# LLAMA_GGUF_PATH environment variable. Use an absolute path or a path
# relative to the repository root (two levels up from this file).
DEFAULT_GGUF_PATH = os.getenv(
    "LLAMA_GGUF_PATH",
    r".\models\Meta-Llama-3.1-8B-Instruct-Q4_K_M.gguf",
)

# Global singleton model + lock to avoid race conditions on first load
_model = None
_lock = threading.Lock()


def _resolve_path(p: str) -> str:
    """
    Resolve a possibly-relative model path to an absolute path rooted at the
    project root (two directories above this file).
    """
    if not os.path.isabs(p):
        base = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
        p = os.path.abspath(os.path.join(base, p))
    return p


def _parse_int_env(name: str, default: int) -> int:
    """
    Helper to safely parse integer environment variables.
    Falls back to 'default' on any error and prints a debug message.
    """
    raw = os.getenv(name, None)
    if raw is None:
        return default
    try:
        value = int(raw)
        print(f"[Candace][LLAMA] {name}={value} (from environment)")
        return value
    except ValueError:
        print(
            f"[Candace][LLAMA][WARN] Could not parse {name}={raw!r}; "
            f"falling back to default={default}."
        )
        return default


def _ensure_loaded(gguf_path: str = DEFAULT_GGUF_PATH):
    """
    Lazily load the Llama model as a process-wide singleton.

    GPU OFFLOAD:
      - Controlled by the environment variable LLAMA_N_GPU_LAYERS
      -  0  => CPU only
      - >0  => that many layers offloaded to GPU
      - -1  => "all layers" offloaded (subject to GPU VRAM & build support)

    Other knobs:
      - LLAMA_N_CTX    => context window (default: 8192)
      - LLAMA_THREADS  => override number of CPU threads
    """
    global _model
    if _model is not None:
        return

    with _lock:
        if _model is not None:
            return

        # Resolve model path
        gguf_path = _resolve_path(gguf_path)
        if not os.path.exists(gguf_path):
            raise ValueError(f"[Candace][LLAMA] GGUF not found at: {gguf_path}")

        # -------------------------------------------------------------------
        # GPU configuration via LLAMA_N_GPU_LAYERS
        # -------------------------------------------------------------------
        # Default behavior: -1 (all layers) so that if you *do* have a CUDA
        # build of llama-cpp-python, you get GPU offload automatically.
        n_gpu_layers = _parse_int_env("LLAMA_N_GPU_LAYERS", default=-1)

        # Context length
        n_ctx = _parse_int_env("LLAMA_N_CTX", default=8192)

        # CPU threads: use environment override if set, otherwise all cores
        threads_env = os.getenv("LLAMA_THREADS", "").strip()
        if threads_env:
            try:
                n_threads = int(threads_env)
                print(f"[Candace][LLAMA] LLAMA_THREADS={n_threads} (from environment)")
            except ValueError:
                n_threads = os.cpu_count() or 1
                print(
                    f"[Candace][LLAMA][WARN] Invalid LLAMA_THREADS={threads_env!r}; "
                    f"using n_threads={n_threads}."
                )
        else:
            n_threads = os.cpu_count() or 1
            print(f"[Candace][LLAMA] Using n_threads={n_threads} (auto)")

        # Informational logging about intended device
        if n_gpu_layers == 0:
            offload_str = "CPU only (n_gpu_layers=0)"
        elif n_gpu_layers < 0:
            offload_str = "attempting GPU offload for ALL layers (n_gpu_layers=-1)"
        else:
            offload_str = f"attempting GPU offload for {n_gpu_layers} layers"

        print("[Candace][LLAMA] Loading model with:")
        print(f"  - model_path   = {gguf_path}")
        print(f"  - n_ctx        = {n_ctx}")
        print(f"  - n_threads    = {n_threads}")
        print(f"  - n_gpu_layers = {n_gpu_layers}  -> {offload_str}")

        # -------------------------------------------------------------------
        # Create the Llama model
        # NOTE: GPU offload requires a CUDA-enabled build of llama-cpp-python.
        # If you installed a CPU-only wheel, n_gpu_layers>0 will be ignored by
        # the underlying library and everything will effectively run on CPU.
        # -------------------------------------------------------------------
        _model = Llama(
            model_path=gguf_path,
            n_ctx=n_ctx,
            n_threads=n_threads,
            n_gpu_layers=n_gpu_layers,
            verbose=False,
        )

        print("[Candace][LLAMA] Model loaded successfully.")


def load(gguf_path: str = DEFAULT_GGUF_PATH):
    """
    Explicitly load the model and return it along with a simple "device" string.

    Returns:
        (model, tokenizer, device_str)
        - tokenizer is None for llama.cpp, kept for API compatibility.
        - device_str is 'gpu' if LLAMA_N_GPU_LAYERS > 0, else 'cpu'.
    """
    _ensure_loaded(gguf_path)

    # Infer logical device from env (informational only; llama.cpp controls HW)
    device = "cpu"
    try:
        if _parse_int_env("LLAMA_N_GPU_LAYERS", default=-1) > 0:
            device = "gpu"
    except Exception:
        # If anything weird happens, stay conservative and say "cpu"
        device = "cpu"

    print(f"[Candace][LLAMA] load() reporting device='{device}'")
    return _model, None, device


def generate_response(
    prompt: str,
    gguf_path: str = DEFAULT_GGUF_PATH,
    max_new_tokens: int = 160,
    temperature: float = 0.2,
    top_p: float = 0.9,
    top_k: int = 40,
    stop_strings: list[str] | None = None,
    **_,
) -> str:
    """
    Generate a response from the LLaMA model.

    Args:
        prompt: The full prompt string (including any system / user formatting).
        gguf_path: Path to the GGUF model file (optional; defaults via env).
        max_new_tokens: Maximum number of tokens to generate.
        temperature: Sampling temperature.
        top_p: Nucleus sampling probability mass.
        top_k: Top-k sampling cutoff.
        stop_strings: Optional list of stop strings.

    Returns:
        The generated text (stripped of leading/trailing whitespace).
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
    Release the global model reference so it can be garbage-collected.

    Note: llama-cpp-python may still keep some underlying resources until the
    Python process exits. This is best-effort cleanup for long-running apps.
    """
    global _model
    if _model is not None:
        print("[Candace][LLAMA] Freeing model from memory.")
    _model = None
