# Hazemoor Vision — fine-tuning MiniCPM-V 4.6 на складних кадрах

Мета: навчити модель бачити дрібні/затемнені/розмиті об'єкти на кадрах гри
краще за стоковий MiniCPM-V 4.6. Весь пайплайн детермінований і оцінюється
одним scorer'ом без LLM-судді.

## Файли

| Файл                     | Що робить                                                                                                                                                  |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `gen_hardcases.py`       | Кладе ВІДОМІ кольорові маркери+текст на реальні кадри з `screenshots/`. Ground truth точний (координати 0-1000, колір, текст, лічильник). Split за сценою. |
| `validate_dataset.py`    | Перевіряє схему, наявність зображень, узгодженість GT↔answer і **scene-disjoint** split (без витоку фону train↔val).                                       |
| `score_predictions.py`   | Детермінований scorer: count accuracy, point F1 (@ поріг), color F1, OCR F1, composite.                                                                    |
| `run_baseline_ollama.py` | Baseline інференс локальної `minicpm-v4.6:latest` через Ollama → `predictions.jsonl`.                                                                      |
| `run_swift_lora.sh`      | LoRA/QLoRA launcher (ms-swift, `minicpmv4_6`) для NVIDIA-боксу.                                                                                            |
| `cloud_bootstrap.sh`     | Ставить env+ваги+ms-swift на свіжому GPU-боксі, валідує датасет, друкує команду запуску.                                                                   |
| `test_*.py`              | Regression-тести генератора, scorer'а і валідатора.                                                                                                        |

## 0. Локально: згенерувати датасет і baseline

```bash
cd tools/vision/train
python3 gen_hardcases.py --out /mnt/e/hazemoor-vision/data --n-per-scene 96 --seed 7
python3 validate_dataset.py --data /mnt/e/hazemoor-vision/data          # має бути valid:true
python3 -m pytest . -q                                                   # усі тести зелені
# baseline (повільно на CPU, ~2 хв/кадр) — робиться ЛОКАЛЬНО, не на платному GPU:
python3 run_baseline_ollama.py --dataset /mnt/e/hazemoor-vision/data/val.jsonl \
  --out /mnt/e/hazemoor-vision/out/baseline_pred.jsonl
python3 score_predictions.py --pred /mnt/e/hazemoor-vision/out/baseline_pred.jsonl \
  --gt /mnt/e/hazemoor-vision/data/val.jsonl
```

## 1. Перенести на GPU-бокс

Потрібен NVIDIA GPU: **≥24 ГБ** для bf16 LoRA, або **≥12-16 ГБ** для QLoRA (`QLORA=1`).
Локальний ноут не тягне — GPU відсутній, RAM недостатня.

```bash
# на локальній машині:
rsync -a /mnt/e/hazemoor-vision/data/  user@box:~/hazemoor-vision/data/
scp tools/vision/train/*.sh tools/vision/train/*.py tools/vision/train/*.md \
    user@box:~/hazemoor-vision/train/
```

## 2. Bootstrap + тренування на боксі

```bash
cd ~/hazemoor-vision/train
# HF_TOKEN опційний: модель публічна; токен лише допомагає з rate limits
export DATA_DIR=~/hazemoor-vision/data
bash cloud_bootstrap.sh          # env, ваги openbmb/MiniCPM-V-4_6, ms-swift, валідація

# bf16 LoRA (≥24GB):
MODEL_PATH=~/MiniCPM-V-4_6 \
  TRAIN_DATA=$DATA_DIR/train.jsonl VALID_DATA=$DATA_DIR/val.jsonl \
  bash run_swift_lora.sh

# або QLoRA (≤16GB):
QLORA=1 MODEL_PATH=~/MiniCPM-V-4_6 \
  TRAIN_DATA=$DATA_DIR/train.jsonl VALID_DATA=$DATA_DIR/val.jsonl \
  bash run_swift_lora.sh
```

Опційно live-криві: `export WANDB_API_KEY=... REPORT_TO=wandb`.

## 3. Оцінка після тренування (те саме мірило, що й baseline)

1. Запустити `swift infer` на tuned checkpoint із `--result_path swift_infer.jsonl`
   і тим самим `val.jsonl`/QUESTION-промптом.
2. Перетворити результат: `python3 swift_result_to_pred.py --input swift_infer.jsonl --output tuned_pred.jsonl`.
3. Оцінити: `python3 score_predictions.py --pred tuned_pred.jsonl --gt val.jsonl`.
4. Порівняти composite baseline vs tuned. Очікуваний приріст — за рахунок
   дотримання формату `<point>x y</point>` + count (baseline його ігнорує).

## Правила, які не можна порушувати

- Ground truth генерує `gen_hardcases.py`, **не** модель, що оцінюється.
- Train/val **scene-disjoint** (`validate_dataset.py` це гейтить).
- Baseline і tuned оцінюються **однаковим** scorer'ом, без LLM-судді.
- Тренувальна база — оригінальні ваги `openbmb/MiniCPM-V-4_6`, не Ollama-квант.
