# test_llama_gpu.py
"""
Standalone GPU test for the LLaMA model via llama_cpp.

Run this from the same directory as run.py, with venv-gpu activated:

    # terminal 1 (watch GPU):
    nvidia-smi -l 0.5

    # terminal 2 (run test):
    export LLAMA_GGUF_PATH="./models/Meta-Llama-3.1-8B-Instruct-Q4_K_M.gguf"
    export LLAMA_N_GPU_LAYERS="-1"   # or "30" for fewer layers
    source venv-gpu/Scripts/activate
    python test_llama_gpu.py
"""

import os
from app.services.assistant.llama_utils import load

def main():
    # Ensure env vars are set (use defaults if they’re missing)
    gguf_default = r".\models\Meta-Llama-3.1-8B-Instruct-Q4_K_M.gguf"
    gguf_path = os.environ.get("LLAMA_GGUF_PATH", gguf_default)
    os.environ["LLAMA_GGUF_PATH"] = gguf_path

    n_gpu_layers = os.environ.get("LLAMA_N_GPU_LAYERS", "-1")
    os.environ["LLAMA_N_GPU_LAYERS"] = n_gpu_layers

    print("[TEST] Using GGUF path:", gguf_path)
    print("[TEST] LLAMA_N_GPU_LAYERS:", n_gpu_layers)

    # Load model via our helper (this should trigger CUDA offload if compiled)
    print("[TEST] Loading model via llama_utils.load() ...")
    model, _, device = load()
    print("[TEST] llama_utils.load() reported device:", device)

    # Long-ish prompt to keep GPU busy long enough to see in nvidia-smi
    prompt = (
        "You are Candace, a helpful virtual assistant for college students. "
        "Explain in detail (at least 1000 words) the differences between data science "
        "and cybersecurity, including typical coursework, career paths, skills required, "
        "and how a student might decide which path is best for them. Use headings and "
        "bullet points where appropriate."
    )

    print("[TEST] Generating response...")
    result = model(
        prompt,
        max_tokens=512,
        temperature=0.2,
        top_p=0.9,
        top_k=40,
        stop=["User:", "\nUser:", "Assistant:", "\nAssistant:"],
    )

    text = result["choices"][0]["text"]
    if text:
        text = text.strip()

    print("\n[TEST] Output (first 600 chars):\n")
    print(text[:600])
    print("\n[TEST] Done.")

if __name__ == "__main__":
    main()
