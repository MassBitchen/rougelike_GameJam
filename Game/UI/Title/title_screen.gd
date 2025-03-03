extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_start_pressed() -> void:
	animation_player.play("start")

func _on_options_pressed() -> void:
	animation_player.play("options")

func _on_start_back_pressed() -> void:
	animation_player.play("main_2")

func _on_options_back_pressed() -> void:
	animation_player.play("main_1")
