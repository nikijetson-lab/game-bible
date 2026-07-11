extends Area3D
## LocationPortal — тригерна зона для переходу між сценами.
##
## Розмістити як дочірній вузол у сцені-джерелі.
## Коли гравець входить, викликає GameManager.change_scene(target_scene).
## Опціонально може запустити квест після переходу.
## NOTE: class_name визначено в scripts/gameplay/LocationPortal.gd

## Шлях до цільової сцени (.tscn)
@export var target_scene: String = ""

## ID квесту, який треба спробувати запустити після переходу
@export var start_quest_id: String = ""

## Ярлик локації для UI (напр. "Тихий Шелест")
@export var location_label: String = ""

func _ready() -> void:
	if target_scene.is_empty():
		push_warning("LocationPortal: target_scene not set for ", name)
		return
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group("Player"):
		return
	_travel()

func _travel() -> void:
	var gm: Node = _game_manager()
	if not gm:
		return

	# Якщо є квест для запуску — пробуємо
	if not start_quest_id.is_empty():
		var qm: Node = _quest_manager()
		if qm and qm.has_method("try_start_quest"):
			qm.try_start_quest(start_quest_id)

	# Міняємо сцену
	gm.change_scene(target_scene)

func _game_manager():
	return get_node_or_null("/root/GameManager")

func _quest_manager():
	return get_node_or_null("/root/Quests")

