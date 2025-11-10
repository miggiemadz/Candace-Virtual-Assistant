# models/llama_utils.py
import os
import threading
import torch
from transformers import AutoModelForCausalLM, AutoTokenizer

# You can override via env var LLAMA_MODEL_ID
DEFAULT_MODEL_ID = os.getenv("LLAMA_MODEL_ID", "sshleifer/tiny-gpt2")

_model = None
_tokenizer = None
_device = None
_lock = threading.Lock()


def get_device():
    """
    Returns a torch device string: 'cuda', 'mps', or 'cpu'.
    """
    if torch.cuda.is_available():
        return "cuda"
    if getattr(torch.backends, "mps", None) and torch.backends.mps.is_available():
        return "mps"
    return "cpu"


def _ensure_loaded(model_name: str = DEFAULT_MODEL_ID, device: str | None = None):
    """
    Lazy-loads model/tokenizer once, thread-safe.
    Also sets a pad_token for GPT-2 style tokenizers.
    """
    global _model, _tokenizer, _device
    if _model is not None and _tokenizer is not None:
        return

    with _lock:
        if _model is not None and _tokenizer is not None:
            return

        _device = device or get_device()
        _tokenizer = AutoTokenizer.from_pretrained(model_name)

        # Many decoder-only models (e.g., GPT-2) lack a pad token.
        if _tokenizer.pad_token is None:
            _tokenizer.pad_token = _tokenizer.eos_token

        _model = AutoModelForCausalLM.from_pretrained(model_name)
        _model.to(_device)
        _model.eval()


def load(model_name: str = DEFAULT_MODEL_ID, device: str | None = None):
    """
    Explicit loader if you want to preload at app start.
    """
    _ensure_loaded(model_name, device)
    return _model, _tokenizer, _device


def generate_response(
    prompt: str,
    model_name: str = DEFAULT_MODEL_ID,
    max_new_tokens: int = 80,
    temperature: float = 0.7,
    do_sample: bool = True,
    top_p: float = 0.95,
    top_k: int = 40,
    device: str | None = None,
):
    """
    Core inference method (no pipeline). Uses lazy-loaded model/tokenizer.
    Uses max_new_tokens so prompt length won't choke outputs.
    """
    _ensure_loaded(model_name, device)

    # Encode on same device as model
    inputs = _tokenizer(prompt, return_tensors="pt", truncation=True).to(_device)

    gen_kwargs = dict(
        max_new_tokens=max_new_tokens,
        pad_token_id=_tokenizer.pad_token_id,
        eos_token_id=_tokenizer.eos_token_id,
    )
    if do_sample:
        gen_kwargs.update(dict(do_sample=True, temperature=temperature, top_p=top_p, top_k=top_k))
    else:
        gen_kwargs.update(dict(do_sample=False))

    with torch.no_grad():
        outputs = _model.generate(**inputs, **gen_kwargs)

    text = _tokenizer.decode(outputs[0], skip_special_tokens=True)
    # Many decoder-only models echo the prompt; strip it if present
    if text.startswith(prompt):
        text = text[len(prompt):].lstrip()

    return text.strip()


def free():
    """
    Frees VRAM/Metal memory. Call on shutdown if needed.
    """
    global _model, _tokenizer
    _model = None
    _tokenizer = None
    if torch.cuda.is_available():
        torch.cuda.empty_cache()
