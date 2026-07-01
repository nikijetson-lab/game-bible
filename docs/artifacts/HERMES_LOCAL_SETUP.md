# Hermes Local Setup для Windows 
 
##   Запуск Hermes локально на ноуті 
 
**Переваги:** 
-   Немає VPS, все на одній машині 
-   Швидше (локальна мережа) 
-   Повний контроль 
-   Telegram бот работає локально 
 
--- 
 
##   ВИМОГИ 
 
``` 
✓ Windows 10/11 
✓ Python 3.10+ (https://www.python.org/downloads/) 
✓ Godot 4.3 (https://godotengine.org/download/) 
✓ Git (https://git-scm.com/download/win) 
✓ Node.js 16+ (для Hermes) - опціонально 
``` 
 
--- 
 
##   INSTALLATION (Windows) 
 
### Крок 1: Встановити Python пакети 
 
```powershell 
# Відкрити PowerShell як Admin 
 
# Встановити Hermes 
pip install hermes-framework fugu python-telegram-bot 
 
# Перевірити 
hermes --version 
python --version 
``` 
 
### Крок 2: Створити папку проекту 
 
```powershell 
# Створити папку 
mkdir C:\Users\Dmytro\Hazemoor 
cd C:\Users\Dmytro\Hazemoor 
 
# Клонувати або скопіювати game-bible 
git clone <твій репо> godot-project 
``` 
 
### Крок 3: Налаштувати Telegram Bot 
 
``` 
1. Відкрити Telegram 

2. Знайти @BotFather 
3. Написати: /newbot 
4. Вибрати ім'я бота: HazemoorGameBot 
5. Отримати TOKEN: 123456789:ABCDefGhIjKlMnOpQrStUvWxYz 
6. Знайти свій Chat ID: 
   - Напиши @userinfobot 
   - Отримай CHAT_ID: 987654321 
``` 
 
### Крок 4: Створити Hermes Config 
 
Файл: `C:\Users\Dmytro\Hazemoor\hermes_config.yaml` 
 
```yaml 
# Hermes Local Configuration 
 
app: 
  name: "Hazemoor Game Developer" 
  version: "1.0" 
  debug: true 
 
hermes: 
  agents: 
    - name: "game_developer" 
      type: "local" 
      role: "AI Game Development Agent" 
      description: "Керує розвитком Hazemoor у Godot" 
 
telegram: 
  enabled: true 
  token: "123456789:ABCDefGhIjKlMnOpQrStUvWxYz" 
  chat_id: "987654321" 
   
  commands: 
    setup_game: 
      description: "Setup Godot project" 
      script: "hermes_game_developer.py" 
      action: "run_full_setup" 
     
    create_scene: 
      description: "Create new scene" 
      script: "hermes_game_developer.py" 
      action: "create_scene" 
     
    import_asset: 
      description: "Import 3D model" 
      script: "hermes_game_developer.py" 
      action: "import_asset" 
     
    open_editor: 
      description: "Open Godot Editor" 
      script: "hermes_game_developer.py" 
      action: "open_editor" 
     
    play_game: 
      description: "Run game" 
      script: "hermes_game_developer.py" 
      action: "play_game" 
     
    status: 
      description: "Show game status" 
      script: "hermes_game_developer.py" 
      action: "get_status" 

     
    git_commit: 
      description: "Commit changes to Git" 
      script: "hermes_game_developer.py" 
      action: "git_commit" 
 
fugu: 
  enabled: true 
  tools_path: "C:\\Users\\Dmytro\\Hazemoor\\fugu_tools" 
   
  tools: 
    - name: "create_scene" 
      path: "godot_tools\\create_scene.py" 
     
    - name: "import_asset" 
      path: "godot_tools\\import_asset.py" 
     
    - name: "setup_project" 
      path: "godot_tools\\setup_project.py" 
     
    - name: "run_godot" 
      path: "godot_tools\\run_godot.py" 
 
godot: 
  path: "C:\\Program Files\\Godot\\godot.exe" 
  project_path: "C:\\Users\\Dmytro\\Hazemoor\\godot-project" 
 
git: 
  enabled: true 
  repo_path: "C:\\Users\\Dmytro\\Hazemoor" 
  auto_commit: true 
 
logging: 
  level: "INFO" 
  file: "hermes.log" 
  console: true 
``` 
 
--- 
 
##   Файлова структура 
 
``` 
C:\Users\Dmytro\Hazemoor\ 
├─ godot-project\              # Godot проект 
│  ├─ project.godot 
│  ├─ scripts\ 
│  ├─ scenes\ 
│  ├─ assets\ 
│  └─ data\ 
│ 
├─ fugu_tools\                 # Fugu інструменти 
│  ├─ godot_tools\ 
│  │  ├─ create_scene.py 
│  │  ├─ import_asset.py 
│  │  ├─ setup_project.py 
│  │  ├─ run_godot.py 
│  │  └─ build_game.py 
│  └─ config.yaml 
│ 
├─ hermes_game_developer.py     # AI Agent (Python) 
├─ hermes_config.yaml          # Hermes конфіг 
├─ start_hermes.bat            # Старт скрипт 

├─ hermes.log                  # Логи 
└─ .git\                       # Git репозиторій 
``` 
 
