extends CharacterBody2D
class_name Enemys

#基础组件
@onready var body: Node2D = $Body
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var stats: Stats = $Stats
#移动相关
@onready var PlayerPos :Vector2 = Vector2(0,0)
#死亡
var skull = load("res://场景/敌人/物品/skull_coin.tscn")
#方向
enum Direction {
	LEFT = -1,
	RIGHT = +1,
}
@export var direction := Direction.RIGHT:
	set(v):
		direction = v
		if not is_node_ready():
			await ready
		body.scale.x = direction
var shader := preload("res://shader/outline.gdshader")

func _ready() -> void:
	randomize()
	#玩家位置
	GlobalSignal.connect("player_position_update", Callable(self,"_on_player_position_update"))
	$Body/Sprite2D.material
		

func _on_player_position_update(PlayerPosition):
	PlayerPos = PlayerPosition

func Enemys_skull(time: int) -> void:
	for i in time:
		var S = skull.instantiate()
		S.global_position = self.global_position
		get_parent().get_parent().add_child(S)
