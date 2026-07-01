# ANIMATION_TREE_SETUP.md 
## Повний гайд налаштування AnimationTree для Hazemoor 
 
> Цей документ описує крок-за-кроком як імпортувати FBX анімації, 
налаштувати AnimationTree та синхронізувати з PlayerController і NPC 
 
--- 
 
##   ЗМІСТ 
 

1. [Імпорт FBX анімацій](#1-імпорт-fbx-анімацій) 
2. [Структура AnimationTree](#2-структура-animationtree) 
3. [Налаштування для Player](#3-налаштування-для-player) 
4. [Налаштування для NPC](#4-налаштування-для-npc) 
5. [BlendSpace1D для locomotion](#5-blendspace1d-для-locomotion) 
6. [AnimationPlayback state machine](#6-animationplayback-state-machine) 
7. [Синхронізація з PlayerController](#7-синхронізація-з-
playercontroller) 
8. [Дебагування анімацій](#8-дебагування-анімацій) 
 
--- 
 
## 1. Імпорт FBX анімацій 
 
### Крок 1.1: Отримання FBX файлу 
 
FBX файл з Meshy AI має структуру: 
``` 
player_character.fbx 
├── Armature (skeleton) 
├── Mesh (вертекси і полігони) 
└── Animations 
    ├── idle (0-30 frame) 
    ├── walk (30-60 frame) 
    ├── run (60-90 frame) 
    ├── attack (90-120 frame) 
    └── ... інші анімації 
``` 
 
### Крок 1.2: Копіювання в проект 
 
```bash 
# Скопіюй FBX файл у res://assets/models/characters/ 
mkdir -p res://assets/models/characters 
cp player_character.fbx res://assets/models/characters/ 
``` 
 
### Крок 1.3: Імпорт в Godot 
 
1. Відкрий Godot Editor 
2. Перейди до папки `res://assets/models/characters/` 
3. Побачиш `player_character.fbx` у Project панелі 
4. Натисни на FBX файл → Inspector (права панель) 
5. Вибери вкладку **Import** (на верхній панелі Editor) 
 
### Крок 1.4: Налаштування Import параметрів 
 
**Важливі параметри:** 
 
``` 
Materials → Location: Mesh 
Materials → Reimport: ON 
 
Meshes → Generate LODs: OFF (поки) 
Meshes → Root Name: (залиш як є) 
Meshes → Root Type: Node3D 
 
Meshes → Skins: ON (якщо є skin weights для деформацій) 
 
Gizmos → Import: ON 
 
Animations → FPS: 30 (ВАЖЛИВО! має дорівнювати FPS експорту) 
Animations → Bake Reset Animation: ON 

Animations → Group Tracks: ON 
Animations → Optimize: OFF (поки) 
Reimport Tracks: ON 
 
Meshes → Ensure Tangents: ON 
``` 
 
### Крок 1.5: Натисни "Reimport" 
 
Godot конвертує FBX у `.glb` ( 3D модель) і `.res` (ресурс Godot). 
 
Процес займає 10-30 сек. 
 
**Результат:** 
``` 
res://assets/models/characters/ 
├── player_character.fbx (оригіналь) 
├── player_character.glb (конвертована модель) 
└── player_character.res (Godot ресурс) 
``` 
 
### Крок 1.6: Перевірка анімацій 
 
1. Натисни на `player_character.glb` або `.res` 
2. Inspector → вкладка **3D** або **Animation** 
3. Побачиш список анімацій: 
   ``` 
   ✓ idle (0s - 1s) 
   ✓ walk (1s - 2.5s) 
   ✓ run (2.5s - 4s) 
   ✓ attack (4s - 5s) 
   ``` 
 
Якщо анімацій не видно: 
- Перевір FPS параметр (має дорівнювати експорту) 
- Перевір, чи анімаціям в FBX дані правильні імена 
- Переробляй з Blender (якщо потрібно відрегулювати) 
 
--- 
 
## 2. Структура AnimationTree 
 
AnimationTree — це граф станів, який керує анімаціями. 
 
### Структура вузла: 
 
``` 
Player (CharacterBody3D) 
├── AnimationPlayer ← ЦЕ НЕ AnimationTree! 
│   └─ Master (播放實際動畫) 
└── AnimationTree ← ЦЕ управляє станами 
    └─ Anim Player: (посилання на AnimationPlayer) 
    └─ Anim Root: (StateMachine або BlendSpace) 
``` 
 
**AnimationPlayer** — низько-рівневий плеєр анімацій 
**AnimationTree** — високо-рівневий керувач станів 
 
### Три типи графів: 
 
1. **StateMachine** (для персонажів) — найпопулярніший 
   ``` 

   idle ←→ walk ←→ run 
    ↓      ↓      ↓ 
   attack  attack attack 
   ``` 
 
2. **BlendSpace1D** (для гладкого переходу) 
   ``` 
   idle (0.0) → walk (0.5) → run (1.0) 
   ``` 
 
3. **BlendSpace2D** (для 2D рухів) 
   ``` 
   forward-left    forward    forward-right 
                    ↑              
   left ← idle → right 
                    ↓              
   backward-left backward backward-right 
   ``` 
 
Для **Player** в Hazemoor: 
- Основний граф: **StateMachine** (idle, walk, run, sprint, dodge, 
attack) 
- Внутрішня система: **BlendSpace1D** для переходу idle ↔ walk ↔ run 
 
--- 
 
## 3. Налаштування для Player 
 
### Крок 3.1: Створити AnimationPlayer 
 
1. Вибери Player (CharacterBody3D) 
2. Натисни + → Add Child → AnimationPlayer 
3. Назви: `AnimationPlayer` 
 
### Крок 3.2: Завантажити FBX до AnimationPlayer 
 
1. Вибери AnimationPlayer 
2. Inspector → Animation property 
3. Натисни на папку (Load existing) 
4. Вибери `res://assets/models/characters/player_character.res` (або 
`.glb`) 
 
Godot автоматично завантажить ВСІ анімації. 
 
### Крок 3.3: Створити AnimationTree 
 
1. Вибери Player (CharacterBody3D) 
2. Натисни + → Add Child → AnimationTree 
3. Назви: `AnimationTree` 
 
### Крок 3.4: Налаштування AnimationTree у Inspector 
 
1. Вибери AnimationTree у Scene дереві 
2. Inspector → Animation Tree property 
3. Натисни "New AnimationNodeStateMachine" 
4. У Property натисни на ресурс, щоб його редагувати 
 
### Крок 3.5: Редагування State Machine 
 
Двічі натисни на AnimationTree ресурс (або натисни "Edit" в Inspector). 
 
**Граф станів для Player:** 
 

``` 
[idle] ←— walk_animation ←— [walk] 
  ↑                          ↓ 
  └———— run_animation ←——— [run] 
                             ↓ 
                         [sprint] 
                              
[dodge]  (з будь-якого стану) 
[attack] (з будь-якого стану) 
``` 
 
**Як створити:** 
 
1. Натисни в порожній area → Add Node → AnimationNode 
   - Назви: `idle` 
2. У Property встав animation: `idle` (з AnimationPlayer) 
3. Повтори для `walk`, `run`, `sprint`, `dodge`, `attack` 
 
**Як створити переходи:** 
 
1. Natisni на вузл `idle` 
2. Перемістіть мишку до `walk` 
3. Натисни на вихідну точку → потягни до вхідної точки `walk` 
4. У Inspector нового переходу встав: 
   - Automata: OFF (управляємо через GDScript) 
   - Switch Mode: "At End" (закінчити поточну анімацію перед переходом) 
5. Повтори для інших переходів 
 
### Крок 3.6: Синхронізація з AnimationPlayer 
 
1. Вибери AnimationTree 
2. Inspector → Anim Player: (вибери AnimationPlayer) 
3. Inspector → Anim Root: (вибери StateMachine ресурс) 
 
### Крок 3.7: Активувати AnimationTree 
 
1. Вибери AnimationTree 
2. Inspector → Active: ON 
 
--- 
 
## 4. Налаштування для NPC 
 
Для NPC (наприклад Ervan.tscn) налаштування подібне, але простіше: 
 
### Крок 4.1: Структура NPC сцени 
 
``` 
Ervan (CharacterBody3D, скрипт: NPC.gd) 
├── MeshInstance3D (модель з FBX) 
├── CollisionShape3D 
├── AnimationPlayer 
├── AnimationTree (опціонально) 
├── DialogueTrigger (Area3D) 
└── DialogueStartPosition (Marker3D) 
``` 
 
### Крок 4.2: Анімації для NPC 
 
Мінімум: 
- `idle_01`, `idle_02` (random idle) 
- `talking` (говорення) 
- `positive_reaction` (приймає добре) 

- `negative_reaction` (не любить) 
 
**Налаштування AnimationTree:** те саме, що для Player 
 
``` 
[idle] ←→ [talking] 
  ↓ 
[positive_reaction] 
[negative_reaction] 
``` 
 
--- 
 
## 5. BlendSpace1D для locomotion 
 
BlendSpace1D робить гладкий перехід між idle, walk, run без різких 
стрибків. 
 
### Крок 5.1: Замість простих переходів, використовуй BlendSpace1D 
 
1. Редагуй AnimationTree 
2. Натисни в порожній area → Add Node → AnimationNodeBlendSpace1D 
3. Назви: `Locomotion` 
 
### Крок 5.2: Налаштування BlendSpace1D 
 
1. Вибери `Locomotion` вузл 
2. Inspector → Points property 
3. Додай три точки: 
   - Point 0: position 0.0, animation "idle" 
   - Point 1: position 0.5, animation "walk" 
   - Point 2: position 1.0, animation "run" 
 
### Крок 5.3: Синхронізація з PlayerController 
 
У PlayerController.gd уже є код: 
 
```gdscript 
# Обрахувуємо blend position (0.0 = idle, 1.0 = sprint) 
var speed_blend = clamp(current_speed / sprint_speed, 0.0, 1.0) 
animation_tree.set("parameters/Locomotion/blend_position", speed_blend) 
``` 
 
Це автоматично переміщує ползунок BlendSpace1D від 0 до 1, змішуючи 
анімації. 
 
--- 
 
## 6. AnimationPlayback state machine 
 
У GDScript коді отримуємо доступ до state machine: 
 
```gdscript 
@onready var animation_playback = 
animation_tree.get("parameters/playback") 
 
func _update_animation() -> void: 
    # Переходимо до стану idle, walk, або run 
    if current_speed == 0: 
        animation_playback.travel("idle") 
    elif is_sprinting: 
        animation_playback.travel("sprint") 
    else: 

        animation_playback.travel("walk") 
``` 
 
**Методи AnimationPlayback:** 
 
```gdscript 
animation_playback.travel("state_name")  # Перейти до стану 
animation_playback.get_current_node()    # Поточний стан 
animation_playback.is_playing()          # Чи грає? 
``` 
 
--- 
 
## 7. Синхронізація з PlayerController 
 
PlayerController.gd вже має функцію `_update_animation()`: 
 
```gdscript 
func _update_animation() -> void: 
    if not animation_tree or not animation_playback: 
        return 
     
    # BlendSpace1D для locomotion 
    var speed_blend = 0.0 
    if current_speed > 0: 
        speed_blend = clamp(current_speed / sprint_speed, 0.0, 1.0) 
     
    animation_tree.set("parameters/Locomotion/blend_position", 
speed_blend) 
     
    # State machine 
    if current_speed == 0: 
        animation_playback.travel("idle") 
    elif is_sprinting: 
        animation_playback.travel("sprint") 
    else: 
        animation_playback.travel("walk") 
``` 
 
Це викликається у `_physics_process()` кожен кадр. 
 
--- 
 
## 8. Дебагування анімацій 
 
### Проблема: Анімація не грає 
 
**Рішення:** 
1. Перевір, чи AnimationTree Active = ON 
2. Перевір, чи Anim Player посилається на AnimationPlayer 
3. Перевір, чи Anim Root посилається на StateMachine ресурс 
4. Перевір в Console: 
   ```gdscript 
   print(animation_tree.get("parameters/playback").get_current_node()) 
   # Має вивести ім'я поточного стану 
   ``` 
 
### Проблема: Анімація зависла 
 
**Рішення:** 
1. Перевір, чи FPS параметр при імпорті == FPS експорту з Blender 
2. Перевір, чи анімація має ключові кадри (не пуста) 
 

### Проблема: Різкі переходи між анімаціями 
 
**Рішення:** 
1. Налаштуй перехід у State Machine: 
   - Switch Mode: "At End" 
   - Transition: add smoothing через BlendSpace1D 
 
### Інспекція анімацій 
 
У Runtime (під час гри): 
 
```gdscript 
# Вивести всі стани у StateMachine 
var playback = animation_tree.get("parameters/playback") 
print("Current state: ", playback.get_current_node()) 
print("Is playing: ", playback.is_playing()) 
 
# Вивести доступні анімації з AnimationPlayer 
for anim in animation_player.get_animation_list(): 
    print("Animation: ", anim) 
``` 
 
--- 
 
## Швидка інструкція (TL;DR) 
 
1. **Імпорт FBX:** 
   - File → assets → FBX 
   - Inspector → Import → FPS = 30, Bake Reset ON → Reimport 
 
2. **AnimationPlayer:** 
   - Add Child → AnimationPlayer 
   - Load FBX ресурс 
 
3. **AnimationTree:** 
   - Add Child → AnimationTree 
   - Create StateMachine 
   - Add nodes: idle, walk, run, sprint, dodge, attack 
   - Set Anim Player & Anim Root 
 
4. **BlendSpace1D (опціонально):** 
   - Add BlendSpace1D для гладкого idle ↔ walk ↔ run 
 
5. **GDScript синхронізація:** 
   - У `_physics_process()`: 
     ```gdscript 
     var speed_blend = clamp(current_speed / sprint_speed, 0.0, 1.0) 
     animation_tree.set("parameters/Locomotion/blend_position", 
speed_blend) 
     ``` 
 
--- 
 
## Додаткові ресурси 
 
- Godot AnimationTree docs: 
https://docs.godotengine.org/en/stable/classes/class_animationtree.html 
- Godot AnimationPlayer docs: 
https://docs.godotengine.org/en/stable/classes/class_animationplayer.html 
- BlendSpace1D guide: 
https://docs.godotengine.org/en/stable/tutorials/animation/animation_tree
.html
