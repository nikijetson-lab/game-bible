extends SceneTree

var _scene: Control

func _init() -> void:
	var p := load("res://scenes/map/WorldMap.tscn")
	_scene = p.instantiate()
	_scene.debug_show_all = true
	_scene.visible = true
	get_root().add_child(_scene)
	if _scene.has_method("_open"):
		_scene._open()
	call_deferred("_finish")

func _finish() -> void:
	# Let one more frame pass for markers
	call_deferred("_screenshot")

func _screenshot() -> void:
	var f := FileAccess.open("E:/Hazemoor/game-bible/godot-project/_wm_render.log", FileAccess.WRITE)
	var rb := _scene.get_node_or_null("RegionButtons")
	var n := 0
	if rb:
		for c in rb.get_children():
			if c is Button:
				n += 1
	f.store_line("MARKERS=" + str(n))

	get_root().get_viewport().size = Vector2i(1920, 1080)
	_scene.size = Vector2(1920, 1080)

	var img := get_root().get_viewport().get_texture().get_image()
	if img.is_empty():
		f.store_line("IMG=EMPTY")
	else:
		img.save_png("E:/Hazemoor/game-bible/godot-project/_wm_render.png")
		f.store_line("IMG=OK " + str(img.get_size()))
	f.close()
	quit(0)
