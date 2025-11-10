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


# models/llama_utils.py (replace generate_response with this version)
def generate_response(
    prompt: str,
    model_name: str = DEFAULT_MODEL_ID,
    max_new_tokens: int = 80,
    temperature: float = 0.0,      # deterministic by default
    do_sample: bool = False,       # deterministic by default
    top_p: float = 0.9,
    top_k: int = 40,
    device: str | None = None,
    stop_strings: list[str] | None = None,
):
    """
    Generates ONLY the new tokens (no prompt echo).
    Adds repetition constraints; supports simple stop strings.
    """
    _ensure_loaded(model_name, device)

    stop_strings = stop_strings or ["\nUser:", "User:", "Assistant:", "\nAssistant:"]
    inputs = _tokenizer(prompt, return_tensors="pt", truncation=True)
    input_ids = inputs["input_ids"].to(_device)
    attention_mask = inputs.get("attention_mask")
    if attention_mask is not None:
        attention_mask = attention_mask.to(_device)

    gen_kwargs = dict(
        max_new_tokens=max_new_tokens,
        pad_token_id=_tokenizer.pad_token_id,
        eos_token_id=_tokenizer.eos_token_id,
        repetition_penalty=1.1,
        no_repeat_ngram_size=3,
        do_sample=do_sample,
    )
    if do_sample:
        gen_kwargs.update(dict(temperature=temperature, top_p=top_p, top_k=top_k))

    with torch.no_grad():
        outputs = _model.generate(
            input_ids=input_ids,
            attention_mask=attention_mask,
            **gen_kwargs
        )

    # Slice out only the newly generated token ids
    gen_ids = outputs[0][input_ids.shape[1]:]
    text = _tokenizer.decode(gen_ids, skip_special_tokens=True).strip()

    # Simple stop-string truncation
    for s in stop_strings:
        idx = text.find(s)
        if idx != -1:
            text = text[:idx].strip()
            break

    return text

def free():
    """
    Frees VRAM/Metal memory. Call on shutdown if needed.
    """
    global _model, _tokenizer
    _model = None
    _tokenizer = None
    if torch.cuda.is_available():
        torch.cuda.empty_cache()
