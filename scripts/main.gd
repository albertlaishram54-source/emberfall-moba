extends Node3D

var player
var status_label: Label
var health_bar: ProgressBar
var enemy_count := 4

func _ready() -> void:
    _make_environment()
    _make_arena()
    player = _make_player()
    for i in range(enemy_count):
        _make_enemy(Vector3(-7.0 + float(i) * 4.5, 0.0, -7.0))
    _make_ui()
    _update_status("Defeat the enemy guardians!")

func _make_environment() -> void:
    var world_env := WorldEnvironment.new()
    var env := Environment.new()
    env.background_mode = Environment.BG_SKY
    env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    env.ambient_light_color = Color(0.58, 0.67, 0.78)
    env.ambient_light_energy = 0.65
    world_env.environment = env
    add_child(world_env)
    var sun := DirectionalLight3D.new()
    sun.rotation_degrees = Vector3(-52, -28, 0)
    sun.light_energy = 1.25
    sun.shadow_enabled = true
    add_child(sun)

func _make_arena() -> void:
    _add_box("Arena", Vector3(0, -0.5, 0), Vector3(30, 1, 30), Color(0.20, 0.31, 0.25))
    # Lane stones
    for x in range(-2, 3):
        for z in range(-7, 8):
            _add_box("PathStone", Vector3(x * 1.1, 0.025, z * 1.1), Vector3(1.02, 0.08, 1.02), Color(0.39, 0.41, 0.39))
    # Decorative trees around the edges
    for p in [Vector3(-12,0,-10), Vector3(12,0,-10), Vector3(-12,0,10), Vector3(12,0,10),
              Vector3(-11,0,0), Vector3(11,0,0), Vector3(0,0,-12), Vector3(0,0,12)]:
        _make_tree(p)
    # Boundary pillars
    for x in [-14.5, 14.5]:
        for z in range(-12, 13, 4):
            _add_box("BoundaryRock", Vector3(x, 0.7, z), Vector3(1.2, 1.4, 1.2), Color(0.28,0.30,0.32))
    for z in [-14.5, 14.5]:
        for x in range(-12, 13, 4):
            _add_box("BoundaryRock", Vector3(x, 0.7, z), Vector3(1.2, 1.4, 1.2), Color(0.28,0.30,0.32))
    # Objective crystal
    var crystal := MeshInstance3D.new()
    var mesh := CylinderMesh.new()
    mesh.top_radius = 0.0
    mesh.bottom_radius = 0.8
    mesh.height = 2.4
    crystal.mesh = mesh
    crystal.position = Vector3(0, 1.2, -12)
    crystal.material_override = _mat(Color(0.20, 0.75, 1.0), 0.35)
    add_child(crystal)

func _make_tree(pos: Vector3) -> void:
    _add_box("TreeTrunk", pos + Vector3(0,0.9,0), Vector3(0.55,1.8,0.55), Color(0.28,0.17,0.10))
    var crown := MeshInstance3D.new()
    var mesh := SphereMesh.new()
    mesh.radius = 1.45
    mesh.height = 2.6
    crown.mesh = mesh
    crown.position = pos + Vector3(0,2.5,0)
    crown.material_override = _mat(Color(0.10,0.30,0.17))
    add_child(crown)

func _make_player():
    var p := CharacterBody3D.new()
    p.name = "Player"
    p.set_script(load("res://scripts/player.gd"))
    p.position = Vector3(0, 0.1, 5)
    p.add_to_group("player")
    add_child(p)
    var body := MeshInstance3D.new()
    var capsule := CapsuleMesh.new()
    capsule.radius = 0.55
    capsule.height = 1.9
    body.mesh = capsule
    body.material_override = _mat(Color(0.20,0.55,0.95))
    body.position.y = 1.0
    p.add_child(body)
    var head := MeshInstance3D.new()
    var sphere := SphereMesh.new()
    sphere.radius = 0.43
    sphere.height = 0.86
    head.mesh = sphere
    head.material_override = _mat(Color(0.85,0.68,0.52))
    head.position = Vector3(0,2.05,0)
    p.add_child(head)
    var sword := MeshInstance3D.new()
    var blade := BoxMesh.new()
    blade.size = Vector3(0.12,0.12,1.3)
    sword.mesh = blade
    sword.material_override = _mat(Color(0.78,0.84,0.92), 0.2)
    sword.position = Vector3(0.62,1.15,-0.25)
    sword.rotation_degrees.x = 18
    p.add_child(sword)
    var cam := Camera3D.new()
    cam.position = Vector3(0, 13, 13)
    cam.rotation_degrees = Vector3(-42, 0, 0)
    cam.current = true
    p.add_child(cam)
    return p

