#!/usr/bin/env python3
"""
gen_hardcases.py — генератор СКЛАДНИХ навчальних кейсів для MiniCPM-V 4.6.

Ідея: беремо реальні Godot-кадри як фон і накладаємо на них ВІДОМІ об'єкти
(кольорові маркери + дрібний текст) з керованими ускладненнями: темрява, туман,
розмиття, JPEG-артефакти, часткове перекриття, дрібний масштаб. Оскільки об'єкти
кладемо ми самі — ground truth (кількість, координати 0-1000, колір, текст) ВІДОМИЙ
точно, а не вигадується моделлю. Це і дає чесний benchmark та навчальний набір.

Вихід — ms-swift формат (messages + images + channel), сумісний із туторіалом
MiniCPM-V-CookBook (swift_minicpmv46.md): координати нормовані до 0..1000,
assistant-відповідь із <point>x y</point> і фінальним рахунком.

Split за ВИХІДНОЮ СЦЕНОЮ (не за кадром) — щоб train/val не ділили один фон
(інакше модель просто вивчить фон, а не вміння бачити).

Usage:
  python3 gen_hardcases.py --out data --n-per-scene 12 --seed 7
Залежності: Pillow (є в системі).
"""

from __future__ import annotations

import argparse
import colorsys
import json
import os
import random
from pathlib import Path
from typing import Any

from PIL import (  # type: ignore[import-not-found]
    Image,
    ImageDraw,
    ImageFilter,
    ImageFont,
)

HERE = Path(__file__).resolve().parent
PROJECT_ROOT = HERE.parent.parent.parent  # tools/vision/train -> корінь
SHOTS = PROJECT_ROOT / "screenshots"

# Фони згруповані за СЦЕНОЮ; split ріже за ключем сцени, не за файлом.
SCENE_BACKGROUNDS = {
    "street": ["greyford_street.png", "check_street.png", "crafts_new.png"],
    "tavern": ["tavern_final.png", "tavern_textured_overview.png", "gf_tavern.png"],
    "gate": ["greyford_gate_art_check.png", "gate_final.png", "gf_gate.png"],
    "port": ["gf_port.png", "port_tavern_art_check.png", "test_port.png"],
    "swamp": ["swamp_path_art_check.png", "sonk_ferry_overview.png"],
    "interior": ["alteya_room.png", "rufin_room_art_check.png", "black_archive.png"],
}

# Іменовані кольори з HSV-центрами (для генерації і для перевірки відповіді).
COLORS = {
    "red": 0.00,
    "orange": 0.08,
    "yellow": 0.15,
    "green": 0.33,
    "cyan": 0.50,
    "blue": 0.62,
    "purple": 0.78,
    "magenta": 0.90,
}
WORDS = ["ALE", "KEY", "MAP", "GOLD", "IRON", "SALT", "ROPE", "FISH", "OAK", "TAR"]

DIFFICULTIES = ["dark", "fog", "blur", "jpeg", "occlusion", "tiny", "clean"]


def _font(size: int) -> ImageFont.FreeTypeFont:
    for p in (
        "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
        "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
    ):
        if os.path.isfile(p):
            return ImageFont.truetype(p, size)
    return ImageFont.load_default()


def _hsv_rgb(h: float, s: float = 0.9, v: float = 0.9) -> tuple[int, int, int]:
    r, g, b = colorsys.hsv_to_rgb(h, s, v)
    return int(r * 255), int(g * 255), int(b * 255)


