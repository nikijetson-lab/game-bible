# Meshy → Godot: конвеєр анімованих NPC (Hazemoor)

Повторюваний, економний процес перетворення статичного Meshy-персонажа у rigged NPC
з `walk`/`idle` анімацією в Godot. Двигун проєкту: **Godot 4.7** (не 4.3).

> Правило бюджету: **~40 кредитів на персонажа**. Ніколи не генерувати всіх NPC
> одразу — спершу 1 пілот, візуальна перевірка, тоді масштабування.

---

## 0. Перед-політ (0 кредитів, обовʼязково)

1. **Перевірити баланс:** `meshy_check_balance`.
2. **Знайти концепт/референс** (пріоритет: юзер > концепт-арт > `D:\артефакти з чату гри` > AI).
3. **Перевірити поточний GLB** локальним скриптом — faces / skins / animations:

```python
import struct, json
with open(path,'rb') as f:
    assert f.read(4)==b'glTF'; f.read(8)
    clen=struct.unpack('<I',f.read(4))[0]; f.read(4)
    d=json.loads(f.read(clen))
faces=sum(d['accessors'][p['indices']]['count']//3
          for m in d.get('meshes',[]) for p in m.get('primitives',[]) if p.get('indices') is not None)
print('faces',faces,'skins',len(d.get('skins',[])),'anims',[a.get('name') for a in d.get('animations',[])])
```

- `skins=0, animations=[]` → модель **статична**, потребує rig.
- `faces > 300000` → **обовʼязковий remesh** перед rig (Meshy Rig відхиляє >300k).

### Реальний стан NPC Hazemoor (аудит 2026-07)

| NPC | Сцена | Faces | Rig | Дія |
|---|---|---:|:--:|---|
| waitress | `TavernInterior.tscn` | 31 225 | ❌ | rig напряму (rig-ready) |
| drunk/merchant/oldwoman patron | `TavernInterior.tscn` | ~31k | ❌ | rig напряму або staging-tween |
| port_bartender | `PortTavernInterior.tscn` | 400 906 | ❌ | **remesh→50k**, тоді rig |
| Tessa | `BlackArchive.tscn` | 891 936 | ❌ | **remesh→50k**, тоді rig |
| greyford_guard_walk | `TavernInterior.tscn` | 48 740 | ✅ | еталон (skins=1, walk anim) |

---

## 1. Генерація моделі

**Якщо є референс-фото/концепт → image-to-3d (краща схожість):**
```
meshy_image_to_3d(file_path=..., ai_model="meshy-6", pose_mode="t-pose")   # 30cr, вже текстурований
```

**Якщо тільки текст → text-to-3d + refine:**
```
meshy_text_to_3d(prompt="... in T-pose for rigging", ai_model="meshy-6", pose_mode="t-pose")  # 20cr
meshy_text_to_3d_refine(preview_task_id=..., ai_model="meshy-6", texture_prompt="...")          # 10cr
```

> **CRITICAL:** завжди `pose_mode="t-pose"` — A-pose ригається погано.

## 2. Remesh (лише якщо faces > ~300k)

```
meshy_remesh(input_task_id=<refined>, target_polycount=50000, topology="triangle")   # 5cr
```
Meshy 6 стабільно видає 400–550k faces — для bartender/Tessa цей крок обовʼязковий.
Для 31k-моделей (waitress, патрони) — пропустити.

## 3. Rig (5cr, walk+run безкоштовно)

```
meshy_rig(input_task_id=<remeshed_or_lowpoly>, height_meters=1.7)   # 5cr
```
Видає: rigged GLB (T-pose) + `Animation_Walking_withSkin.glb` + `Animation_Running_withSkin.glb`.

**Кастомні анімації** (idle-варіанти, wiping тощо) = `meshy_animate` (3cr). Для базового NPC
walk достатньо; idle реалізуємо через зупинку на walk-кліпі (див. п.6).

## 4. Завантаження (URL живуть 24 год!)

