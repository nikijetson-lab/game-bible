extends Label3D
## LabelCyrillicFix — сам собі ставить системний шрифт для кирилиці.
## Ізольоване рішення для окремих Label3D, які FontFix не може виправити.

func _ready() -> void:
	call_deferred("_apply")

func _apply() -> void:
	var paths := [
		"C:/Windows/Fonts/arial.ttf",
		"C:/Windows/Fonts/segoeui.ttf",
	]
	for p in paths:
		if FileAccess.file_exists(p):
			var res := ResourceLoader.load(p, "", ResourceLoader.CACHE_MODE_IGNORE)
			if res is FontFile:
				font = res as FontFile
				return
