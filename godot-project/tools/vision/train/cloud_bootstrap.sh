#!/usr/bin/env bash
# Portable bootstrap for MiniCPM-V 4.6 LoRA fine-tuning on a fresh NVIDIA GPU box
# (RunPod / Vast.ai / Lambda / any Ubuntu + CUDA image). Idempotent-ish.
#
# WHAT YOU BRING:
#   - the dataset dir     (extract bundle or rsync data -> $DATA_DIR on the box)
#   - optional HF_TOKEN  (model is currently public; token helps rate limits)
#   - optional WANDB_API_KEY for live curves
#
# USAGE (on the GPU box, from this tools/vision/train dir):
#   export HF_TOKEN=hf_xxx
#   bash cloud_bootstrap.sh
#   bash run_swift_lora.sh
#   python3 run_baseline_ollama.py ...   # (baseline is done LOCALLY, not here)
#   # after training, evaluate the tuned model, then score_predictions.py
set -euo pipefail

: "${HF_TOKEN:=}"   # optional: model is public; token only helps with rate limits
DATA_DIR="${DATA_DIR:-$HOME/hazemoor-vision/data}"
MODEL_DIR="${MODEL_DIR:-$HOME/MiniCPM-V-4_6}"
ENV_NAME="${ENV_NAME:-mcpmv46}"

echo "==> GPU check"
nvidia-smi || { echo "NO NVIDIA GPU — this box cannot train MiniCPM-V 4.6"; exit 1; }

echo "==> Python env ($ENV_NAME)"
if command -v conda >/dev/null 2>&1; then
  conda create -n "$ENV_NAME" python=3.10 -y
  # shellcheck disable=SC1091
  source "$(conda info --base)/etc/profile.d/conda.sh"; conda activate "$ENV_NAME"
else
  python3 -m venv "$HOME/$ENV_NAME"; source "$HOME/$ENV_NAME/bin/activate"
fi

echo "==> Core deps (pinned to MiniCPM-V CookBook swift recipe)"
pip install -U pip
pip install torch==2.8.0 torchvision==0.23.0
pip install transformers==5.7.0 accelerate==1.13.0 deepspeed==0.18.3 \
    peft==0.18.1 trl==0.24.0 wandb ninja einops safetensors tokenizers sentencepiece
MAX_JOBS="${MAX_JOBS:-32}" NVCC_THREADS=4 pip install --no-build-isolation flash-attn==2.8.3

echo "==> ms-swift (latest official, minicpmv4_6 supported)"
if [ ! -d ms-swift ]; then git clone https://github.com/modelscope/ms-swift.git; fi
( cd ms-swift && pip install -e . )
pip install "transformers>=5.7.0"   # ensure not downgraded by ms-swift

echo "==> transformers final version"
python3 -c "import transformers,sys; v=transformers.__version__; print('transformers',v); sys.exit(0 if tuple(map(int,v.split('.')[:2]))>=(5,7) else 1)"

echo "==> Weights: openbmb/MiniCPM-V-4_6 -> $MODEL_DIR"
export HF_TOKEN
hf download openbmb/MiniCPM-V-4_6 --local-dir "$MODEL_DIR"

echo "==> Dataset check + image path relocation"
test -f "$DATA_DIR/train.jsonl" || { echo "Missing $DATA_DIR/train.jsonl — extract/rsync the dataset first"; exit 1; }
python3 relocate_dataset.py --data "$DATA_DIR"
python3 validate_dataset.py --data "$DATA_DIR"

echo
echo "READY. Now run:"
echo "  MODEL_PATH=$MODEL_DIR TRAIN_DATA=$DATA_DIR/train.jsonl VALID_DATA=$DATA_DIR/val.jsonl bash run_swift_lora.sh"
