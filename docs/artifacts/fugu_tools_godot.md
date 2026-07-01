# Fugu Tools для Godot Розробки Hazemoor 
 
## Структура Fugu Tools 
 
``` 
fugu_tools/ 
├── godot_tools/ 
│   ├── create_scene.py 
│   ├── import_asset.py 
│   ├── setup_project.py 
│   ├── build_game.py 
│   └── run_godot.py 
├── game_tools/ 
│   ├── create_quest.py 
│   ├── add_npc.py 
│   └── test_gameplay.py 
└── config.yaml 
``` 
 
## 1. create_scene.py 
 
```python 
#!/usr/bin/env python3 
"""Fugu Tool: Create Godot Scene""" 

 
import subprocess 
import json 
import sys 
 
def create_scene(scene_path: str, node_type: str = "Node3D") -> dict: 
    """ 
    Створити нову сцену в Godot проекті 
     
    Args: 
        scene_path: "res://scenes/levels/Greyford/TavernInterior.tscn" 
        node_type: "Node3D", "CanvasLayer", "Control" 
     
    Returns: 
        {success: bool, message: str, scene_path: str} 
    """ 
     
    try: 
        # Використовуємо gdtoolkit або CLI 
        cmd = [ 
            "godot", 
            "--headless", 
            "--script", 
            "create_scene_script.gd", 
            "--", 
            scene_path, 
            node_type 
        ] 
         
        result = subprocess.run(cmd, capture_output=True, text=True) 
         
        if result.returncode == 0: 
            return { 
                "success": True, 
                "message": f"Scene created: {scene_path}", 
                "scene_path": scene_path 
            } 
        else: 
            return { 
                "success": False, 
                "message": f"Error: {result.stderr}", 
                "scene_path": scene_path 
            } 
     
    except Exception as e: 
        return { 
            "success": False, 
            "message": str(e), 
            "scene_path": scene_path 
        } 
 
if __name__ == "__main__": 
    if len(sys.argv) < 2: 
        print(json.dumps({"error": "Usage: create_scene.py <scene_path> 
[node_type]"})) 
        sys.exit(1) 
     
    scene_path = sys.argv[1] 
    node_type = sys.argv[2] if len(sys.argv) > 2 else "Node3D" 
     
    result = create_scene(scene_path, node_type) 
    print(json.dumps(result)) 
``` 

 
## 2. import_asset.py 
 
```python 
#!/usr/bin/env python3 
"""Fugu Tool: Import 3D Asset (FBX/GLB)""" 
 
import subprocess 
import shutil 
import json 
import sys 
from pathlib import Path 
 
def import_asset(asset_path: str, dest_path: str) -> dict: 
    """ 
    Імпортувати FBX/GLB модель в Godot проект 
     
    Args: 
        asset_path: "/home/user/Downloads/player_character.fbx" 
        dest_path: "res://assets/models/characters/player.fbx" 
     
    Returns: 
        {success: bool, message: str, imported_path: str} 
    """ 
     
    try: 
        source = Path(asset_path) 
        dest = Path(dest_path) 
         
        if not source.exists(): 
            return { 
                "success": False, 
                "message": f"Asset not found: {asset_path}", 
                "imported_path": None 
            } 
         
        # Копіюємо файл 
        dest.parent.mkdir(parents=True, exist_ok=True) 
        shutil.copy2(source, dest) 
         
        # Казуємо Godot перезавантажити 
        result = subprocess.run( 
            ["godot", "--headless", "--reimport", str(dest)], 
            capture_output=True, 
            text=True 
        ) 
         
        return { 
            "success": True, 
            "message": f"Asset imported: {dest_path}", 
            "imported_path": str(dest) 
        } 
     
    except Exception as e: 
        return { 
            "success": False, 
            "message": str(e), 
            "imported_path": None 
        } 
 
if __name__ == "__main__": 
    if len(sys.argv) < 3: 

        print(json.dumps({"error": "Usage: import_asset.py <source> 
<destination>"})) 
        sys.exit(1) 
     
    result = import_asset(sys.argv[1], sys.argv[2]) 
    print(json.dumps(result)) 
``` 
 
## 3. setup_project.py 
 
