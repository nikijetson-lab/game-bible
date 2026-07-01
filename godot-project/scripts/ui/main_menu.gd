extends Control

func _ready() -> void:
	%StartButton.grab_focus()
	%StartButton.pressed.connect(_on_start_pressed)

func _on_start_pressed() -> void:
	GameManager.change_scene("res://scenes/environments/test_level.tscn")
