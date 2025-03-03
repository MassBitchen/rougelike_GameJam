extends Hitbox
class_name EnemyBullet

@export var free_time :int
@export var normal_damage :float

var Speed
var ShootPos

func _ready() -> void:
	self.rotation = ShootPos.angle()
	await get_tree().create_timer(free_time).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	global_position += ShootPos * Speed * delta

func damage() -> float:
	return normal_damage