```python 
#!/usr/bin/env python3 
"""Fugu Tool: Setup Godot Project""" 
 
import subprocess 
import json 
import sys 
import shutil 
from pathlib import Path 
 
def setup_project(project_path: str) -> dict: 
    """ 
    Налаштувати Godot проект для Hazemoor 
     
    Args: 
        project_path: "C:\\Users\\Dmytro\\Hazemoor" 
     
    Returns: 
        {success: bool, steps: [str], errors: [str]} 
    """ 
     
    steps = [] 
    errors = [] 
     
    try: 
        project_dir = Path(project_path) 
         
        # Крок 1: Copy репозиторій 
        steps.append("  Copying game-bible repository...") 
        game_bible_src = Path("/tmp/game-bible") 
        if game_bible_src.exists(): 
            dest = project_dir / "godot-project" 
            if dest.exists(): 
                shutil.rmtree(dest) 
            shutil.copytree(game_bible_src / "godot-project", dest) 
            steps.append("✓ Repository copied") 
        else: 
            errors.append("game-bible repository not found") 
         
        # Крок 2: Інітьялізувати Git 
        steps.append("  Initializing Git...") 
        subprocess.run( 
            ["git", "init"], 
            cwd=str(project_dir), 
            capture_output=True 
        ) 
        steps.append("✓ Git initialized") 
         
        # Крок 3: Встановити Godot 
        steps.append("  Checking Godot installation...") 
        result = subprocess.run(["godot", "--version"], 
capture_output=True, text=True) 

        if result.returncode == 0: 
            steps.append(f"✓ Godot found: {result.stdout.strip()}") 
        else: 
            errors.append("Godot not found in PATH") 
         
        # Крок 4: Встановити Python зависимості 
        steps.append("  Installing Python dependencies...") 
        subprocess.run( 
            ["pip", "install", "godot-python", "gdtoolkit"], 
            capture_output=True 
        ) 
        steps.append("✓ Dependencies installed") 
         
        return { 
            "success": len(errors) == 0, 
            "project_path": str(project_dir), 
            "steps": steps, 
            "errors": errors 
        } 
     
    except Exception as e: 
        errors.append(str(e)) 
        return { 
            "success": False, 
            "project_path": str(project_path), 
            "steps": steps, 
            "errors": errors 
        } 
 
if __name__ == "__main__": 
    if len(sys.argv) < 2: 
        print(json.dumps({"error": "Usage: setup_project.py 
<project_path>"})) 
        sys.exit(1) 
     
    result = setup_project(sys.argv[1]) 
    print(json.dumps(result)) 
``` 
 
## 4. run_godot.py 
 
```python 
#!/usr/bin/env python3 
"""Fugu Tool: Run Godot Editor or Game""" 
 
import subprocess 
import json 
import sys 
from pathlib import Path 
 
def run_godot(project_path: str, action: str = "editor") -> dict: 
    """ 
    Запустити Godot Editor або игру 
     
    Args: 
        project_path: "C:\\Users\\Dmytro\\Hazemoor\\godot-project" 
        action: "editor", "play", "export_windows" 
     
    Returns: 
        {success: bool, message: str, process_id: int} 
    """ 
     

    try: 
        project_dir = Path(project_path) 
         
        if action == "editor": 
            cmd = ["godot", str(project_dir)] 
            message = "Opening Godot Editor..." 
         
        elif action == "play": 
            cmd = ["godot", "--path", str(project_dir), 
"res://scenes/ui/MainMenu.tscn"] 
            message = "Running game..." 
         
        elif action == "export_windows": 
            cmd = [ 
                "godot", 
                "--headless", 
                "--path", str(project_dir), 
                "--export-release", "Windows Desktop", 
                "hazemoor.exe" 
            ] 
            message = "Exporting Windows build..." 
         
        else: 
            return { 
                "success": False, 
                "message": f"Unknown action: {action}", 
                "process_id": None 
            } 
         
        process = subprocess.Popen(cmd) 
         
        return { 
            "success": True, 
            "message": message, 
            "process_id": process.pid, 
            "action": action 
        } 
     
    except Exception as e: 
        return { 
            "success": False, 
            "message": str(e), 
            "process_id": None 
        } 
 
if __name__ == "__main__": 
    if len(sys.argv) < 2: 
        print(json.dumps({"error": "Usage: run_godot.py <project_path> 
[action]"})) 
        sys.exit(1) 
     
    project_path = sys.argv[1] 
    action = sys.argv[2] if len(sys.argv) > 2 else "editor" 
     
    result = run_godot(project_path, action) 
    print(json.dumps(result)) 
``` 
 
## Hermes Config для Godot 
 
```yaml 
# ~/.hermes/godot_workflow.yaml 
 

name: "Hazemoor Game Development" 
description: "AI-powered Godot RPG development" 
 
tools: 
  fugu: 
    enabled: true 
    base_path: "/home/user/fugu_tools" 
    tools: 
      - name: "create_scene" 
        path: "godot_tools/create_scene.py" 
        description: "Create Godot scene" 
       
      - name: "import_asset" 
        path: "godot_tools/import_asset.py" 
        description: "Import 3D model" 
       
      - name: "setup_project" 
        path: "godot_tools/setup_project.py" 
        description: "Setup game project" 
       
      - name: "run_godot" 
        path: "godot_tools/run_godot.py" 
        description: "Run Godot editor or game" 
 
workflows: 
  setup_game: 
    steps: 
      1. run_tool("setup_project", project_path="C:\\Games\\Hazemoor") 
      2. run_tool("import_asset", asset="player_character.fbx", 
dest="res://assets/models/characters/player.fbx") 
      3. run_tool("create_scene", 
scene_path="res://scenes/levels/Greyford/TavernInterior.tscn", 
node_type="Node3D") 
      4. run_tool("run_godot", project_path="C:\\Games\\Hazemoor\\godot-
project", action="editor") 
 
telegram: 
  enabled: true 
  commands: 
    "/setup_game" - "Setup Godot project" 
    "/import <asset>" - "Import 3D asset" 
    "/create_scene <path>" - "Create scene" 
    "/run_editor" - "Open Godot" 
    "/play_game" - "Run game" 
```
