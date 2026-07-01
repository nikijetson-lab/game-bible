# ANIMATION_CLIPS_GUIDE.md 
 
## Керування анімаційними клипами для Hazemoor 
 
> Які анімації потрібні, як структурувати FBX, як налаштувати Godot 
 
--- 
 
## 1. Анімації для Player 
 
### Основні группи 
 
#### Locomotion (рух) 
``` 
idle_01, idle_02         (0-2 сек) 
walk_forward             (0-1 сек) 
walk_backward            (0-1 сек) 
run_forward              (0-0.8 сек) 
sprint_forward           (0-0.6 сек) 
strafe_left, strafe_right 
``` 
 
#### Combat (майбутнє) 
``` 
attack_light_01, attack_light_02, attack_light_03 
attack_heavy 
block 
damage_light, damage_heavy 
death 
``` 
 
#### Special 
``` 
dodge_roll_forward       (0-0.6 сек) 
dodge_roll_left/right 
fall                     (0-1.2 сек) 
landing 
``` 
 
#### Interact 
``` 
interact_pick_item       (0-1 сек) 
interact_use_lever 
interact_talk            (0-1 сек) 
``` 
 
### Структура у Blender 
 
``` 
Armature (skeleton) 
├─ Player (mesh) 
├─ Actions (анімації у Blender) 

│  ├─ idle_01 (frame 0-30 @ 30FPS = 1 сек) 
│  ├─ idle_02 (frame 30-60) 
│  ├─ walk_forward (frame 60-90) 
│  └─ ... 
└─ [Export як FBX] 
``` 
 
### FBX Export Settings 
 
У Blender → File → Export → FBX: 
 
``` 
✓ Animation 
✓ Bake Animation 
  Frame Start: 0 
  Frame End: 120 (або кількість frame'ів) 
✓ Deform Bones 
✓ Leaf Bones: OFF (для FBX) 
FPS: 30 (ВАЖЛИВО!) 
``` 
 
--- 
 
## 2. Анімації для NPC 
 
### Мінімум для базового NPC 
 
``` 
idle_01, idle_02, idle_03    (3-4 сек кожна) 
talking                      (0-2 сек, lip sync) 
positive_reaction            (0-1 сек) 
negative_reaction            (0-1 сек) 
walk_forward                 (0-1 сек) 
``` 
 
### Приклад: Ervan 
 
``` 
Blender Actions: 
├─ idle_bartender_01 (30 frame) 
├─ idle_bartender_02 (40 frame) 
├─ talking_to_customer (45 frame) 
├─ gesture_positive (20 frame) 
├─ gesture_negative (25 frame) 
└─ walk_behind_counter (30 frame) 
``` 
 
--- 
 
## 3. FBX до Godot Pipeline 
 
### Крок 1: Експорт з Meshy/Blender 
 
```bash 
# Meshy AI експортує: 
player_character.fbx (все в одному файлі) 
 
# У Blender розбиваємо на окремі Actions: 
# Якщо всі анімації в одному файлі (за frame'ами) 
# то FBX імпортер Godot знайде їх автоматично 
``` 
 

### Крок 2: Імпорт в Godot 
 
1. Скопіюй .fbx у `res://assets/models/characters/` 
2. Натисни на файл в Project panel 
3. Inspector → Import tab 
4. Налаштуй: 
   ``` 
   Animations → FPS: 30 
   Animations → Group Tracks: ON 
   Animations → Bake Reset Animation: ON 
   ``` 
5. Натисни **Reimport** 
 
### Крок 3: Перевірка анімацій 
 
1. Натисни на експортований `.res` або `.glb` файл 
2. Inspector → Animation tab 
3. Побачиш список анімацій: 
   ``` 
   idle (0s - 1s) 
   walk (1s - 2.5s) 
   run (2.5s - 4s) 
   attack (4s - 5.5s) 
   ``` 
 
--- 
 
## 4. Налаштування в AnimationTree 
 
### Структура State Machine 
 
