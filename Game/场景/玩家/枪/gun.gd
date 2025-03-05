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

func _ready() -> void:
	self_tree = get_parent().get_parent().get_parent()

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
	if Input.get_action_strength("shoot"):
		animation_player.play("shoot")
	
func Player_shoot() -> void:
	var bullet = BULLET.instantiate()
	bullet.global_position = shoot_pos.global_position
	bullet.free_time = bullet_free_time
	bullet.Speed = bullet_speed
	bullet.ShootPos = Vector2.from_angle(mov_direction.angle() + randf_range(-PI/16 * bullet_offset, +PI/16 * bullet_offset))
	#这里需要修改，感觉写的不太好
	get_parent().get_parent().get_parent().add_child(bullet)


func _on_tree_exited() -> void:
	var g = load(pick_up).instantiate()
	g.global_position = self_pos
	#这里需要修改，感觉写的不太好
	self_tree.add_child(g)
