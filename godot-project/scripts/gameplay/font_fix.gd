extends Node
## FontFix — виправляє кириличні Label3D у сцені.
##
## Проходить по всіх Label3D, перевіряє чи текст містить кирилицю,
## і якщо так — встановлює системний шрифт із підтримкою кирилиці.
class_name FontFix

func _ready() -> void:
	call_deferred("_fix_labels")

func _fix_labels() -> void:
	var root := get_tree().current_scene
	if not root: return
	_fix_node(root)

func _fix_node(node: Node) -> void:
	if node is Label3D:
		var lbl: Label3D = node as Label3D
		var text: String = lbl.text
		if _has_cyrillic(text):
			_apply_cyrillic_font(lbl)
	for child in node.get_children():
		_fix_node(child)

func _has_cyrillic(text: String) -> bool:
	for ch in text:
		var code := ch.unicode_at(0)
		if code >= 0x0400 and code <= 0x04FF:
			return true
	return false

func _apply_cyrillic_font(lbl: Label3D) -> void:
	# Спробувати системний шрифт із кирилицею
	var sys_paths := [
		"C:/Windows/Fonts/arial.ttf",
		"C:/Windows/Fonts/segoeui.ttf",
		"C:/Windows/Fonts/tahoma.ttf",
		"/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
	]
	for path in sys_paths:
		if FileAccess.file_exists(path):
			var font := FontFile.new()
			font.font_path = path
			lbl.font = font
			return
