extends Camera2D

@export var recovery_speed := 16.0
@export var k :float = 0.02

var strength := 0.0
var PlayerPos :Vector2
var t = true
var p1


func _ready() -> void:
	Game.camera_should_shake.connect(func (amount: float):
		if strength <= 5:
			strength += amount
	)
	GlobalSignal.connect("player_position_update", Callable(self,"_on_player_position_update"))

func _process(delta: float) -> void:
	var p2 = self.global_position
	if Input.get_action_strength("shoot"):
		p1 = PlayerPos.lerp(get_global_mouse_position(), 0.2)
	else:
		p1 = PlayerPos
	p2 += (p1 - p2) * k
	self.global_position = p2
	
	offset = Vector2(
		randf_range(-strength, +strength),
		randf_range(-strength, +strength)
	)
	strength = move_toward(strength, 0, recovery_speed * delta)


func _on_player_position_update(PlayerPosition):
	PlayerPos = PlayerPosition
