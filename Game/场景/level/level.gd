extends Node2D
class_name Level

@export var main_bgm :AudioStream 
@onready var tile_map: TileMapLayer = $tile/TileMapLayer
@onready var camera_2d: Camera2D = $Camera2D
@export var gun :String

func new_game(player: String) -> void:
	var Player = load(player).instantiate()
	add_child(Player)
	var g = load(gun).instantiate()
	g.position = Player.get_node("body").get_node("gunpos").position
	Player.get_node("weapon").add_child(g)

func _ready() -> void:
	if main_bgm:
		SoundManager.play_bgm(main_bgm)
	var used := tile_map.get_used_rect().grow(-1)
	var tile_size := tile_map.tile_set.tile_size
	
	camera_2d.limit_top = used.position.y * tile_size.y
	camera_2d.limit_right = used.end.x * tile_size.x
	camera_2d.limit_bottom = used.end.y * tile_size.y
	camera_2d.limit_left = used.position.x * tile_size.x
