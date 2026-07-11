extends Node3D
## PortalSpawner — читає portal_map.json і автоматично створює LocationPortal вузли.
##
## Додати як дочірній вузол у корінь сцени. У _ready()
## знаходить свою сцену в мапі й створює портали.
class_name PortalSpawner

func _ready() -> void:
	var scene_path := _current_scene_path()
	if scene_path.is_empty():
		return

	var config := _load_portal_map()
	if config.is_empty():
		return

	var portals: Array = config.get("portals", {}).get(scene_path, [])
	if portals.is_empty():
		return

	for pdata in portals:
		_create_portal(pdata)

func _current_scene_path() -> String:
	return get_tree().current_scene.scene_file_path

func _load_portal_map() -> Dictionary:
	var path := "res://data/locations/portal_map.json"
	if not FileAccess.file_exists(path):
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	var text := file.get_as_text()
	file.close()
	var json := JSON.new()
	if json.parse(text) != OK:
		return {}
	return json.data

func _create_portal(pdata: Dictionary) -> void:
	var portal := Area3D.new()
	portal.name = "Portal_" + pdata.get("label", "?").replace(" ", "_")

	var col := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(2, 3, 2)
	col.shape = box
	portal.add_child(col)

	var pos: Array = pdata.get("pos", [0, 1, 0])
	portal.position = Vector3(pos[0], pos[1], pos[2])

	var script := load("res://scripts/gameplay/LocationPortal.gd")
	if script:
		portal.set_script(script)
		portal.set("destination_scene", pdata.get("to", ""))
		portal.set("destination_location", pdata.get("label", ""))
		portal.set("prompt", pdata.get("label", "Перейти"))
		if pdata.has("quest_start"):
			portal.set("start_quest_id", pdata["quest_start"])

	portal.add_to_group("interactable")
	add_child(portal)
	print("PortalSpawner: added portal → ", pdata.get("label", "?"))
