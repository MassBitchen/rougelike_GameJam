extends Area2D
class_name Interactable

var Game_Player :Player

signal interacted()
signal enter()
signal exit()

func _init() -> void:
	collision_layer = 0
	collision_mask = 0
	set_collision_mask_value(2, true)
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func interact() -> void:
	print("[Interact] %s" % name)
	interacted.emit()

func _on_body_entered(player: Player) -> void:
	Game_Player = player
	player.register_interactable(self)
	enter.emit()

func _on_body_exited(player: Player) -> void:
	player.unregister_interactable(self)
	exit.emit()
