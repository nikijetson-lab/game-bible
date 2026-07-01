# DialoguePanel.tscn — Setup Instructions 
 
## Як створити DialoguePanel.tscn у Godot 4.3 Editor 
 
### Крок 1: Створити основну сцену 
 
1. File → New Scene 
2. Root node: **CanvasLayer** (ім'я: `DialoguePanel`) 
   - Offset (Z Index): 100 (щоб були поверх гри) 
   - Modulate → Alpha: 0.0 (прозора на старті) 
 
### Крок 2: Структура гузлів (drag & drop) 
 
``` 
DialoguePanel (CanvasLayer) ← ROOT 
├─ PanelContainer (Control) 
│  ├─ StyleBox (в Inspector → theme_overrides → styles → panel) 
│  │  └─ Задай фоновий колір темний (наприклад #2C3E50) 
│  └─ MarginContainer (встав MarginContainer всередину PanelContainer) 
│     └─ VBoxContainer (встав всередину MarginContainer) 
│        ├─ TitleLabel (Label) 
│        ├─ HSeparator (для розділення) 
│        ├─ TextLabel (Label) 
│        └─ ChoicesVBox (VBoxContainer) 
└─ AnimationPlayer (опціонально, для анімацій) 
``` 
 
### Крок 3: Налаштування PanelContainer 
 
Вибери **PanelContainer** у Scene дереві: 
 

**Inspector → Size Flags:** 
- Horizontal: "Fill" 
- Vertical: "Fill" 
 
**Inspector → Anchors & Offsets:** 
- Anchor Left: 0.1 (10% від лівого краю) 
- Anchor Top: 0.6 (60% від верхнього краю) 
- Anchor Right: 0.9 (90% від правого краю) 
- Anchor Bottom: 0.95 (95% від нижнього краю) 
- Offset: залиш 0,0,0,0 
 
### Крок 4: Налаштування MarginContainer 
 
Вибери **MarginContainer** (всередину PanelContainer): 
 
**Inspector → Theme Overrides → Constants:** 
- margin_left: 16 
- margin_top: 16 
- margin_right: 16 
- margin_bottom: 16 
 
### Крок 5: Налаштування основного VBoxContainer 
 
Вибери **VBoxContainer** (всередину MarginContainer): 
 
**Inspector:** 
- Separation: 8 (відстань між елементами) 
- Size Flags Vertical: "Fill" 
 
### Крок 6: Додати TitleLabel 
 
Вибери VBoxContainer, натисни "Add Child → Label" 
Перейменуй на `TitleLabel` 
 
**Inspector:** 
- Text: "Грейфорд" 
- Theme Overrides → Font Sizes → font_size: 28 
- Theme Overrides → Colors → font_color: #FFD700 (золотистий) 
- Custom Minimum Size → Height: 40 
 
### Крок 7: Додати HSeparator 
 
Натисни "Add Child → HSeparator" 
 
**Inspector:** 
- Custom Minimum Size → Height: 2 
 
### Крок 8: Додати TextLabel 
 
Add Child → Label 
Перейменуй на `TextLabel` 
 
**Inspector:** 
- Text: "Ви входите у таверну..." 
- Theme Overrides → Font Sizes → font_size: 14 
- Theme Overrides → Colors → font_color: #FFFFFF 
- Text → Autowrap Mode: "Word" 
- Size Flags Vertical: "Expand Fill" (займай доступне місце) 
- Custom Minimum Size → Height: 100 
 
### Крок 9: Додати ChoicesVBox 
 
Add Child → VBoxContainer 

Перейменуй на `ChoicesVBox` 
 
**Inspector:** 
- Separation: 6 (між кнопками) 
- Size Flags Vertical: "Shrink End" 
- Custom Minimum Size → Height: 150 
 
### Крок 10: Додати DialogueUI скрипт 
 
Вибери кореневий **DialoguePanel** (CanvasLayer): 
 
**Inspector → Attach Script:** 
- Path: res://scripts/ui/DialogueUI.gd 
- Class Name: DialogueUI 
 
### Крок 11: Налаштувати Unique Names (для посилань у скрипті) 
 
Щоб скрипт міг знайти вузли через `@onready`, потрібно позначити їх як 
unique: 
 
Для кожного з цих вузлів: 
1. Праворуч клікни на вузол 
2. Натисни на іконку `%` (або Right-click → "Access as Unique Name") 
 
**Вузли для позначення unique:** 
- PanelContainer 
- TitleLabel 
- TextLabel 
- ChoicesVBox 
- AnimationPlayer 
 
Після цього їхні імена матимуть префікс `%` у дереві. 
 
### Крок 12: Налаштування у Inspector (DialogueUI скрипт) 
 
Вибери DialoguePanel (кореневий CanvasLayer), поглянь Inspector: 
 
Скрипт DialogueUI має ці експорти: 
- **fade_in_duration**: 0.3 (залиш як є) 
- **fade_out_duration**: 0.3 (залиш як є) 
- **choice_button_scene**: (опціонально, залиш пусто — створюватиме 
кнопки динамічно) 
- **is_visible**: false (залиш як є) 
 
### Крок 13: Збереги сцену 
 
File → Save Scene 
Назва: **DialoguePanel.tscn** 
Шлях: **res://scenes/ui/DialoguePanel.tscn** 
 
--- 
 
## Як виглядатиме UI 
 
Після запуску гри, коли QuestManager покаже першу сцену: 
 
``` 
╔════════════════════════════════════════╗ 
║  Постоялий двір Грейфорда (TitleLabel)║ 
║  ────────────────────────────────────  ║ 
║  Ви входите у напівтемну таверну...    ║ 
║  За шинком стоїть Ерван...             ║ 
║  (TextLabel — авто-wrap)               ║ 

║                                        ║ 
║  [Ми домовились із ним...]             ║ ← Choice buttons 
║  [Це виключно особиста справа]          ║    (динамічно створені) 
║  [Я просто доставляю листа]             ║ 
║  [Дктрина Судді]                       ║ 
╚════════════════════════════════════════╝ 
``` 
 
--- 
 
## Тестування 
 
1. Відкрий **project.godot** у Godot Editor 
2. Додай Autoload: 
   - Project → Project Settings → Autoload вкладка 
   - Додай два файли: 
     - **PlayerState**: res://scripts/systems/PlayerState.gd 
     - **QuestManager**: res://scripts/systems/QuestManager.gd 
3. Додай DialoguePanel до гри (опціонально як Autoload або інстансіюй у 
грі) 
4. Запусти гру (F5) 
5. У скрипті тестування: 
   ```gdscript 
   QuestManager.load_episode("грейфорд_та") 
   QuestManager.display_scene("arriving") 
   ``` 
 
Ти мають бачити DialoPanel з текстом і кнопками. 
 
--- 
 
## Інспектор справки 
 
### Якщо вузли не знаходяться (@onready помилка) 
 
1. Перевір, чи позначені вони `%` (unique) 
2. Перевір назви точні: 
   - `PanelContainer` 
   - `TitleLabel` 
   - `TextLabel` 
   - `ChoicesVBox` 
   - `AnimationPlayer` (якщо додав) 
 
### Якщо DialogueUI не прикріплений 
 
Inspector → Attach Script → res://scripts/ui/DialogueUI.gd 
 
### Якщо кнопки не з'являються 
 
Перевір: 
1. QuestManager завантажив епізод: 
`QuestManager.load_episode("грейфорд_та")` 
2. QuestManager викликав `display_scene("arriving")` 
3. У DialogueUI функція `_on_scene_displayed` отримала вхідні дані
