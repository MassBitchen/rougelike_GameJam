extends Hitbox
class_name Bullet

@export var free_time :int
@export var normal_damage :float
var GPU = load("res://粒子效果/bullet_GPU.tscn")

var Speed
var ShootPos

func _ready() -> void:
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2(1,1), 0.3)
	if Speed and ShootPos:
		self.rotation = ShootPos.angle()
		await get_tree().create_timer(free_time).timeout
		queue_free()

func _physics_process(delta: float) -> void:
	if Speed and ShootPos:
		global_position += ShootPos * Speed * delta
	look_at(self.global_position + ShootPos.normalized())

func damage() -> float:
	return normal_damage

#信号
func _on_hit(hurtbox: Hurtbox) -> void:
	Game.shake_camera(3)
	var fx = GPU.instantiate()
	fx.global_position = self.global_position
	fx.emitting = true
	get_parent().add_child(fx)
	queue_free()
