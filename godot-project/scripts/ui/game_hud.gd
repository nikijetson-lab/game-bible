extends Control
## GameHUD — головний HUD гри.
##
## Автоматично додає всі UI панелі: QuestJournal (J), Evidence (E),
## Inventory (I), Reputation (R).

func _ready() -> void:
	for cls in [
		"res://scripts/ui/quest_journal.gd",
		"res://scripts/ui/evidence_ui.gd",
		"res://scripts/ui/inventory_ui.gd",
		"res://scripts/ui/reputation_ui.gd",
	]:
		var scr = load(cls)
		if scr:
			var node = scr.new()
			node.name = cls.get_file().get_basename()
			add_child(node)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		GameManager.pause_game()
