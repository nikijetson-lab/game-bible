extends Area3D
## NPCBehavior — базова взаємодія для сюжетних NPC.
##
## Скрипт навмисно невеликий: він дає сценам реальний інтерактивний вузол,
## підключає NPC до AIPlanner і, якщо доступний автолоад Dialogue, запускає
## існуючий DialogueManager.

class_name NPCBehavior

const AIPlanner = preload("res://scripts/ai/AIPlanner.gd")

signal interaction_started(npc_id: String, dialogue_id: String)
signal intent_chosen(npc_id: String, intent_data: Dictionary)

@export var npc_id: String = "npc"
@export var npc_display_name: String = "NPC"
@export var default_dialogue_id: String = "default"
@export var interaction_prompt: String = "Говорити"
@export var interaction_enabled: bool = true
@export var npc_state: Dictionary = {}
@export var world_context: Dictionary = {}

var last_intent: Dictionary = {}
var player_in_range: Node3D = null

func _ready() -> void:
	add_to_group("npcs")
	add_to_group("interactable")
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	if npc_state.is_empty():
		npc_state = {
			"id": npc_id,
			"name": npc_display_name,
			"dialogues": {default_dialogue_id: "%s/%s.json" % [npc_id, default_dialogue_id]}
		}

func interact(player: Node = null) -> Dictionary:
	"""Викликати взаємодію з NPC і повернути контекст діалогу."""
	if not interaction_enabled:
		return {}

	var player_context: Dictionary = _build_player_context(player)
	last_intent = AIPlanner.choose_intent(npc_state, world_context, player_context)
	intent_chosen.emit(npc_id, last_intent)

	var dialogue_id: String = str(last_intent.get("dialogue_id", default_dialogue_id))
	if dialogue_id == "default" and default_dialogue_id != "default":
		dialogue_id = default_dialogue_id

	var dialogue_context := AIPlanner.build_dialogue_context(npc_id, npc_display_name, dialogue_id, last_intent)
	interaction_started.emit(npc_id, dialogue_id)
	_try_start_dialogue(dialogue_id)
	return dialogue_context

func get_interaction_prompt() -> String:
	return "%s: %s" % [interaction_prompt, npc_display_name]

func can_interact(player: Node = null) -> bool:
	return interaction_enabled and (player == null or player == player_in_range or player.is_in_group("player"))

func _build_player_context(player: Node = null) -> Dictionary:
	var context: Dictionary = {}
	if player != null:
		context["player_name"] = player.name
	context["met_%s" % npc_id] = false
	return context

func _try_start_dialogue(dialogue_id: String) -> void:
	if Engine.has_singleton("Dialogue"):
		var dialogue_singleton = Engine.get_singleton("Dialogue")
		if dialogue_singleton != null and dialogue_singleton.has_method("start_dialogue"):
			dialogue_singleton.start_dialogue(npc_id, dialogue_id)
	elif get_node_or_null("/root/Dialogue") != null:
		get_node("/root/Dialogue").start_dialogue(npc_id, dialogue_id)
	else:
		print("Dialogue requested: %s/%s" % [npc_id, dialogue_id])

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_range = body

func _on_body_exited(body: Node3D) -> void:
	if body == player_in_range:
		player_in_range = null
