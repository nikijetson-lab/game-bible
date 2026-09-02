extends SceneTree

const ROWS := [
    {"scene":"res://scenes/locations/greyford/TavernInterior.tscn", "node":"NPCs/Ervan/MeshyErvanModel", "out":"npc_ervan"},
    {"scene":"res://scenes/locations/greyford/TavernInterior.tscn", "node":"BackgroundPatrons/OldWomanPatron/MeshyOldWomanModel", "out":"npc_old_woman"},
    {"scene":"res://scenes/locations/greyford/PortTavernInterior.tscn", "node":"NPCs/PortBartender/MeshyBartenderModel", "out":"npc_port_bartender"},
    {"scene":"res://scenes/locations/greyford/CraftsmenQuarter.tscn", "node":"NPCs/Furrier/MeshyFurrierModel", "out":"npc_furrier"},
    {"scene":"res://scenes/locations/greyford/CraftsmenQuarter.tscn", "node":"NPCs/Woodcarver/MeshyWoodcarverModel", "out":"npc_woodcarver"},
    {"scene":"res://scenes/locations/greyford/GreyfordGate.tscn", "node":"NPCs/GateSergeant/MeshySergeantModel", "out":"npc_gate_sergeant"},
    {"scene":"res://scenes/locations/greyford/AlteyaHiddenRoom.tscn", "node":"NPCs/Alteya/MeshyAlteyaModel", "out":"npc_alteya"},
]
var idx := 0
var frames := 0
var stage: Node3D
var camera: Camera3D

func _init() -> void:
    seed(41001)
    call_deferred("next_shot")

func next_shot() -> void:
    if stage:
        stage.queue_free()
    stage = Node3D.new()
    root.add_child(stage)
    var row: Dictionary = ROWS[idx]
    var packed: PackedScene = load(row["scene"])
    var source: Node = packed.instantiate()
    var model: Node3D = source.get_node(row["node"])
    model.reparent(stage)
    model.transform.origin = Vector3.ZERO
    source.free()
    var floor_mesh := BoxMesh.new()
    floor_mesh.size = Vector3(8, 0.1, 8)
    var floor := MeshInstance3D.new()
    floor.mesh = floor_mesh
    floor.position.y = -0.05
    stage.add_child(floor)
    var env := WorldEnvironment.new()
    var environment := Environment.new()
    environment.background_mode = Environment.BG_COLOR
    environment.background_color = Color(0.06, 0.075, 0.09)
    environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    environment.ambient_light_color = Color(0.75, 0.78, 0.84)
    environment.ambient_light_energy = 0.85
    env.environment = environment
    stage.add_child(env)
    var light := DirectionalLight3D.new()
    light.rotation_degrees = Vector3(-48, -28, 0)
    light.light_energy = 1.4
    stage.add_child(light)
    if not camera:
        camera = Camera3D.new()
        camera.fov = 46.0
        camera.near = 0.08
        root.add_child(camera)
        camera.make_current()
        DirAccess.make_dir_recursive_absolute("res://screenshots/npc_audit")
    camera.global_position = Vector3(0, 1.22, 3.15)
    camera.look_at(Vector3(0, 0.82, 0), Vector3.UP)
    frames = 0

func _process(_delta: float) -> bool:
    frames += 1
    if frames < 96:
        return false
    var row: Dictionary = ROWS[idx]
    root.get_viewport().get_texture().get_image().save_png("res://screenshots/npc_audit/" + row["out"] + ".png")
    print("NPC_SHOT: " + row["out"])
    idx += 1
    if idx >= ROWS.size():
        print("NPC_AUDIT_ALL_DONE")
        quit()
        return true
    call_deferred("next_shot")
    return false
