# 🎮 Система Меню та Налаштувань

## Головне Меню

```gdscript
# menu.gd
extends Control

enum MENU_STATE { MAIN, SETTINGS, LOAD, CREDITS }

var current_state = MENU_STATE.MAIN

func _ready():
    show_main_menu()

func show_main_menu():
    $MainMenu.visible = true
    $Settings.visible = false
    $LoadMenu.visible = false

func _on_new_game_pressed():
    if SaveSystem.has_saves():
        $ConfirmNewGame.visible = true  # "Ви впевнені? Всі старі збереження будуть втрачені"
    else:
        start_new_game()

func _on_load_game_pressed():
    update_save_list()
    show_menu(MENU_STATE.LOAD)

func _on_settings_pressed():
    show_menu(MENU_STATE.SETTINGS)

func _on_quit_pressed():
    get_tree().quit()

func start_new_game():
    SaveSystem.clear_all()
    get_tree().change_scene_to_file("res://scenes/main.tscn")
```

## Екран Смерті

```gdscript
# death_screen.gd
extends Control

func _ready():
    show_death_options()

func show_death_options():
    var options = [
        {"text": "Завантажити останнє збереження", "action": "load_last"},
        {"text": "Почати з початку", "action": "new_game"},
        {"text": "Повернутись у меню", "action": "main_menu"}
    ]
    
    # Якщо гравець має "Амулет Воскресіння" — додати опцію
    if Inventory.has_item("resurrection_amulet"):
        options.append({"text": "Використати Амулет Воскресіння", "action": "ressurect"})
    
    show_options(options)
```

## Екран Завантаження

```gdscript
# loading_screen.gd
extends CanvasLayer

func show_loading(next_scene: String):
    visible = true
    $ProgressBar.value = 0
    $TipLabel.text = get_random_tip()
    
    # Фонове завантаження
    ResourceLoader.load_threaded_request(next_scene)
    
    while true:
        var progress = []
        var state = ResourceLoader.load_threaded_get_status(next_scene, progress)
        $ProgressBar.value = progress[0] * 100
        
        if state == ResourceLoader.THREAD_LOAD_LOADED:
            var scene = ResourceLoader.load_threaded_get(next_scene)
            get_tree().change_scene_to_packed(scene)
            visible = false
            return
        
        await get_tree().process_frame

func get_random_tip() -> String:
    var tips = [
        "Прокляті мечі вимагають крові...",
        "Не йди в болото вночі без смолоскипа",
        "Культисти Моура не сплять ніколи",
        "Тіньовий ринок працює тільки після заходу",
        "Деякі двері відчиняються тільки кров'ю"
    ]
    return tips[randi() % tips.size()]
```

## Пауза

```gdscript
# pause_menu.gd
extends Control

func _input(event):
    if event.is_action_pressed("pause"):
        if visible:
            resume_game()
        else:
            pause_game()

func pause_game():
    visible = true
    get_tree().paused = true

func resume_game():
    visible = false
    get_tree().paused = false

func _on_save_pressed():
    SaveSystem.save_game(SaveSystem.current_slot)
    $SaveNotification.show()
    
func _on_quit_pressed():
    get_tree().paused = false
    get_tree().change_scene_to_file("res://scenes/menu.tscn")
```