func _make_enemy(pos: Vector3) -> void:
    var e := CharacterBody3D.new()
    e.name = "EnemyGuardian"
    e.set_script(load("res://scripts/enemy.gd"))
    e.position = pos
    e.add_to_group("enemies")
    add_child(e)
    var body := MeshInstance3D.new()
    var capsule := CapsuleMesh.new()
    capsule.radius = 0.58
    capsule.height = 1.85
    body.mesh = capsule
    body.material_override = _mat(Color(0.78,0.20,0.19))
    body.position.y = 0.95
    e.add_child(body)
    var head := MeshInstance3D.new()
    var sphere := SphereMesh.new()
    sphere.radius = 0.4
    head.mesh = sphere
    head.material_override = _mat(Color(0.48,0.25,0.19))
    head.position.y = 1.95
    e.add_child(head)

func _make_ui() -> void:
    var layer := CanvasLayer.new()
    add_child(layer)
    var panel := PanelContainer.new()
    panel.position = Vector2(18, 16)
    panel.custom_minimum_size = Vector2(330, 92)
    layer.add_child(panel)
    var vbox := VBoxContainer.new()
    panel.add_child(vbox)
    status_label = Label.new()
    status_label.text = "EMBERFALL  |  MOBA PROTOTYPE"
    status_label.add_theme_font_size_override("font_size", 20)
    vbox.add_child(status_label)
    health_bar = ProgressBar.new()
    health_bar.max_value = 100
    health_bar.value = 100
    health_bar.custom_minimum_size = Vector2(290, 18)
    vbox.add_child(health_bar)
    var help := Label.new()
    help.text = "Move: WASD / touch arrows     Attack: Space / button"
    vbox.add_child(help)
    # Touch controls
    var controls := HBoxContainer.new()
    controls.anchor_left = 0.0
    controls.anchor_top = 1.0
    controls.anchor_right = 0.0
    controls.anchor_bottom = 1.0
    controls.offset_left = 22
    controls.offset_top = -145
    controls.offset_right = 300
    controls.offset_bottom = -18
    controls.add_theme_constant_override("separation", 8)
    layer.add_child(controls)
    var left_col := VBoxContainer.new()
    controls.add_child(left_col)
    _add_move_button(left_col, "↑", Vector2(0,-1))
    var mid := HBoxContainer.new()
    left_col.add_child(mid)
    _add_move_button(mid, "←", Vector2(-1,0))
    _add_move_button(mid, "↓", Vector2(0,1))
    _add_move_button(mid, "→", Vector2(1,0))
    var attack := Button.new()
    attack.text = "ATTACK"
    attack.custom_minimum_size = Vector2(112, 112)
    attack.add_theme_font_size_override("font_size", 19)
    attack.pressed.connect(_on_attack)
    controls.add_child(attack)

func _add_move_button(parent: Node, caption: String, direction: Vector2) -> void:
    var b := Button.new()
    b.text = caption
    b.custom_minimum_size = Vector2(58, 54)
    b.add_theme_font_size_override("font_size", 22)
    b.button_down.connect(func(): player.set_touch_direction(direction))
    b.button_up.connect(func(): player.set_touch_direction(Vector2.ZERO))
    parent.add_child(b)

func _on_attack() -> void:
    if is_instance_valid(player):
        player.attack()

func _add_box(label: String, pos: Vector3, size: Vector3, color: Color) -> void:
    var node := StaticBody3D.new()
    node.name = label
    node.position = pos
    var mesh_node := MeshInstance3D.new()
    var mesh := BoxMesh.new()
    mesh.size = size
    mesh_node.mesh = mesh
    mesh_node.material_override = _mat(color)
    node.add_child(mesh_node)
    var shape := CollisionShape3D.new()
    var box := BoxShape3D.new()
    box.size = size
    shape.shape = box
    node.add_child(shape)
    add_child(node)

func _mat(color: Color, metallic := 0.0) -> StandardMaterial3D:
    var m := StandardMaterial3D.new()
    m.albedo_color = color
    m.metallic = metallic
    m.roughness = 0.72
    return m

func _update_status(message: String) -> void:
    if status_label:
        status_label.text = "EMBERFALL  |  " + message

func _process(_delta: float) -> void:
    if is_instance_valid(player) and health_bar:
        health_bar.value = player.health
    var alive := get_tree().get_nodes_in_group("enemies").size()
    if alive == 0:
        _update_status("VICTORY! All guardians defeated.")