def _place_markers(img: Image.Image, rng: random.Random, difficulty: str) -> dict:
    """Кладе N кольорових маркерів (частина з текстом), повертає ground truth."""
    W, H = img.size
    draw = ImageDraw.Draw(img, "RGBA")
    n = rng.randint(2, 6)
    base_r = 10 if difficulty == "tiny" else rng.randint(16, 30)
    markers: list[dict[str, Any]] = []
    placed_boxes: list[tuple[int, int, int, int]] = []
    tries = 0
    while len(markers) < n and tries < 200:
        tries += 1
        r = base_r + rng.randint(-4, 6)
        cx = rng.randint(r + 5, W - r - 5)
        cy = rng.randint(r + 5, H - r - 5)
        box = (cx - r, cy - r, cx + r, cy + r)
        if any(_overlap(box, b) > 0.35 for b in placed_boxes):
            continue
        placed_boxes.append(box)
        cname = rng.choice(list(COLORS))
        rgb = _hsv_rgb(COLORS[cname] + rng.uniform(-0.02, 0.02))
        draw.ellipse(box, fill=rgb + (255,), outline=(0, 0, 0, 200), width=2)
        word = None
        if rng.random() < 0.45 and difficulty != "tiny":
            word = rng.choice(WORDS)
            f = _font(max(10, r))
            tb = draw.textbbox((0, 0), word, font=f)
            draw.text(
                (cx - (tb[2] - tb[0]) / 2, cy - (tb[3] - tb[1]) / 2),
                word,
                fill=(255, 255, 255, 255),
                font=f,
            )
        markers.append(
            {
                "x_px": cx,
                "y_px": cy,
                "color": cname,
                "text": word,
                "nx": int(cx / W * 1000),
                "ny": int(cy / H * 1000),
            }
        )
    if difficulty == "occlusion":  # перекрити частину сцени темним прямокутником
        ow = rng.randint(W // 5, W // 3)
        ox = rng.randint(0, W - ow)
        draw.rectangle((ox, 0, ox + ow, H), fill=(10, 10, 15, 150))
    return {"markers": markers}


def _overlap(a, b) -> float:
    ax0, ay0, ax1, ay1 = a
    bx0, by0, bx1, by1 = b
    ix = max(0, min(ax1, bx1) - max(ax0, bx0))
    iy = max(0, min(ay1, by1) - max(ay0, by0))
    inter = ix * iy
    ua = (ax1 - ax0) * (ay1 - ay0)
    return inter / ua if ua else 0.0


def _degrade(img: Image.Image, difficulty: str, rng: random.Random) -> Image.Image:
    if difficulty == "dark":
        from PIL import ImageEnhance

        img = ImageEnhance.Brightness(img).enhance(0.30)
    elif difficulty == "fog":
        fog = Image.new("RGB", img.size, (200, 205, 210))
        img = Image.blend(img, fog, 0.45)
    elif difficulty == "blur":
        img = img.filter(ImageFilter.GaussianBlur(rng.uniform(1.5, 3.0)))
    elif difficulty == "tiny":
        img = img.filter(ImageFilter.GaussianBlur(0.6))
    return img


def _save_jpeg_or_png(
    img: Image.Image, path: Path, difficulty: str, rng: random.Random
):
    if difficulty == "jpeg":
        img.save(path.with_suffix(".jpg"), "JPEG", quality=rng.randint(15, 30))
        return path.with_suffix(".jpg")
    img.save(path, "PNG")
    return path


def _answer(gt: dict) -> str:
    ms = gt["markers"]
    pts = ", ".join(f"<point>{m['nx']} {m['ny']}</point>" for m in ms)
    colors = ", ".join(m["color"] for m in ms)
    texts = [m["text"] for m in ms if m["text"]]
    txt = ("Visible labels: " + ", ".join(texts) + ". ") if texts else "No labels. "
    return (
        f"<think>\n\n</think>\n\nMarker coordinates: {pts}. "
        f"Colors in order: {colors}. {txt}So the total count is {len(ms)}."
    )


QUESTION = (
    "<image>\nCarefully inspect this game frame, including dark, foggy, blurry "
    "or partly hidden regions. List every colored marker as <point>x y</point> "
    "(coords normalized 0-1000), then its color, any short text on it, and the "
    "total count."
)


def build(out: Path, n_per_scene: int, seed: int) -> dict:
    rng = random.Random(seed)
    img_out = out / "images"
    img_out.mkdir(parents=True, exist_ok=True)
    # scene-disjoint split: 2/3 сцен -> train, 1/3 -> val (детерміновано)
    scenes = sorted(SCENE_BACKGROUNDS)
    val_scenes = set(scenes[::3])  # кожна третя сцена -> val
    rows: dict[str, list[dict[str, Any]]] = {"train": [], "val": []}
    stats: dict[str, Any] = {"train": {}, "val": {}, "skipped_missing": []}
    idx = 0
    for scene in scenes:
        split = "val" if scene in val_scenes else "train"
        backs = [SHOTS / b for b in SCENE_BACKGROUNDS[scene]]
        backs = [b for b in backs if b.is_file()]
        if not backs:
            stats["skipped_missing"].append(scene)
            continue
        for i in range(n_per_scene):
            diff = DIFFICULTIES[i % len(DIFFICULTIES)]
            bg = rng.choice(backs)
            base = Image.open(bg).convert("RGB")
            gt = _place_markers(base, rng, diff)
            base = _degrade(base, diff, rng)
            stem = f"{scene}_{diff}_{idx:04d}"
            saved = _save_jpeg_or_png(base, img_out / (stem + ".png"), diff, rng)
            rows[split].append(
                {
                    "messages": [
                        {"role": "user", "content": QUESTION},
                        {"role": "assistant", "content": _answer(gt)},
                    ],
                    "images": [str(saved.resolve())],
                    "channel": scene,
                    "difficulty": diff,
                    "ground_truth": gt,
                    "source_bg": bg.name,
                }
            )
            stats[split][diff] = stats[split].get(diff, 0) + 1
            idx += 1
    for split in ("train", "val"):
        with open(out / f"{split}.jsonl", "w", encoding="utf-8") as f:
            f.writelines(json.dumps(r, ensure_ascii=False) + "\n" for r in rows[split])
    summary = {
        "train": len(rows["train"]),
        "val": len(rows["val"]),
        "val_scenes": sorted(val_scenes),
        "by_difficulty": stats,
        "out": str(out.resolve()),
    }
    with open(out / "summary.json", "w", encoding="utf-8") as f:
        json.dump(summary, f, ensure_ascii=False, indent=2)
    return summary


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default=str(HERE / "data"))
    ap.add_argument("--n-per-scene", type=int, default=12)
    ap.add_argument("--seed", type=int, default=7)
    a = ap.parse_args()
    s = build(Path(a.out), a.n_per_scene, a.seed)
    print(json.dumps(s, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
