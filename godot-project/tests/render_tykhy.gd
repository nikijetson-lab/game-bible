extends SceneTree

var _scene: Node
var _cam: Camera3D
var _frame: int = 0

func _init() -> void:
    call_deferred("_setup")

func _setup() -> void:
    var packed: PackedScene = load("res://scenes/locations/tykhy_shelist/TykhyShelist.tscn")
    _scene = packed.instantiate()
    root.add_child(_scene)

    # Hide Player + labels
    for child in _scene.get_children():
        if child.name == "Player" or child.name == "NPCs" or "Label" in child.name:
            child.visible = false if child.name == "Player" else true

    _cam = Camera3D.new()
    _cam.current = true
    _cam.position = Vector3(0, 8, 25)
    _cam.look_at(Vector3(0, 1, -10))

    var env: Environment = Environment.new()
    env.background_mode = Environment.BG_COLOR
    env.background_color = Color(0.04, 0.06, 0.05)
    _cam.environment = env

    root.add_child(_cam)

func _process(_delta: float) -> bool:
    _frame += 1
    if _frame < 28:
        return false
    var img: Image = get_root().get_viewport().get_texture().get_image()
    if img == null or img.is_empty():
        printerr("NO_IMAGE")
        quit(1)
        return true
    img.save_png("user://tykhy_shelest_overview.png")
    print("SHOT_SAVED: tykhy_shelest_overview.png")
    quit(0)
    return true
