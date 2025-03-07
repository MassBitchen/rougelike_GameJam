extends Teleporter

@export_file("*.tscn") var path_1: String
@export_file("*.tscn") var path_2: String
@export_file("*.tscn") var path_3: String

func interact() -> void:
	super()
	var v = randi_range(1,3)
	if v == 1:
		Game.change_scene(path_1)
	elif v == 2:
		Game.change_scene(path_2)
	elif v == 3:
		Game.change_scene(path_3)
