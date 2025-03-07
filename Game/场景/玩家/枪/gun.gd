extends Sprite2D
class_name Gun

@onready var shoot_pos: Marker2D = $shootPos
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export_file("*.tscn") var path: String
@export var bullet_speed :int
@export var bullet_free_time :int
@export var bullet_offset:float

var mov_direction : Vector2
@onready var BULLET = load(path)

@export_file("*.tscn") var pick_up
var self_tree
var self_pos

@export var shoot_sfx :String
@export var reload_sfx :String
@export var max_bullet_num :int
@onready var now_bullet_num := max_bullet_num
@onready var bullet_num: Label = $CanvasLayer/bullet_num
@onready var bullet_num_bar: TextureProgressBar = $bullet_num_bar

@export_file("*.tscn") var self_path

func _ready() -> void:
	bullet_num_bar.max_value = max_bullet_num
	bullet_num_bar.value = bullet_num_bar.max_value
	self_tree = get_parent().get_parent().get_parent()
	GameProgress.now_gun = self_path

func _unhandled_input(event: InputEvent) -> void:
	pass

func _physics_process(_delta: float) -> void:
	#手柄
	#var movement_H := Input.get_axis("shoot_left", "shoot_right")
	#var movement_V := Input.get_axis("shoot_up", "shoot_down")
	#if is_zero_approx(movement_H) and is_zero_approx(movement_V):
		#movement_H = Input.get_axis("move_left", "move_right")
		#movement_V = Input.get_axis("move_up", "move_down")
	#if not is_zero_approx(movement_H) or not is_zero_approx(movement_V):
		#mov_direction = Vector2(movement_H, movement_V).normalized()
	#if movement_H < 0:
		#self.scale.y = -1
	#elif movement_H > 0:
		#self.scale.y = 1
		
	#鼠标
	self_pos = self.global_position
	mov_direction = (get_global_mouse_position() - self.global_position).normalized()
	if mov_direction.x < 0:
		self.scale.y = -1
	elif mov_direction.x > 0:
		self.scale.y = 1
	self.rotation = mov_direction.angle()
	#射击
	if Input.get_action_strength("shoot") and not animation_player.is_playing() and now_bullet_num > 0:
		animation_player.play("shoot")
	if Input.is_action_pressed("reload"):
		animation_player.play("reload")
		SoundManager.play_sfx(reload_sfx)
	
	bullet_num_bar.value = now_bullet_num
	bullet_num.text = str(now_bullet_num) + str("/") + str(max_bullet_num)
	
	
func Player_shoot() -> void:
	SoundManager.play_sfx(shoot_sfx)
	var bullet = BULLET.instantiate()
	bullet.global_position = shoot_pos.global_position
	bullet.free_time = bullet_free_time
	bullet.Speed = bullet_speed
	bullet.ShootPos = Vector2.from_angle(mov_direction.angle() + randf_range(-PI/16 * bullet_offset, +PI/16 * bullet_offset))
	#这里需要修改，感觉写的不太好
	get_parent().get_parent().get_parent().add_child(bullet)
	now_bullet_num -= 1
	if now_bullet_num == 0:
		animation_player.play("reload")
		SoundManager.play_sfx(reload_sfx)

func _on_tree_exited() -> void:
	var g = load(pick_up).instantiate()
	g.global_position = self_pos
	#这里需要修改，感觉写的不太好
	self_tree.add_child(g)

func reload() -> void:
	now_bullet_num = max_bullet_num
