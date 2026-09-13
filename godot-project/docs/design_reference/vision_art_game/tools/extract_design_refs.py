#!/usr/bin/env python3
"""Extract foreground art from the Hazemoor PDF and map captions globally."""
from __future__ import annotations

import io
import json
import re
from pathlib import Path

import fitz
from PIL import Image

PDF = Path("/mnt/d/vision art game.pdf")
REPO = Path("/mnt/e/Hazemoor/game-bible/godot-project")
OUT = REPO / "docs" / "design_reference" / "vision_art_game" / "images"
MANIFEST = OUT.parent / "manifest.json"

TRANSLIT = str.maketrans({
    "а":"a","б":"b","в":"v","г":"h","ґ":"g","д":"d","е":"e","є":"ie","ж":"zh","з":"z","и":"y","і":"i","ї":"i","й":"i","к":"k","л":"l","м":"m","н":"n","о":"o","п":"p","р":"r","с":"s","т":"t","у":"u","ф":"f","х":"kh","ц":"ts","ч":"ch","ш":"sh","щ":"shch","ь":"","ю":"iu","я":"ia",
})

def slug(text: str) -> str:
    s = text.lower().translate(TRANSLIT)
    s = re.sub(r"\([^)]*\)", "", s)
    s = s.replace("/", " ")
    s = re.sub(r"[^a-z0-9]+", "-", s).strip("-")
    return s[:72] or "untitled"


def block_text(block: dict) -> str:
    lines = []
    for line in block.get("lines", []):
        lines.append("".join(span["text"] for span in line.get("spans", [])))
    return " ".join(x.strip() for x in lines if x.strip()).strip()


def normalized_caption(parts: list[str]) -> str:
    return re.sub(r"\s+", " ", " ".join(parts)).strip()


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    doc = fitz.open(PDF)
    pending: dict | None = None
    records: list[dict] = []
    serial = 0

    for page_no, page in enumerate(doc, 1):
        blocks = page.get_text("dict")["blocks"]
        for block in blocks:
            if block["type"] == 1:
                x0, y0, x1, y1 = block["bbox"]
                # Full-page texture/background, not concept art.
                if x0 <= 1 and y0 <= 1 and x1 >= page.rect.width - 1 and y1 >= page.rect.height - 1:
                    continue
                if pending is not None:
                    records.append(pending)
                serial += 1
                pending = {
                    "id": serial,
                    "image_page": page_no,
                    "bbox": [round(v, 2) for v in block["bbox"]],
                    "caption_parts": [],
                    "image_bytes": block["image"],
                }
            elif pending is not None:
                txt = block_text(block)
                if txt:
                    pending["caption_parts"].append(txt)
        # pending deliberately carries across a page boundary: some captions
        # are printed at the top of the following page.

    if pending is not None:
        records.append(pending)

    output = []
    seen: dict[str, int] = {}
    for rec in records:
        caption = normalized_caption(rec.pop("caption_parts"))
        base = slug(caption)
        seen[base] = seen.get(base, 0) + 1
        suffix = f"-{seen[base]}" if seen[base] > 1 else ""
        filename = f"{rec['id']:02d}-p{rec['image_page']:02d}-{base}{suffix}.jpg"
        dest = OUT / filename
        with Image.open(io.BytesIO(rec.pop("image_bytes"))) as im:
            im = im.convert("RGB")
            if im.width > 960:
                h = round(im.height * 960 / im.width)
                im = im.resize((960, h), Image.Resampling.LANCZOS)
            im.save(dest, "JPEG", quality=86, optimize=True, progressive=True)
        output.append({
            **rec,
            "caption": caption,
            "image": f"images/{filename}",
            "width": im.width,
            "height": im.height,
            "bytes": dest.stat().st_size,
        })

    MANIFEST.write_text(json.dumps(output, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"pages={doc.page_count} concepts={len(output)} bytes={sum(x['bytes'] for x in output)}")
    for x in output:
        print(f"{x['id']:02d} p{x['image_page']:02d} {x['caption']} -> {x['image']}")

if __name__ == "__main__":
    main()