```
meshy_download_model(task_id=<rig>, task_type="rigging", format="glb")
```
Зберігати у `assets/meshy/<location>/<name>_walk.glb`. Качати ОДРАЗУ.

## 5. Інтеграція у сцену (.tscn)

1. `[ext_resource type="PackedScene" path="res://assets/meshy/.../name_walk.glb" id="NN_glb"]`
   — **до** першого `[node]`, наступний вільний id.
2. Приховати blockout: старому `Body`/капсулі додати `visible = false` (колізію лишити).
3. Додати інстанс під `Area3D` NPC:
```tscn
[node name="MeshyWaitressModel" parent="NPCs/Waitress" instance=ExtResource("NN_glb")]
transform = Transform3D(0.72, 0, 0, 0, 0.98, 0, 0, 0, 0.82, 0, Y, 0)
```
   - **Y-offset:** статична модель з center-origin → `Y = 0.85`.
   - **Rigged/walk GLB** має інший pivot → починати з `Y = -0.95` (як `MeshyGuardModel`),
     не ставити 0.85 наосліп; діагностувати через render.

## 6. Код руху/анімації (WaitressPatrol.gd — еталон)

Скрипт `scripts/gameplay/WaitressPatrol.gd` вже готовий і безпечний:
- рекурсивно шукає `AnimationPlayer` у моделі;
- `play("walk")` під час руху, `play("idle")` на waypoint;
- `_resolve_animation_name()` матчить точну назву АБО підрядок
  (Meshy `Armature|walking_man|baselayer` → "walk");
- на статичному GLB без AnimationPlayer — **чистий no-op**.

**Idle з walk-кліпа** (коли окремого idle нема): `play(clip)` → `seek(t, true)` → `pause()`
на нейтральному кадрі — дешева заміна кастомної idle-анімації.

## 7. Обовʼязкова верифікація (після кожного пілота)

1. **Import pass** (генерує `.import`/`.uid`), інакше сцена не завантажить GLB:
```bash
powershell.exe -NoProfile -Command "& 'C:\\Users\\38067\\AppData\\Local\\Microsoft\\WinGet\\Links\\godot.exe' --headless --editor --quit --path 'E:\\Hazemoor\\game-bible\\godot-project'"
```
   > При **заміні** наявного GLB — спершу почистити import-кеш, інакше рендериться старий.
2. **Smoke:**
```bash
powershell.exe -NoProfile -Command "& 'godot.exe' --headless --path 'E:\\Hazemoor\\game-bible\\godot-project' --script 'res://tests/smoke_load_scenes.gd'"
```
   Очікувано: `SMOKE RESULT: N OK, 0 FAIL`.
3. **Віконний render** (шаблон `tests/render_*.gd`: Camera3D + `call_deferred`, ~18–28 кадрів,
   save_png) → `vision_analyze` скріншота: ноги на підлозі, руки рухаються вільно й не тягнуть
   торс/плащ, борода/шолом відповідають референсу.

## Кредитний кошторис

| Крок | image-to-3d | text-to-3d |
|---|---:|---:|
| Генерація | 30 | 20 |
| Refine | — | 10 |
| Remesh (за потреби) | 5 | 5 |
| Rig (walk+run вкл.) | 5 | 5 |
| **Разом** | **~40** | **~40** |

## Пастки (з реальних сесій)

- **Meshy 6 faces завжди >300k** для генерованих з нуля — remesh не пропускати для важких.
- **Rig коштує 5cr** (не «безкоштовно»), безкоштовні лише walk/run поверх нього.
- **URL качати за 24 год**, інакше task губиться → нова генерація.
- **ext_resource тільки до [node]**, інакше parse error.
- **Meshy-біас:** борода чоловікам, шолом+срібна броня вартовим — гасити через image-to-3d
  + явні негативи; звірятись із правильним референсом ПЕРЕД тратою кредитів.
- **T-pose руки у walk** — системна вада Meshy-rig; фікс лише кастом-анімацією або вручну.
- **search_files по .tscn** може давати хибні 0 (кодування/UID) — звіряти прямим читанням
  або Python-сканом файлів.
