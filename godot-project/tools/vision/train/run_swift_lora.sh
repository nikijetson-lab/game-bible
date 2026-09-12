#!/usr/bin/env bash
# MiniCPM-V 4.6 LoRA fine-tuning launcher for the Hazemoor hard-cases dataset.
# Run on an external NVIDIA GPU box (>=24GB for LoRA, bf16). NOT runnable on this laptop.
#
# Prereqs (see MiniCPM-V CookBook / ms-swift):
#   conda create -n mcpmv46 python=3.10 -y && conda activate mcpmv46
#   pip install torch==2.8.0 torchvision==0.23.0
#   pip install transformers==5.7.0 accelerate==1.13.0 deepspeed==0.18.3 \
#       peft==0.18.1 trl==0.24.0 wandb ninja einops safetensors tokenizers sentencepiece
#   MAX_JOBS=32 pip install --no-build-isolation flash-attn==2.8.3
#   git clone https://github.com/modelscope/ms-swift.git && cd ms-swift && pip install -e .
#   pip install transformers==5.7.0     # ensure final version >=5.7.0
#
# Download weights first (model is public; HF_TOKEN is optional):
#   hf download openbmb/MiniCPM-V-4_6 --local-dir ./MiniCPM-V-4_6
set -euo pipefail

export CUDA_VISIBLE_DEVICES="${CUDA_VISIBLE_DEVICES:-0}"
export NPROC_PER_NODE="${NPROC_PER_NODE:-1}"
export MASTER_PORT="${MASTER_PORT:-29632}"
export DOWNSAMPLE_MODE="${DOWNSAMPLE_MODE:-4x}"   # 4x = higher detail (better on hard frames), 16x = cheaper

# QLoRA=1 -> 4-bit bitsandbytes base (fits ~10-16GB VRAM, ~same quality, slower).
# QLoRA=0 (default) -> bf16 LoRA (needs ~24GB VRAM, faster).
QLORA="${QLORA:-0}"
QUANT_ARGS=()
if [ "${QLORA}" = "1" ]; then
  QUANT_ARGS=(--quant_method bnb --quant_bits 4 --bnb_4bit_compute_dtype bfloat16)
  echo "==> QLoRA mode: 4-bit bnb base"
fi

SWIFT_BIN="${SWIFT_BIN:-swift}"
MODEL_PATH="${MODEL_PATH:-./MiniCPM-V-4_6}"
TRAIN_DATA="${TRAIN_DATA:-/mnt/e/hazemoor-vision/data/train.jsonl}"
VALID_DATA="${VALID_DATA:-/mnt/e/hazemoor-vision/data/val.jsonl}"
OUTPUT_DIR="${OUTPUT_DIR:-/mnt/e/hazemoor-vision/out/lora_mcpmv46}"

# Optional experiment tracking:
export WANDB_API_KEY="${WANDB_API_KEY:-}"
export WANDB_PROJECT="${WANDB_PROJECT:-Hazemoor-MCPMV46}"
export WANDB_RUN_NAME="${WANDB_RUN_NAME:-hazemoor_hardcases_lora}"
REPORT_TO="${REPORT_TO:-none}"   # set to 'wandb' when WANDB_API_KEY is present

"${SWIFT_BIN}" sft \
  --model "${MODEL_PATH}" \
  --model_type minicpmv4_6 \
  --template minicpmv4_6 \
  --add_non_thinking_prefix true \
  --dataset "${TRAIN_DATA}" \
  --val_dataset "${VALID_DATA}" \
  --tuner_type lora \
  --lora_rank 16 \
  --lora_alpha 32 \
  --freeze_vit true \
  --torch_dtype bfloat16 \
  "${QUANT_ARGS[@]}" \
  --attn_impl flash_attn \
  --packing false \
  --max_length 4096 \
  --num_train_epochs 8 \
  --per_device_train_batch_size 1 \
  --gradient_accumulation_steps 8 \
  --learning_rate 1e-4 \
  --warmup_ratio 0.05 \
  --logging_steps 1 \
  --eval_strategy steps \
  --eval_steps 20 \
  --save_steps 20 \
  --save_total_limit 5 \
  --dataset_num_proc 8 \
  --dataloader_num_workers 8 \
  --loss_scale ignore_empty_think \
  --output_dir "${OUTPUT_DIR}" \
  --run_name "${WANDB_RUN_NAME}" \
  --report_to "${REPORT_TO}"

echo "LoRA adapters saved under: ${OUTPUT_DIR}"
