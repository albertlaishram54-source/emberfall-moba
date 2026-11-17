extends CharacterBody3D

var health := 100.0
var attack_timer := 0.0
const SPEED := 2.25

func _ready() -> void:
    var collision := CollisionShape3D.new()
    var shape := CapsuleShape3D.new()
    shape.radius = 0.5
    shape.height = 1.8
    collision.shape = shape
    collision.position.y = 0.9
    add_child(collision)

func _physics_process(delta: float) -> void:
    attack_timer = maxf(0.0, attack_timer - delta)
    var players := get_tree().get_nodes_in_group("player")
    if players.is_empty():
        return
    var target = players[0]
    if not is_instance_valid(target):
        return
    var offset: Vector3 = target.global_position - global_position
    offset.y = 0.0
    var distance := offset.length()
    if distance > 1.65:
        var dir := offset.normalized()
        velocity.x = dir.x * SPEED
        velocity.z = dir.z * SPEED
        move_and_slide()
        rotation.y = atan2(-dir.x, -dir.z)
    else:
        velocity = Vector3.ZERO
        if attack_timer <= 0.0:
            attack_timer = 1.15
            target.take_damage(8.0)

func take_damage(amount: float) -> void:
    health -= amount
    if health <= 0.0:
        queue_free()
