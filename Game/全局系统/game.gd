extends CanvasLayer

signal camera_should_shake(amount: float)

func shake_camera(amount: float) -> void:
	camera_should_shake.emit(amount)
