extends Level
class_name SeordLevel

var player = load("res://场景/玩家/player.tscn")

func _ready() -> void:
	super()
	var P = player.instantiate()
	add_child(P)
	var g = load(gun).instantiate()
	g.position = P.get_node("body").get_node("gunpos").position
	P.get_node("weapon").add_child(g)
