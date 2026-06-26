# ⚙️ Система Збереження

```gdscript
# save_system.gd
extends Node

const SAVE_DIR = "user://saves/"
const SAVE_SLOTS = 5

func _ready():
    DirAccess.make_dir_recursive(SAVE_DIR)

func save_game(slot: int) -> bool:
    var data = {
        "player": {
            "position": Player.global_position,
            "health": Player.health,
            "mana": Player.mana,
            "inventory": Player.inventory.get_all(),
            "equipment": Player.equipment.get_all()
        },
        "world": {
            "time": TimeSystem.get_time_dict(),
            "weather": WeatherSystem.current_weather,
            "killed_npcs": WorldState.killed_npcs,
            "opened_doors": WorldState.opened_doors
        },
        "quests": {
            "active": QuestSystem.get_active_ids(),
            "completed": QuestSystem.get_completed_ids(),
            "progress": QuestSystem.get_all_progress()
        },
        "reputation": ReputationSystem.get_all_factions(),
        "achievements": AchievementSystem.get_unlocked_ids(),
        "timestamp": Time.get_datetime_string_from_system()
    }
    
    var file = FileAccess.open(SAVE_DIR + "slot_" + str(slot) + ".save", FileAccess.WRITE)
    if file:
        file.store_var(data)
        return true
    return false

func load_game(slot: int) -> bool:
    var path = SAVE_DIR + "slot_" + str(slot) + ".save"
    if not FileAccess.file_exists(path):
        return false
    
    var file = FileAccess.open(path, FileAccess.READ)
    var data = file.get_var()
    
    # Відновити всі системи
    Player.global_position = data.player.position
    Player.health = data.player.health
    Player.mana = data.player.mana
    Player.inventory.load(data.player.inventory)
    Player.equipment.load(data.player.equipment)
    
    TimeSystem.load(data.world.time)
    WeatherSystem.current_weather = data.world.weather
    WorldState.killed_npcs = data.world.killed_npcs
    WorldState.opened_doors = data.world.opened_doors
    
    QuestSystem.load_state(data.quests.active, data.quests.completed, data.quests.progress)
    ReputationSystem.load(data.reputation)
    AchievementSystem.load(data.achievements)
    
    return true

func get_save_info(slot: int) -> Dictionary:
    var path = SAVE_DIR + "slot_" + str(slot) + ".save"
    if not FileAccess.file_exists(path):
        return {"exists": false}
    
    var file = FileAccess.open(path, FileAccess.READ)
    var data = file.get_var()
    return {
        "exists": true,
        "timestamp": data.timestamp,
        "location": WorldState.get_location_name(data.player.position),
        "level": data.player.level if data.player.has("level") else "?",
        "gold": data.player.gold if data.player.has("gold") else "?"
    }
```