``` 
[idle] ←→ [walk] ←→ [run] 
  ↓        ↓        ↓ 
[attack] [attack] [attack] 
 
[dodge_roll] (з будь-якого стану) 
[fall] 
[landing] 
``` 
 
### BlendSpace1D для Locomotion 
 
``` 
idle (0.0) → walk (0.5) → run (1.0) 
``` 
 
### Sync з PlayerController 
 
```gdscript 
# У PlayerController._physics_process(): 
 
var speed_blend = clamp(current_speed / sprint_speed, 0.0, 1.0) 
animation_tree.set("parameters/Locomotion/blend_position", speed_blend) 
 
# Це автоматично переміщує ползунок BlendSpace 
# від idle → walk → run залежно від швидкості 
``` 
 
--- 
 
## 5. Optimizations 
 

### Compression 
 
``` 
# У Inspector для FBX імпорту: 
# Anim → Compress (OFF для тестування, ON для релізу) 
``` 
 
### Culling Optimization 
 
```gdscript 
# Не анімуй дальніх персонажів: 
 
if distance_to_player > 50: 
    # Дальше 50м → не анімуй, просто покажи статичну позу 
    animation_player.stop() 
else: 
    # Близько → грай анімацію нормально 
    animation_tree.active = true 
``` 
 
--- 
 
## 6. Voice Acting Sync 
 
### Lip Sync (майбутнє) 
 
```gdscript 
# Для діалогів: 
# ElevenLabs TTS повинна експортувати VITS рівень для lip-sync 
# Потім синхронізуємо mouth bones в Blender 
 
# ПОКИ: просто грай talking анімацію під час діалогу 
npc.play_animation("talking") 
await dialogue_manager.play_voice_line("voice_file.mp3") 
npc.play_animation("idle") 
``` 
 
--- 
 
## 7. Common Issues & Solutions 
 
### Проблема: Анімація не грає 
 
**Рішення:** 
1. Перевір FPS при імпорту (має дорівнювати експорту) 
2. Перевір, чи є animation name в AnimationPlayer 
3. Перевір AnimationTree Active = ON 
 
### Проблема: Різкі переходи між анімаціями 
 
**Рішення:** 
1. Налаштуй перехід в State Machine: 
   - Switch Mode: "At End" (чекати до кінця анімації) 
2. Додай BlendSpace1D для гладких переходів 
 
### Проблема: Низька якість анімації 
 
**Рішення:** 
1. Збільш FPS при екс порту (60 замість 30) 
2. Збільш кількість frame'ів (детальніша анімація) 
3. Перевір Blender → Export сетінги (всі кістки експортовані?) 
 
--- 

 
## 8. Best Practices 
 
-   Кожна анімація = 0.5-2 сек (не дуже довгі) 
-   Idle анімації = 2-4 сек (для реалізму) 
-   Переходи = 0.2-0.5 сек (розумні) 
-   FPS = 30 (стандарт для game dev) 
-   Крок за кроком (не всі анімації раз) 
-   НЕ: робити одну фонову анімацію для всього 
-   НЕ: забувати про exit animation (смерть, падіння) 
 
--- 
 
## 9. Animation Clips Checklist 
 
### Player 
 
- [ ] idle (мінімум 2 варіанти) 
- [ ] walk 
- [ ] run 
- [ ] sprint 
- [ ] dodge_roll (forward, left, right) 
- [ ] fall 
- [ ] landing 
- [ ] interact_pick 
- [ ] interact_talk 
- [ ] damage_light 
- [ ] death 
- [ ] attack_light (future) 
- [ ] block (future) 
 
### NPC (Ervan) 
 
- [ ] idle (2 варіанти) 
- [ ] talking 
- [ ] positive_reaction 
- [ ] negative_reaction 
- [ ] walk 
- [ ] wave_greeting 
 
### Менше для других NPC 
 
- [ ] idle (1-2) 
- [ ] talking 
- [ ] reaction (positive/negative)
