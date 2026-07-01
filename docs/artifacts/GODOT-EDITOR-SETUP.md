# GODOT-EDITOR-SETUP.md 
## Повний гайд для налаштування Hazemoor в Godot 4.3 Editor 
 

> Цей документ описує крок-за-кроком як відкрити проект, налаштувати 
системи та запустити першу гру. 
 
--- 
 
##   ЗМІСТ 
 
1. [Відкриття проекту](#1-відкриття-проекту) 
2. [Додавання Autoload систем](#2-додавання-autoload-систем) 
3. [Налаштування Input Map](#3-налаштування-input-map) 
4. [Імпорт FBX моделей](#4-імпорт-fbx-моделей) 
5. [Створення Player.tscn](#5-створення-playertscn) 
6. [Створення DialoguePanel.tscn](#6-створення-dialoguepaneltscn) 
7. [Створення TavernInterior.tscn](#7-створення-taverninteriortscn) 
8. [Запуск першої сцени](#8-запуск-першої-сцени) 
9. [Тестування діалогу](#9-тестування-діалогу) 
10. [Дебагування](#10-дебагування) 
 
--- 
 
## 1. Відкриття проекту 
 
### Крок 1.1: Клонування/завантаження репо 
 
```bash 
git clone https://github.com/nikijetson-lab/game-bible.git 
cd game-bible/godot-project 
``` 
 
### Крок 1.2: Відкриття в Godot 4.3 
 
1. Запусти Godot 4.3 
2. Натисни "Open Project" (або File → Open Project) 
3. Навігуй до папки `godot-project/` 
4. Натисни "Open" 
 
Godot завантажить проект (~30 сек). 
 
### Крок 1.3: Перевірка структури 
 
У Project Панелі (ліва сторона) перевір наявність: 
``` 
res:// 
├── data/ 
│   ├── quests/ 
│   ├── npcs/ 
│   ├── items/ 
│   ├── locations/ 
│   └── audio/ 
├── scripts/ 
│   ├── systems/ (QuestManager.gd, PlayerState.gd) 
│   ├── player/ (PlayerController.gd) 
│   └── ui/ (DialogueUI.gd) 
├── scenes/ 
│   └── (будемо створювати) 
└── project.godot 
``` 
 
Якщо структури немає, розпакуй репо правильно. 
 
--- 
 
## 2. Додавання Autoload систем 

 
Autoload — це глобальні синглтони, доступні в усіх сценах. 
 
### Крок 2.1: Project Settings → Autoload 
 
1. Project → Project Settings → вкладка **Autoload** 
2. У полі "Node Path" виглядай путь до скрипту 
 
### Крок 2.2: Додавання PlayerState 
 
1. Натисни папку в полі "Node Path" 
2. Навігуй до `res://scripts/systems/PlayerState.gd` 
3. Вибери файл, натисни "Open" 
4. У полі "Node Name" введи `PlayerState` 
5. Натисни "Add" 
 
Результат: `PlayerState` з'явиться в Autoload списку. 
 
### Крок 2.3: Додавання QuestManager 
 
Повтори Крок 2.2, але з `res://scripts/systems/QuestManager.gd` 
Node Name: `QuestManager` 
 
### Крок 2.4: Перевірка 
 
Autoload список повинен мати: 
``` 
✓ PlayerState 
✓ QuestManager 
``` 
 
Натисни "Close" (або Ctrl+S для збереження). 
 
--- 
 
## 3. Налаштування Input Map 
 
### Крок 3.1: Відкриття Input Map 
 
Project → Project Settings → вкладка **Input Map** 
 
### Крок 3.2: Додавання Actions 
 
Використовуй файл `INPUT_MAP_CONFIG.md` як довідку. 
 
Для кожної action: 
 
1. У полі "Add New Action" введи назву (наприклад `move_forward`) 
2. Натисни "Add" 
3. Натисни "+" під дією, щоб додати event 
4. Вибери тип event (Key, Mouse, Joy Button) 
5. Натисни клавішу або устрій на якому ця дія спрацює 
 
**Обов'язові actions:** 
- `move_forward` (W) 
- `move_backward` (S) 
- `move_left` (A) 
- `move_right` (D) 
- `sprint` (Shift) 
- `dodge` (Space) 
- `interact` (E) 
 
Решта (attack, pause) можуть бути додані пізніше. 

 
Натисни "Close" (Ctrl+S). 
 
--- 
 
## 4. Імпорт FBX моделей 
 
FBX файли — це 3D моделі від Meshy AI або Blender. 
 
### Крок 4.1: Підготовка FBX 
 
Припустимо, ти маєш файл `player_character.fbx` з Meshy AI. 
 
### Крок 4.2: Копіювання в проект 
 
```bash 
mkdir -p res://assets/models/characters 
cp player_character.fbx res://assets/models/characters/ 
``` 
 
### Крок 4.3: Імпорт в Godot 
 
1. У Project панелі (ліва сторона), перейди до 
`res://assets/models/characters/` 
2. Ти побачиш `player_character.fbx` 
3. Натисни на файл і подивись **Inspector** (права сторона) 
 
### Крок 4.4: Налаштування FBX 
 
У Inspector вляди вкладку **Import** (на верхній панелі Editor): 
 
**Важливі налаштування:** 
 
1. **Materials → Location:** "Mesh" 
2. **Materials → Reimport:** На 
3. **Meshes → Generate LODs:** Залежно від (поки Вимкнено) 
4. **Meshes → Root Name:** (залиш як є) 
5. **Animations → Bake Reset Animation:** На (якщо анімації є) 
 
Натисни **"Reimport"** (внизу Inspector). 
 
Godot конвертує FBX у .glb і .tres файли (~10-30 сек). 
 
### Крок 4.5: Перевірка 
 
У Project панелі розверни `player_character.fbx` і побачиш: 
- `player_character.glb` (модель) 
- `player_character.res` або `.tres` (ресурс Godot) 
 
Якщо ці файли є — імпорт успішний. 
 
--- 
 
## 5. Створення Player.tscn 
 
Player.tscn — основна сцена гравця. 
 
### Крок 5.1: Новий 3D простір 
 
1. File → New Scene 
2. Scene Root: **CharacterBody3D** (ім'я: `Player`) 
3. File → Save As 
   - Шлях: `res://scenes/player/Player.tscn` 

   - Натисни "Save" 
 
### Крок 5.2: Додавання компонентів 
 
Вибери кореневий `Player` (CharacterBody3D): 
 
1. Натисни + (Add Child Node) 
2. Типово: `CollisionShape3D` 
   - У Inspector: Shape → CapsuleShape3D 
   - Radius: 0.5 
   - Height: 1.8 
 
Повтори додавання: 
3. `MeshInstance3D` (або завантаж FBX модель) 
4. `Camera3D` (у полі Position: x=0.5, y=0.3, z=-0.8) 
5. `RayCast3D` (в Position: x=0, y=0, z=0) 
6. `AnimationPlayer` (пусто на старті) 
7. `AnimationTree` 
 
### Крок 5.3: Додавання скрипту 
 
Вибери кореневий `Player`: 
- Inspector → Attach Script 
- Path: `res://scripts/player/PlayerController.gd` 
 
### Крок 5.4: Налаштування в Inspector 
 
Після прикріплення скрипту, у Inspector переглянь PlayerController 
параметри: 
- `walk_speed`: 3.0 
- `run_speed`: 6.0 
- `sprint_speed`: 9.0 
- `camera_distance`: 0.8 
- `camera_height`: 0.3 
 
Залиш як є (за замовчуванням правильно). 
 
### Крок 5.5: Збереження 
 
Ctrl+S (або File → Save). 
 
Player.tscn готовий. 
 
--- 
 
## 6. Створення DialoguePanel.tscn 
 
Використовуй інструкцію з файлу `DIALOGUE_PANEL_SETUP.md` (дивись вище). 
 
Короткий резюме: 
1. File → New Scene 
2. Root: **CanvasLayer** (ім'я: `DialoguePanel`) 
3. Додай структуру вузлів (PanelContainer → VBoxContainer → Labels) 
4. Прикріпи скрипт `DialogueUI.gd` 
5. Позначь вузли як unique (`%`) 
6. Збереги як `res://scenes/ui/DialoguePanel.tscn` 
 
--- 
 
## 7. Створення TavernInterior.tscn 
 
Tavern Interior — перша локація гравця. 
 

### Крок 7.1: Новий 3D простір 
 
1. File → New Scene 
2. Scene Root: **Node3D** (ім'я: `TavernInterior`) 
3. Save As → `res://scenes/levels/Greyford/TavernInterior.tscn` 
 
### Крок 7.2: Додавання компонентів 
 
Вибери `TavernInterior`: 
 
1. Натисни + (Add Child) 
2. `DirectionalLight3D` (освітлення) 
   - Rotation: (-45°, 45°, 0°) 
   - Energy: 0.4 
3. `WorldEnvironment` (атмосфера) 
4. Додай Player.tscn (File → Open Scene → Player.tscn → Drag to 
TavernInterior) 
5. Додай DialoguePanel.tscn (аналогічно) 
6. Додай пропи (для тестування простий Box3D або FBX моделі) 
 
### Крок 7.3: Налаштування сцени 
 
**Світло:** 
- Вибери DirectionalLight3D 
- Shadow: On 
- Shadow Blur: 2 
 
**Бекграунд:** 
- Вибери WorldEnvironment 
- Environment → створи нове Environment ресурс 
- Ambient Light Energy: 0.5 
- Ambient Light Color: #A0A0B0 
 
### Крок 7.4: Позиціонування гравця 
 
Вибери Player (інстанс у сцені): 
- Position: (2, 1.7, 3) 
- Rotation: (0, 0, 0) 
 
Вибери DialoguePanel: 
- Залиш як є (CanvasLayer, Z Index 100) 
 
### Крок 7.5: Збереження 
 
Ctrl+S. 
 
TavernInterior.tscn готовий. 
 
--- 
 
## 8. Запуск першої сцени 
 
### Крок 8.1: Налаштування Main Scene 
 
Project → Project Settings → вкладка **General** → **Scenes** 
- Main Scene: `res://scenes/levels/Greyford/TavernInterior.tscn` 
 
### Крок 8.2: Запуск 
 
Натисни **F5** або Run → Play Scene. 
 
Godot запустить гру з TavernInterior. 
 

--- 
 
## 9. Тестування діалогу 
 
### Крок 9.1: Додання тестового коду 
 
У TavernInterior додай простий скрипт для запуску діалогу: 
 
```gdscript 
# res://scenes/levels/Greyford/TavernInterior.gd 
extends Node3D 
 
func _ready() -> void: 
 
# Завантажимо епізод та показуємо першу сцену 
 
if QuestManager.load_episode("грейфорд_та"): 
 
 
QuestManager.display_scene("arriving") 
 
 
print("Dialogue should appear on screen") 
 
else: 
 
 
print("ERROR: Failed to load episode") 
``` 
 
Прикріпи цей скрипт до TavernInterior: 
1. Вибери TavernInterior (кореневий Node3D) 
2. Inspector → Attach Script → Create new 
3. Сохрани як `res://scenes/levels/Greyford/TavernInterior.gd` 
4. Скопіюй код вверх 
 
### Крок 9.2: Запуск з F5 
 
1. Натисни F5 
2. На екрані має з'явитись DialoguePanel з текстом "Постоялий двір 
Грейфорда" 
3. Знизу мають бути 4 кнопки вибору 
 
Якщо текст не з'являється, перевір: 
- Чи завантажив QuestManager епізод (`грейфорд_та_scenes.json` існує?) 
- Чи позначені вузли DialoguePanel як unique (`%`)? 
- Чи прикріплений DialogueUI.gd до DialoguePanel? 
 
### Крок 9.3: Тестування вибір 
 
1. Натисни на одну з кнопок (перший вибір) 
2. Перевір у Console (Output панель внизу): 
   - "[QuestManager] Choice applied: ..." — вибір обробився 
   - "[QuestManager] Quest marked complete: ..." — квест позначений 
   - Reputation changes — репутація змінилась 
 
Якщо це все видно — система працює! 
 
--- 
 
## 10. Дебагування 
 
### Проблема: DialoguePanel не видно 
 
**Рішення:** 
1. Перевір, чи DialoguePanel інстансіюється в сцені 
2. Перевір Z Index у Inspector (має бути 100) 
3. Перевір, чи вузли позначені unique (`%`) 
 
### Проблема: Кнопки вибору не з'являються 
 
**Рішення:** 

1. Перевір, чи QuestManager.display_scene() був викликаний 
2. Перевір Console для помилок JSON 
3. Перевір, чи файл `грейфорд_та_scenes.json` існує в 
`res://data/quests/` 
 
### Проблема: Гравець не рухається 
 
**Рішення:** 
1. Перевір, чи Input Map налаштований (Project Settings → Input Map) 
2. Перевір, чи PlayerController.gd прикріплений до Player 
3. Перевір, чи Player має CollisionShape3D 
 
### Команди для дебагування 
 
У Console (F8 або Output панель): 
 
```gdscript 
# Показати всі завантажені дані 
PlayerState.print_debug_info() 
 
# Запустити діалог 
QuestManager.load_episode("грейфорд_та") 
QuestManager.display_scene("arriving") 
 
# Перевірити квесты 
print(PlayerState.completed_quests) 
 
# Перевірити репутацію 
print(PlayerState.reputation) 
``` 
 
--- 
 
## Наступні кроки 
 
Після успішного запуску першої сцени: 
 
1. **Створи більше сцен** (City Main Street, Admin Building) 
2. **Імпортуй 3D моделі** (Ervan, Mia, предмети) 
3. **Налаштуй анімації** (AnimationTree для ходьби, спринту) 
4. **Додай звук** (музика, SFX) 
5. **Полісуй UI** (кастомні шрифти, кольори) 
 
--- 
 
## Дополнительные ресурсы 
 
- **Godot документація:** https://docs.godotengine.org/en/stable/ 
- **GDScript посібник:** 
https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/ 
- **3D в Godot:** https://docs.godotengine.org/en/stable/tutorials/3d/ 
 
--- 
 
**Версія:** 1.0   
**Дата:** 01.07.2026   
**Для:** Godot 4.3+
