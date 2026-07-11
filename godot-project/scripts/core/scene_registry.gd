extends Node
## SceneRegistry — мапінг логічних назв локацій на .tscn файли.
##
## Використовується GameManager для навігації між сценами
## за назвою локації з квестів.

# Мапа: логічна назва (як у quest JSON location/start_location) → шлях сцени
const LOCATION_TO_SCENE := {
	# Greyford
	"greyford_tavern": "res://scenes/locations/greyford/TavernInterior.tscn",
	"greyford_craftsmen_quarter": "res://scenes/locations/greyford/CraftsmenQuarter.tscn",
	"greyford_street": "res://scenes/locations/greyford/GreyfordStreet.tscn",
	"greyford_rufin_room": "res://scenes/locations/greyford/RufinRoom.tscn",
	"greyford_alteya_hidden_room": "res://scenes/locations/greyford/AlteyaHiddenRoom.tscn",
	"greyford_gate": "res://scenes/locations/greyford/GreyfordGate.tscn",
	"greyford_port_tavern": "res://scenes/locations/greyford/PortTavernInterior.tscn",

	# Hazemoor / Swamp
	"hazemoor": "res://scenes/locations/hazemoor/SwampPath.tscn",
	"hazemoor_entrance": "res://scenes/locations/hazemoor/SwampPath.tscn",
	"swamp_path_01": "res://scenes/locations/hazemoor/SwampPath.tscn",
	"first_clearing": "res://scenes/locations/hazemoor/SwampPath.tscn",
	"deep_bog": "res://scenes/locations/deep_bog/DeepBog.tscn",
	"deep_bog_entry": "res://scenes/locations/deep_bog/DeepBog.tscn",
	"mad_river": "res://scenes/locations/deep_bog/MadFerry.tscn",
	"mad_ferry_approach": "res://scenes/locations/deep_bog/MadFerry.tscn",

	# Tykhy Shelest
	"tykhy_shelest": "res://scenes/locations/tykhy_shelist/TykhyShelist.tscn",
	"tykhy_shelest_healer_house": "res://scenes/locations/tykhy_shelist/TykhyShelist.tscn",
	"tykhy_shelest_swamp_edge": "res://scenes/locations/tykhy_shelist/TykhyShelist.tscn",
	"stone_tower_tykhy_shelest": "res://scenes/locations/tykhy_shelist/TykhyShelist.tscn",
	"forbidden_glade": "res://scenes/locations/tykhy_shelist/ForbiddenGlade.tscn",

	# Sonk Ferry
	"sonk_ferry": "res://scenes/locations/sonk_ferry/SonkFerry.tscn",
	"sonk_ferry_dock": "res://scenes/locations/sonk_ferry/SonkFerry.tscn",
	"sonk_ferry_shore": "res://scenes/locations/sonk_ferry/SonkFerry.tscn",
	"sonk_ferry_admin": "res://scenes/locations/sonk_ferry/SonkFerry.tscn",
	"flooded_chamber": "res://scenes/locations/sonk_ferry/FloodedChamber.tscn",
	"flooded_chapel": "res://scenes/locations/sonk_ferry/FloodedChapel.tscn",
	"salt_warehouse": "res://scenes/locations/sonk_ferry/SaltWarehouse.tscn",
	"damaged_ferry_dock": "res://scenes/locations/sonk_ferry/SonkFerry.tscn",
	"sunk_watchtower_road": "res://scenes/locations/sonk_ferry/SonkFerry.tscn",
	"mirefold": "res://scenes/locations/sonk_ferry/SonkFerry.tscn",
	"st_vey": "res://scenes/locations/sonk_ferry/SonkFerry.tscn",
	"kelm_office": "res://scenes/locations/sonk_ferry/SonkFerry.tscn",

	# Valkorn
	"valkorn": "res://scenes/locations/valkorn/PortQuarter.tscn",
	"valkorn_gate": "res://scenes/locations/valkorn/PortQuarter.tscn",
	"valkorn_market_square": "res://scenes/locations/valkorn/PortQuarter.tscn",
	"valkorn_palace_quarter": "res://scenes/locations/valkorn/PortQuarter.tscn",
	"valkorn_new_ghetto": "res://scenes/locations/valkorn/PortQuarter.tscn",
	"valkorn_trade_quarter": "res://scenes/locations/valkorn/PortQuarter.tscn",
	"valkorn_diplomatic_quarter": "res://scenes/locations/valkorn/PortQuarter.tscn",
	"valkorn_palace": "res://scenes/locations/valkorn/PortQuarter.tscn",
	"black_archive": "res://scenes/locations/valkorn/BlackArchive.tscn",
	"black_archive_under_library": "res://scenes/locations/valkorn/BlackArchive.tscn",
	"valkorn_undercity": "res://scenes/locations/valkorn/Undercity.tscn",
	"guild_warehouse": "res://scenes/locations/valkorn/GuildWarehouse.tscn",

	# Ep3 — Flooded Sanctuary
	"flooded_sanctuary_crypt": "res://scenes/locations/deep_bog/FloodedAbbey.tscn",

	# Ep4
	"hazemoor_valkorn_border": "res://scenes/locations/hazemoor/SwampPath.tscn",
	"mour_heart": "res://scenes/locations/deep_bog/DeepBog.tscn",
	"epilogue": "res://scenes/main_menu.tscn",

	# System
	"main_menu": "res://scenes/main_menu.tscn",
}


## Повертає шлях сцени для локації, або "" якщо не знайдено.
func scene_for(location_id: String) -> String:
	return LOCATION_TO_SCENE.get(location_id, "")


## Повертає шлях сцени для квесту (за start_location).
func scene_for_quest(quest_id: String) -> String:
	var qm := get_node_or_null("/root/Quests")
	if not qm:
		return ""
	var data: Dictionary = qm.get_quest_data(quest_id)
	var loc: String = data.get("start_location", "")
	if loc.is_empty():
		# fallback: перший об'єктив із location
		for obj in data.get("objectives", []):
			loc = obj.get("location", "")
			if not loc.is_empty():
				break
	return scene_for(loc)


## Патчі для непрямих переходів (quest_id -> target_scene_path).
## Заповнюється коли один квест веде до іншого через leads_to.
var _quest_route_map := {}


## Зареєструвати прямий маршрут між квестами.
func register_quest_route(from_quest_id: String, to_scene: String) -> void:
	_quest_route_map[from_quest_id] = to_scene


## Отримати сцену в яку треба перейти після квесту.
func route_after_quest(quest_id: String) -> String:
	if _quest_route_map.has(quest_id):
		return _quest_route_map[quest_id]
	var leads = _get_leads_to(quest_id)
	for next_id in leads:
		var s := scene_for_quest(next_id)
		if not s.is_empty():
			return s
	return ""


func _get_leads_to(quest_id: String) -> Array:
	var qm := get_node_or_null("/root/Quests")
	if not qm:
		return []
	var data: Dictionary = qm.get_quest_data(quest_id)
	var lt = data.get("leads_to")
	if lt is String:
		return [lt]
	if lt is Array:
		return lt
	return data.get("unlocks", [])
