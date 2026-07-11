extends Control
## GameHUD — головний HUD гри.
##
## Автоматично додає QuestJournal як дочірній вузол.
## Клавіші: J = журнал квестів, ESC = меню паузи.

func _ready() -> void:
	# Додати QuestJournal
	var qj_scene: PackedScene = load("res://scenes/ui/quest_journal.tscn")
	if qj_scene:
		var qj: Node = qj_scene.instantiate()
		qj.name = "QuestJournal"
		add_child(qj)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		GameManager.pause_game()

