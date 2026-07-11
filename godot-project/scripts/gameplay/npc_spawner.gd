extends Node3D
## NPCSpawner — читає npc_placement.json і створює NPC з діалогами.
##
## Завантажує GLB-моделі, додає InteractionArea для діалогів,
## і прив'язує NPC до DialogueManager.
class_name NPCSpawner

func _ready() -> void:
	var scene_path := get_tree().current_scene.scene_file_path
	if scene_path.is_empty():
		return

	var config := _load_config()
	if config.is_empty():
		return

	var npcs: Array = config.get("npcs", {}).get(scene_path, [])
	for ndata in npcs:
		_spawn_npc(ndata)

func _load_config() -> Dictionary:
	var path := "res://data/npcs/npc_placement.json"
	if not FileAccess.file_exists(path):
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	var json := JSON.new()
	if json.parse(file.get_as_text()) != OK:
		return {}
	file.close()
	return json.data

func _spawn_npc(ndata: Dictionary) -> void:
	var npc := Node3D.new()
	npc.name = "NPC_" + ndata.get("npc_id", "unknown")

	var pos: Array = ndata.get("pos", [0, 0, 0])
	npc.position = Vector3(pos[0], pos[1], pos[2])

	# Спробувати завантажити GLB модель
	var glb_path: String = ndata.get("glb", "")
	if not glb_path.is_empty() and ResourceLoader.exists(glb_path):
		var model := load(glb_path)
		if model:
			var instance: Node = model.instantiate()
			if instance:
				instance.name = "Model"
				npc.add_child(instance)

	# Діалогова зона
	var area := Area3D.new()
	area.name = "InteractionArea"
	area.add_to_group("interactable")
	var col := CollisionShape3D.new()
	var shape := SphereShape3D.new()
	shape.radius = 2.5
	col.shape = shape
	area.add_child(col)

	# Прив'язати діалог через метадані
	var npc_id: String = ndata.get("npc_id", "")
	var dialogue_id: String = ndata.get("dialogue", "")
	var npc_name: String = ndata.get("name", npc_id)
	area.set_meta("npc_id", npc_id)
	area.set_meta("dialogue_id", dialogue_id)
	area.set_meta("npc_name", npc_name)

	# Додати interact() метод
	var script := GDScript.new()
	script.source_code = """extends Area3D
func interact(_actor: Node) -> Dictionary:
	var dm := get_node_or_null("/root/Dialogue")
	if dm:
		var nid: String = get_meta("npc_id", "")
		dm.start_dialogue(nid)
	return {"type": "npc_dialogue"}
func get_interaction_prompt() -> String:
	return "Поговорити з " + str(get_meta("npc_name", "NPC"))
"""
	script.reload()
	area.set_script(script)

	npc.add_child(area)

	# Стартовий квест (опціонально)
	var sq: String = ndata.get("start_quest", "")
	if not sq.is_empty():
		npc.set_meta("start_quest", sq)

	add_child(npc)
	print("NPCSpawner: spawned ", ndata.get("name", "?"), " @ ", npc.position)
