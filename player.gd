extends CharacterBody3D

var move_input := Vector2.ZERO
var touch_input := Vector2.ZERO
var health := 100.0
var attack_cooldown := 0.0
const SPEED := 6.2

func _ready() -> void:
    var collision := CollisionShape3D.new()
    var shape := CapsuleShape3D.new()
    shape.radius = 0.48
    shape.height = 1.8
    collision.shape = shape
    collision.position.y = 0.9
    add_child(collision)

func _physics_process(delta: float) -> void:
    attack_cooldown = maxf(0.0, attack_cooldown - delta)
    var keyboard := Vector2(
        Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
        Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
    )
    var direction := touch_input if touch_input.length() > 0.1 else keyboard
    direction = direction.normalized()
    velocity.x = direction.x * SPEED
    velocity.z = direction.y * SPEED
    velocity.y = 0.0
    move_and_slide()
    if direction.length() > 0.1:
        rotation.y = atan2(-direction.x, -direction.y)

func set_touch_direction(value: Vector2) -> void:
    touch_input = value

func attack() -> void:
    if attack_cooldown > 0.0:
        return
    attack_cooldown = 0.55
    var nearest: Node3D = null
    var nearest_distance := 2.8
    for enemy in get_tree().get_nodes_in_group("enemies"):
        if not is_instance_valid(enemy):
            continue
        var d := global_position.distance_to(enemy.global_position)
        if d < nearest_distance:
            nearest = enemy
            nearest_distance = d
    if nearest:
        nearest.take_damage(34.0)
        _flash_attack()

func _flash_attack() -> void:
    var tween := create_tween()
    tween.tween_property(self, "scale", Vector3(1.12,1.12,1.12), 0.08)
    tween.tween_property(self, "scale", Vector3.ONE, 0.12)

func take_damage(amount: float) -> void:
    health = maxf(0.0, health - amount)
    if health <= 0.0:
        health = 100.0
        global_position = Vector3(0,0.1,5)
