extends RefCounted
## AIPlanner — мінімальний планувальник намірів для сюжетних NPC.
##
## Це не LLM-агент і не бойовий AI. Його задача на першому етапі —
## стабільно вирішувати, що NPC має робити під час взаємодії з гравцем:
## говорити, дати квест, торгувати, поділитися чуткою або просто чекати.

class_name AIPlanner

enum Intent {
	IDLE,
	TALK,
	GIVE_QUEST,
	TRADE,
	SHARE_RUMOR,
	WARN_PLAYER
}

static func choose_intent(npc_state: Dictionary, world_context: Dictionary = {}, player_context: Dictionary = {}) -> Dictionary:
	"""Повернути опис наміру NPC для поточної взаємодії."""
	var services: Dictionary = npc_state.get("services", {})
	var quests: Dictionary = npc_state.get("quests", {})
	var available_dialogues: Dictionary = npc_state.get("dialogues", {})
	var danger_level: int = int(world_context.get("danger_level", 0))
	var has_met_player: bool = bool(player_context.get("met_%s" % npc_state.get("id", "npc"), false))

	if danger_level >= 7:
		return _intent(Intent.WARN_PLAYER, "warn", "Небезпека поруч — NPC попереджає гравця.")

	if quests.get("gives", []).size() > 0 and not has_met_player:
		return _intent(Intent.GIVE_QUEST, "first_meeting", "NPC має першу важливу розмову або квестовий гачок.")

	if bool(services.get("rumor_source", false)):
		return _intent(Intent.SHARE_RUMOR, "rumors", "NPC може поділитися чуткою.")

	if available_dialogues.has("first_meeting") and not has_met_player:
		return _intent(Intent.TALK, "first_meeting", "Перше знайомство з NPC.")

	if bool(services.get("merchant", false)) or bool(services.get("innkeeper", false)):
		return _intent(Intent.TRADE, "default", "NPC доступний як сервісний персонаж.")

	return _intent(Intent.TALK, "default", "Звичайна розмова.")

static func build_dialogue_context(npc_id: String, npc_display_name: String, dialogue_id: String, intent_data: Dictionary = {}) -> Dictionary:
	"""Зібрати компактний контекст, який може використати DialogueManager або UI."""
	return {
		"npc_id": npc_id,
		"npc_display_name": npc_display_name,
		"dialogue_id": dialogue_id,
		"intent": intent_data.get("intent", Intent.TALK),
		"intent_name": describe_intent(int(intent_data.get("intent", Intent.TALK))),
		"reason": intent_data.get("reason", "")
	}

static func describe_intent(intent: int) -> String:
	match intent:
		Intent.IDLE:
			return "idle"
		Intent.TALK:
			return "talk"
		Intent.GIVE_QUEST:
			return "give_quest"
		Intent.TRADE:
			return "trade"
		Intent.SHARE_RUMOR:
			return "share_rumor"
		Intent.WARN_PLAYER:
			return "warn_player"
		_:
			return "unknown"

static func _intent(intent: int, dialogue_id: String, reason: String) -> Dictionary:
	return {
		"intent": intent,
		"intent_name": describe_intent(intent),
		"dialogue_id": dialogue_id,
		"reason": reason
	}
