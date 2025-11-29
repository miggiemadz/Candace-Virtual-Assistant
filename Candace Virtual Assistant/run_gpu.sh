#!/usr/bin/env bash
set -e

# go to this script's directory (project root)
cd "$(dirname "$0")"

# activate venv
source venv-gpu/Scripts/activate

# GPU config
export LLAMA_GGUF_PATH="$PWD/app/models/Meta-Llama-3.1-8B-Instruct-Q4_K_M.gguf"
export LLAMA_N_CTX="8192"
export LLAMA_N_GPU_LAYERS="-1"
export CANDACE_EMBED_DEVICE="cuda"

# start app
python run.py