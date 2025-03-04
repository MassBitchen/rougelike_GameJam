extends Node2D
class_name Level

func new_game(player: String) -> void:
	var Player = load(player).instantiate()
	add_child(Player)

func create_player(player: String) -> void:
	pass
