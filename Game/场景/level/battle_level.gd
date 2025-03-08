extends Level
class_name BattleLevel

@onready var enemys: Node2D = $Enemys
@onready var timer: Timer = $Timer
@onready var timer_left: Label = $CanvasLayer/TimerLeft
@onready var door_1_pos: Marker2D = $tile/door_1_pos
@onready var door_2_pos: Marker2D = $tile/door_2_pos

var player = load("res://场景/玩家/player.tscn")

var door_1 = load("res://场景/地图/传送门/door_1.tscn")
var door_2 = load("res://场景/地图/传送门/door_2.tscn")

@onready var enemy_generate: Node2D = $Enemys/Enemy_generate
@onready var enemy_generate_2: Node2D = $Enemys/Enemy_generate2
@onready var enemy_generate_3: Node2D = $Enemys/Enemy_generate3
@onready var enemy_generate_4: Node2D = $Enemys/Enemy_generate4
@onready var enemy_generate_5: Node2D = $Enemys/Enemy_generate5


func _ready() -> void:
	super()
	var P = player.instantiate()
	add_child(P)
	var g = load(gun).instantiate()
	g.now_bullet_num = GameProgress.now_gun_bullet_num
	g.position = P.get_node("body").get_node("gunpos").position
	P.get_node("weapon").add_child(g)
	timer.wait_time = randi_range(30,45)
	timer.start()

func _on_timer_timeout() -> void:
	enemy_generate.queue_free()
	enemy_generate_2.queue_free()
	enemy_generate_3.queue_free()
	enemy_generate_4.queue_free()
	enemy_generate_5.queue_free()
	for child in enemys.get_children():
		if child is Enemys:
			child.stats.health = 0
	var door = door_1.instantiate()
	door.global_position = door_1_pos.global_position
	add_child(door)
	door = door_2.instantiate()
	door.global_position = door_2_pos.global_position
	add_child(door)

func _physics_process(delta: float) -> void:
	timer_left.text = str(int(timer.time_left))
