# Telegram Commands для Hermes Game Developer 
 
## Setup 
 
``` 
/setup_game 
  → Запустить установку проекту 
  → Создать всі сцени 
  → Импортировать assets 
  → Відкрити Godot Editor 
``` 
 
## Game Development 
 
``` 
/create_scene <path> <type> 
  /create_scene res://scenes/MyScene.tscn Node3D 
  → Создати нову сцену 
 
/import_asset <source> <dest> 
  /import_asset ./player.fbx res://assets/models/player.fbx 

  → Импортировать 3D модель 
 
/status 
  → Показать статус розвитку 
  → Скільки сцен создано 
  → Скільки assets импортовано 
``` 
 
## Run Game 
 
``` 
/open_editor 
  → Відкрити Godot Editor на проекті 
 
/play_game 
  → Запустити гру (MainMenu) 
 
/export_windows 
  → Експортировать Windows build (hazemoor.exe) 
``` 
 
## Advanced 
 
``` 
/git_commit <message> 
  /git_commit "Added quest system" 
  → Залишити commit в Git 
 
/test_quest <quest_id> 
  /test_quest arriving 
  → Запустити конкретний quest для тестування 
 
/build_full 
  → Повна rebuild (видалити старе, створити нове) 
 
/generate_models 
  → Запустити Meshy API для генерування моделей 
  (потребує API key) 
``` 
 
## Example Workflow 
 
``` 
Користувач: /setup_game 
Bot:   Starting project setup... 
Bot:   Copying game files... 
Bot: ✓ Project setup complete! 
Bot:   Creating all scenes... 
Bot: ✓ Created 8/8 scenes (100%) 
Bot:   Current Game State: 
     • Project initialized: true 
     • Scenes created: 8 
     • Assets imported: 0 
Bot: What next? 
     1. /open_editor - Open Godot Editor 
     2. /play_game - Run the game 
 
Користувач: /open_editor 
Bot:    Opening Godot Editor... 
Bot: ✓ Godot Editor opened (PID: 12345) 
Bot: Godot is running on your machine! 

    Click in the Editor to start developing... 
 
Користувач: /status 
Bot:   HAZEMOOR GAME STATUS 
    ══════════════════════════════════════ 
    Project: C:\\Games\\Hazemoor 
    Progress: 20% 
     
    ✓ Initialized: true 
    ✓ Scenes: 8 
    ✓ Assets: 0 
     
    Current Task: open_editor 
    ══════════════════════════════════════ 
``` 
 
## Setup на Windows 
 
### 1. Встановити необхідне 
 
```bash 
# Godot 4.3 
https://godotengine.org/download/ 
 
# Python 3.10+ 
https://www.python.org/downloads/ 
 
# Git 
https://git-scm.com/download/win 
 
# VS Code або інший редактор 
``` 
 
### 2. Встановити Python пакети 
 
```bash 
pip install hermes-cli fugu godot-tools gdtoolkit python-telegram-bot 
``` 
 
### 3. Налаштувати Hermes + Fugu 
 
```bash 
# Створити папку для інструментів 
mkdir C:\Users\YourUser\fugu_tools 
mkdir C:\Users\YourUser\fugu_tools\godot_tools 
 
# Копіювати фасли з game-bible 
# cp fugu_tools_godot.md → C:\Users\YourUser\fugu_tools\ 
# cp hermes_game_developer.py → C:\Users\YourUser\ 
``` 
 
### 4. Налаштувати Telegram Bot 
 
```bash 
# 1. Створити bot у BotFather (@BotFather in Telegram) 
#    Отримати token: 123456789:ABCDefGhIjKlMnOpQrStUvWxYz 
 
# 2. Встановити token в Hermes config 
hermes config set TELEGRAM_TOKEN "123456789:ABCDefGhIjKlMnOpQrStUvWxYz" 
 
# 3. Встановити chat ID 
hermes config set TELEGRAM_CHAT_ID "YOUR_CHAT_ID" 

 
# 4. Запустити bot 
hermes start --telegram 
``` 
 
### 5. Запустити Game Developer Agent 
 
```bash 
# Через Telegram: 
User: /setup_game 
 
# Або через Python: 
python hermes_game_developer.py "C:\Users\Dmytro\Hazemoor" 
``` 
 
## Файлова структура 
 
``` 
C:\Users\Dmytro\ 
├─ Hazemoor\                          # Основна папка проекту 
│  ├─ godot-project\                  # Godot проект 
│  │  ├─ project.godot 
│  │  ├─ scripts\ 
│  │  ├─ scenes\ 
│  │  ├─ assets\ 
│  │  └─ data\ 
│  └─ .git\                           # Git репозиторій 
│ 
├─ fugu_tools\                        # Fugu інструменти 
│  ├─ godot_tools\ 
│  │  ├─ create_scene.py 
│  │  ├─ import_asset.py 
│  │  ├─ setup_project.py 
│  │  ├─ run_godot.py 
│  │  └─ build_game.py 
│  └─ config.yaml 
│ 
└─ hermes_game_developer.py           # Hermes Agent 
```
