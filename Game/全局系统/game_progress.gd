extends Node

var now_gun :String

var now_gun_bullet_num :int

var skull_num :int = 0

var completed_levels: int = 0
var queen_enemy :int = 0

func clear() -> void:
	skull_num = 0

	completed_levels = 0
	queen_enemy = 0


func door_generate() -> void:
	pass
