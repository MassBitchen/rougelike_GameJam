extends Interactable
class_name Teleporter

@export_file("*.tscn") var path: String
@onready var talk_icon: AnimatedSprite2D = $talk_icon

func interact() -> void:
	super()
	Game.change_scene(path)

func _on_enter() -> void:
	talk_icon.show()

func _on_exit() -> void:
	talk_icon.hide()