--- 
 
##   ЗАПУСК HERMES 
 
### Спосіб 1: Batch файл (найпростіше) 
 
Створи файл: `C:\Users\Dmytro\Hazemoor\start_hermes.bat` 
 
```batch 
@echo off 
cd /d C:\Users\Dmytro\Hazemoor 
 
echo   Starting Hermes Game Developer Agent... 
echo. 
 
python hermes_game_developer.py "C:\Users\Dmytro\Hazemoor" 
 
echo. 
echo ✓ Hermes started! 
echo Telegram bot is now listening for commands... 
echo. 
pause 
``` 
 
**Запуск:** Двічі клікни на `start_hermes.bat` 
 
### Спосіб 2: PowerShell 
 
```powershell 
cd C:\Users\Dmytro\Hazemoor 
python hermes_game_developer.py "C:\Users\Dmytro\Hazemoor" 
``` 
 
### Спосіб 3: Command Prompt 
 
```cmd 
cd C:\Users\Dmytro\Hazemoor 
python hermes_game_developer.py "C:\Users\Dmytro\Hazemoor" 
``` 
 
--- 
 
##   TELEGRAM COMMANDS 
 
### Запуск Hermes 
 
``` 
1. Відкрити start_hermes.bat 
   → Виконується Python скрипт 
   → Запускається Telegram bot 
   → Чека на команди 
``` 
 
### Команди через Telegram 
 
``` 
/setup_game 
  → Hermes автоматично: 

     1. Копіює game-bible 
     2. Створює всі сцени 
     3. Інітьялізує Git 
     4. Готує проект 
 
/open_editor 
  → Відкриває Godot Editor локально 
  → Проект готовий до розробки 
 
/play_game 
  → Запускає гру на ноуті 
 
/status 
  → Показує прогрес розробки 
 
/git_commit <message> 
  → Commita зміни в Git 
 
/import_asset <path> 
  → Импортує 3D модель 
 
/create_scene <path> 
  → Створює нову сцену 
``` 
 
--- 
 
##   LOGGING 
 
Всі операції записуються в: 
 
``` 
C:\Users\Dmytro\Hazemoor\hermes.log 
 
[2024-07-01 18:30:15] [INFO] Starting Hermes Agent... 
[2024-07-01 18:30:16] [INFO] Loading Telegram configuration... 
[2024-07-01 18:30:17] [SUCCESS] Telegram bot connected 
[2024-07-01 18:30:18] [INFO] Waiting for commands... 
[2024-07-01 18:30:25] [TASK] /setup_game received 
[2024-07-01 18:30:25] [INFO]   Starting project setup... 
[2024-07-01 18:30:26] [INFO]   Copying game files... 
... 
``` 
 
Дивись логи для дебагування! 
 
--- 
 
##   TROUBLESHOOTING 
 
### Проблема: "Python not found" 
 
**Рішення:** 
```powershell 
# Переустановити Python з галочкою "Add Python to PATH" 
# Потім перезавантажити систему 
``` 
 
### Проблема: "Godot not found" 
 
**Рішення:** 
```yaml 

# У hermes_config.yaml змінити path: 
godot: 
  path: "C:\\Program Files (x86)\\Godot\\godot.exe"  # або інший path 
``` 
 
### Проблема: Telegram bot не відповідає 
 
**Рішення:** 
``` 
1. Перевірити internet connection 
2. Перевірити TOKEN в hermes_config.yaml 
3. Перевірити CHAT_ID 
4. Перезапустити start_hermes.bat 
5. Дивись hermes.log для помилок 
``` 
 
### Проблема: Godot не відкривається 
 
**Рішення:** 
``` 
1. Вручну запустити Godot 
2. Перевірити що project.godot існує 
3. Переконатись що Godot path правильний 
``` 
 
--- 
 
##   QUICK START (5 хвилин) 
 
``` 
1. pip install hermes-framework python-telegram-bot 
2. Скопіюй файли в C:\Users\Dmytro\Hazemoor\ 
3. Встав TOKEN та CHAT_ID в hermes_config.yaml 
4. Двічі клікни start_hermes.bat 
5. Напиши в Telegram: /setup_game 
6. PROFIT!   
``` 
 
--- 
 
##   ЛАЙФХАКИ 
 
### Автоматичний старт при включенні ПК 
 
``` 
1. Натисни Win+R 
2. Введи: shell:startup 
3. Копіюй start_hermes.bat туди 
4. Тепер Hermes стартує автоматично при включенні ПК 
``` 
 
### Фоновий режим (бути завжди готовим) 
 
``` 
Створи файл: C:\Users\Dmytro\Hazemoor\start_hermes_bg.vbs 
 
Set objShell = CreateObject("WScript.Shell") 
objShell.Run "cmd /c start_hermes.bat", 0, False 
 
Тепер запускається без вікна 
``` 
 

### Лог в реальному часі 
 
```powershell 
# Дивись логи в реальному часі 
Get-Content hermes.log -Wait -Tail 20 
```
