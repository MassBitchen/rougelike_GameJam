extends Interactable
class_name Teleporter

@onready var talk_icon: AnimatedSprite2D = $talk_icon

func _ready() -> void:
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2(1,1), 0.3)

func _on_enter() -> void:
	talk_icon.show()

func _on_exit() -> void:
	talk_icon.hide()
