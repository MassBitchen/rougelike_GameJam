extends Sprite2D
var PlayerPos

var velocity
var k = 0

@onready var collision_shape_2d: CollisionShape2D = $Playercheckbox/CollisionShape2D

func _ready() -> void:
	randomize()
	GlobalSignal.connect("player_position_update", Callable(self,"_on_player_position_update"))
	velocity = Vector2(randi_range(-150,150), randi_range(-400,-600))
	await get_tree().create_timer(abs(velocity.y)/500).timeout
	k = 1
	velocity = Vector2.ZERO
	#玩家位置

func _physics_process(delta: float) -> void:
	self.global_position += velocity * delta
	if k == 0:
		velocity.y = move_toward(velocity.y, 400, 1000*delta)
	elif k == 1:
		collision_shape_2d.set_deferred("disabled", false)

func _on_player_position_update(PlayerPosition):
	PlayerPos = PlayerPosition

func _on_playercheckbox_ischeck() -> void:
	GlobalSignal.emit_signal("player_skull_add")
	var tween := create_tween()
	tween.tween_property(self, "global_position", global_position + Vector2(0,-100), 0.3)
	var tween_2 := create_tween()
	tween_2.tween_property(self, "modulate", Color(0,0,0,0), 0.5)
	await tween_2.finished
	queue_free()
