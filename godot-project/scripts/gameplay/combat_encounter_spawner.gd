extends Node3D
## CombatEncounterSpawner — розставляє ворогів згідно combat_encounters.json.
##
## Перевіряє quest_required перед спавном, повідомляє QuestManager при зачистці.
class_name CombatEncounterSpawner

var _enemies_alive: int = 0
var _objective_id: String = ""

func _ready() -> void:
	var scene_path := get_tree().current_scene.scene_file_path
	if scene_path.is_empty(): return

	var config := _load_config()
	if config.is_empty(): return

	var encounters: Array = config.get("encounters", {}).get(scene_path, [])
	for edata in encounters:
		if not _check_quest_gate(edata.get("quest_required", "")):
			continue
		_spawn_encounter(edata)

func _load_config() -> Dictionary:
	var path := "res://data/encounters/combat_encounters.json"
	if not FileAccess.file_exists(path): return {}
	var file := FileAccess.open(path, FileAccess.READ)
	var json := JSON.new()
	if json.parse(file.get_as_text()) != OK: return {}
	file.close()
	return json.data

func _check_quest_gate(quest_id: String) -> bool:
	if quest_id.is_empty(): return true
	var qm := get_node_or_null("/root/Quests")
	if not qm: return false
	return quest_id in qm.active_quests or quest_id in qm.completed_quests

func _spawn_encounter(edata: Dictionary) -> void:
	var etype: String = edata.get("enemy_type", "swamp_lurker")
	var count: int = edata.get("count", 1)
	var pos: Array = edata.get("pos", [0, 1, 0])
	var spread: float = edata.get("spread", 2.0)
	_objective_id = edata.get("objective_on_clear", "")

	_enemies_alive = count
	for i in range(count):
		var offset := Vector3(randf_range(-spread, spread), 0, randf_range(-spread, spread))
		var spawn_pos := Vector3(pos[0], pos[1], pos[2]) + offset
		var enemy := _create_enemy(etype, edata, spawn_pos)
		if enemy:
			enemy.add_to_group("encounter_enemy")
			if enemy.has_signal("died"):
				enemy.died.connect(_on_enemy_died)
			add_child(enemy)

func _create_enemy(etype: String, edata: Dictionary, pos: Vector3) -> Node:
	var enemy := CharacterBody3D.new()
	enemy.name = etype
	enemy.position = pos

	var health := HealthComponent.new()
	var elite: Dictionary = edata.get("elite_stats", {})
	health.max_health = elite.get("hp", 60.0)
	health.current_health = health.max_health
	health.defense = elite.get("armor", 5.0)
	health.name = "HealthComponent"
	enemy.add_child(health)

	var script := load("res://scripts/gameplay/enemy_ai.gd")
	if script:
		enemy.set_script(script)
		enemy.set("max_health", health.max_health)
		enemy.set("attack_damage", elite.get("damage", 15.0))
		enemy.set("detection_range", 12.0)

	var col := CollisionShape3D.new()
	var shape := CapsuleShape3D.new()
	shape.radius = 0.5; shape.height = 2.0
	col.shape = shape
	enemy.add_child(col)

	print("CombatEncounterSpawner: spawned ", etype, " @ ", pos)
	return enemy

func _on_enemy_died() -> void:
	_enemies_alive -= 1
	if _enemies_alive <= 0 and not _objective_id.is_empty():
		var qm := get_node_or_null("/root/Quests")
		if qm and qm.has_method("complete_objective"):
			qm.complete_objective(
				"sonk_ferry_01_hunger_from_below", _objective_id)
		print("CombatEncounterSpawner: encounter cleared! objective=", _objective_id)

func has_active_encounter() -> bool:
	return _enemies_alive > 0
