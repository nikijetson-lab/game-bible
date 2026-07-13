extends Node
## FontFix — виправляє кириличні Label3D у сцені.
##
## Проходить по всіх Label3D, перевіряє чи текст містить кирилицю,
## і якщо так — встановлює системний шрифт із підтримкою кирилиці.
class_name FontFix

var _cached_font: FontFile = null

func _ready() -> void:
	call_deferred("_fix_labels")

func _fix_labels() -> void:
	var root := get_tree().current_scene
	if not root: return
	_load_font_once()
	_fix_node(root)

func _load_font_once() -> void:
	if _cached_font != null: return
	var sys_paths := [
		"C:/Windows/Fonts/arial.ttf",
		"C:/Windows/Fonts/segoeui.ttf",
		"C:/Windows/Fonts/tahoma.ttf",
		"/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
	]
	for path in sys_paths:
		if FileAccess.file_exists(path):
			var res := ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)
			if res is FontFile:
				_cached_font = res as FontFile
				return

func _fix_node(node: Node) -> void:
	if node is Label3D:
		var lbl: Label3D = node as Label3D
		if _has_cyrillic(lbl.text) and _cached_font != null:
			lbl.font = _cached_font
	for child in node.get_children():
		_fix_node(child)

func _has_cyrillic(text: String) -> bool:
	for ch in text:
		var code := ch.unicode_at(0)
		if code >= 0x0400 and code <= 0x04FF:
			return true
	return false
