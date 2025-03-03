extends Sprite2D

var mov_direction : Vector2

func _physics_process(_delta: float) -> void:
	var movement_H := Input.get_axis("shoot_left", "shoot_right")
	var movement_V := Input.get_axis("shoot_up", "shoot_down")
	if is_zero_approx(movement_H) and is_zero_approx(movement_V):
		movement_H = Input.get_axis("move_left", "move_right")
		movement_V = Input.get_axis("move_up", "move_down")
	if not is_zero_approx(movement_H) or not is_zero_approx(movement_V):
		mov_direction = Vector2(movement_H, movement_V).normalized()
	self.rotation = mov_direction.angle()
