extends Control
## Main Menu — головне меню гри.
## Запускає першу сцену (Greyford Tavern) і стартовий квест.

func _ready() -> void:
	%StartButton.grab_focus()
	%StartButton.pressed.connect(_on_start_pressed)

func _on_start_pressed() -> void:
	# Перейти до Greyford Tavern — стартова локація
	GameManager.change_scene("res://scenes/locations/greyford/TavernInterior.tscn")
