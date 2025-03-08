extends CharacterBody2D
class_name Player
#组件
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var body: Node2D = $body
#Timer
@onready var foot_print_timer: Timer = $Timer/FootPrintTimer
@onready var energy_timer: Timer = $Timer/EnergyTimer
#速度相关
const MAX_RUN_SPEED := 150
var RUN_SPEED = 150
var acceleration = RUN_SPEED / 0.01
#玩家位置
var PlayerPosition :Vector2 = Vector2.ZERO
#鼠标图标
var cursor_texture = load("res://资源/shoot.png")
var cursor_texture_2 = load("res://资源/shoot.png")
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
@onready var player_point: Sprite2D = $PlayerPoint
var roll_dir :Vector2
var mov_direction := Vector2.LEFT
#外部组件
var footprint = load("res://场景/玩家/组件/footprint.tscn")
#武器效果
@onready var weapon: Node2D = $weapon
#受伤和死亡
const KNOCKBACK_AMOUNT := 312.0
var pending_damage: Damage
var hit_global_position :Vector2
#血量
@onready var stats: Node = Game.player_stats
#可交互物体
var interacting_with: Array[Interactable]
#所有状态
enum State{
	IDLE_DOWN,
	IDLE_UP,
	IDLE_LR,
	WALK_DOWN,
	WALK_UP,
	WALK_LR,
	RUN_DOWN,
	RUN_UP,
	RUN_LR,
	ROLL_DOWN,
	ROLL_UP,
	ROLL_LR,
	HURT,
	DIE,
}
func _ready() -> void:
	stats.max_health = 5

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("tall") and interacting_with:
		interacting_with.back().interact()

func tick_physics(state: State, _delta: float) -> void:
	Player_globalposition()
	if energy_timer.is_stopped():
		stats.energy += 0.8 * _delta
	match state:
		State.IDLE_DOWN,State.IDLE_UP,State.IDLE_LR:
			Player_move(_delta,1)
		State.WALK_DOWN,State.WALK_UP,State.WALK_LR:
			Player_move(_delta,1)
		State.RUN_DOWN,State.RUN_UP,State.RUN_LR:
			Player_move(_delta,1)
		State.ROLL_DOWN,State.ROLL_UP,State.ROLL_LR:
			Player_roll()
		State.HURT:
			Player_stand()
		State.DIE:
			pass

func get_next_state(state: State) -> int:
	var H_is_still := is_zero_approx(velocity.x)
	var V_is_still := is_zero_approx(velocity.y)
	if state == State.IDLE_DOWN or  state == State.IDLE_UP or  state == State.IDLE_LR:
		if not H_is_still:
			return State.WALK_LR
		elif not V_is_still:
			if velocity.y > 0:
				return State.WALK_DOWN
			if velocity.y < 0:
				return State.WALK_UP
	if state == State.WALK_DOWN or state == State.WALK_UP or state == State.WALK_LR:
		if Input.get_action_strength("shift"):
			if not H_is_still:
				return State.RUN_LR
			elif not V_is_still:
				if velocity.y > 0:
					return State.RUN_DOWN
				if velocity.y < 0:
					return State.RUN_UP
	if state == State.RUN_DOWN or state == State.RUN_UP or state == State.RUN_LR:
		if not Input.get_action_strength("shift"):
			if not H_is_still:
				return State.WALK_LR
			elif not V_is_still:
				if velocity.y > 0:
					return State.WALK_DOWN
				if velocity.y < 0:
					return State.WALK_UP
	#翻滚实现
	if Input.is_action_just_pressed("roll") and stats.energy >= 2:
		if not state == State.ROLL_DOWN and not state == State.ROLL_UP and not state == State.ROLL_LR:
			if mov_direction.x == 0:
				if mov_direction.y > 0:
					return State.ROLL_DOWN
				else:
					return State.ROLL_UP
			else:
				return State.ROLL_LR
	#受伤
	if pending_damage:
		return State.HURT
	#死亡
	if stats.health == 0:
		return StateMachine.KEEP_CURRENT if state == State.DIE else State.DIE
	match state:
		State.IDLE_DOWN:
			pass
		State.IDLE_UP:
			pass
		State.IDLE_LR:
			pass
		State.WALK_DOWN:
			if H_is_still and V_is_still:
				return State.IDLE_DOWN
			if not H_is_still:
				return State.WALK_LR
		State.WALK_UP:
			if H_is_still and V_is_still:
				return State.IDLE_UP
			if not H_is_still:
				return State.WALK_LR
		State.WALK_LR:
			if H_is_still:
				if V_is_still:
					return State.IDLE_LR
				else:
					if velocity.y > 0:
						return State.WALK_DOWN
					if velocity.y < 0:
						return State.WALK_UP
		State.RUN_DOWN:
			if H_is_still and V_is_still:
				return State.IDLE_DOWN
			if not H_is_still:
				return State.RUN_LR
		State.RUN_UP:
			if H_is_still and V_is_still:
				return State.IDLE_UP
			if not H_is_still:
				return State.RUN_LR
		State.RUN_LR:
			if H_is_still:
				if V_is_still:
					return State.IDLE_LR
				else:
					if velocity.y > 0:
						return State.RUN_DOWN
					if velocity.y < 0:
						return State.RUN_UP
		State.ROLL_DOWN:
			if not animation_player.is_playing():
				return State.RUN_DOWN
		State.ROLL_UP:
			if not animation_player.is_playing():
				return State.RUN_UP
		State.ROLL_LR:
			if not animation_player.is_playing():
				return State.RUN_LR
		State.HURT:
			if not animation_player.is_playing():
				return State.WALK_DOWN
		State.DIE:
			pass
	return StateMachine.KEEP_CURRENT

func transition_state(_from: State, to: State) -> void:
	#脚印处理有bug，要修
	if to == State.IDLE_DOWN or State.IDLE_UP or State.IDLE_LR:
		foot_print_timer.stop()
	if to == State.WALK_DOWN or State.WALK_UP or State.WALK_LR:
		foot_print_timer.start()
	if to == State.ROLL_DOWN or State.ROLL_UP or State.ROLL_LR:
		if not mov_direction == Vector2.ZERO:
			roll_dir = mov_direction
		foot_print_timer.stop()
	if to == State.RUN_DOWN or State.RUN_UP or State.RUN_LR:
		foot_print_timer.start()
	if _from == State.IDLE_UP or State.WALK_UP or State.RUN_UP or State.ROLL_UP:
		weapon.z_index = 0
	if _from == State.ROLL_DOWN or State.ROLL_UP or State.ROLL_LR:
		weapon.visible = true
	match to:
		State.IDLE_DOWN:
			animation_player.play("idle_down")
		State.IDLE_UP:
			animation_player.play("idle_up")
			weapon.z_index = -1
		State.IDLE_LR:
			animation_player.play("idle_lr")
		State.WALK_DOWN:
			animation_player.play("walk_down")
		State.WALK_UP:
			animation_player.play("walk_up")
			weapon.z_index = -1
		State.WALK_LR:
			animation_player.play("walk_lr")
		State.RUN_DOWN:
			animation_player.play("run_down")
			energy_timer.start()
		State.RUN_UP:
			animation_player.play("run_up")
			weapon.z_index = -1
			energy_timer.start()
		State.RUN_LR:
			animation_player.play("run_lr")
			energy_timer.start()
		State.ROLL_DOWN:
			animation_player.play("roll_down")
			weapon.visible = false
			stats.energy -= 2
		State.ROLL_UP:
			animation_player.play("roll_up")
			weapon.visible = false
			stats.energy -= 2
		State.ROLL_LR:
			animation_player.play("roll_lr")
			weapon.visible = false
			stats.energy -= 2
		State.HURT:
			animation_player.play("hurt")
			velocity = Vector2.ZERO
			if pending_damage.source:
				var dir := pending_damage.source.global_position.direction_to(self.global_position)
				velocity += dir * KNOCKBACK_AMOUNT
			pending_damage = null
		State.DIE:
			animation_player.play("die")
			for gun in weapon.get_children():
				gun.queue_free()
			await get_tree().create_timer(1.5).timeout
			Game.gameover.show()
			

#基础玩家脚本
func Player_move(delta: float,rate: float) -> void:
	if Input.get_action_strength("shift"):
		RUN_SPEED = MAX_RUN_SPEED
	else:
		RUN_SPEED = 2 * MAX_RUN_SPEED / 3
	#实现玩家移动方向
	var movement_H := Input.get_axis("move_left", "move_right")
	var movement_V := Input.get_axis("move_up", "move_down")
	mov_direction = Vector2(movement_H, movement_V).normalized()
	#让玩家可以停下来瞄准
	if not Input.get_action_strength("stop_move"):
		velocity.x = move_toward(velocity.x, mov_direction.x * RUN_SPEED * rate, acceleration * delta)
		velocity.y = move_toward(velocity.x, mov_direction.y * RUN_SPEED * rate, acceleration * delta)
	else:
		velocity = Vector2.ZERO
	#方向
	if not is_zero_approx(movement_H):
		direction = Direction.LEFT if movement_H < 0 else Direction.RIGHT
	move_and_slide()
func Player_roll() -> void:
	velocity = RUN_SPEED * 2 * roll_dir
	move_and_slide()
func Player_stand() -> void:
	velocity = lerp(velocity, Vector2.ZERO, 0.1)
	move_and_slide()
#额外脚本
func Player_footprint() -> void:
	var print = footprint.instantiate()
	print.global_position = self.global_position
	get_parent().add_child(print)
func Player_globalposition() -> void:
	PlayerPosition = self.global_position
	GlobalSignal.emit_signal("player_position_update",PlayerPosition)
#可交互函数，死亡状态不能交互，需要判断还未加上去
func register_interactable(v: Interactable) -> void:
	if v in interacting_with:
		return
	interacting_with.append(v)
func unregister_interactable(v: Interactable) -> void:
	interacting_with.erase(v)
#信号
func _on_foot_print_timer_timeout() -> void:
	Player_footprint()
func _on_hurtbox_hurt(hitbox: Variant) -> void:
	pending_damage = Damage.new()
	pending_damage.amount = 1
	pending_damage.source = hitbox.owner
	#hit_global_position = hitbox.owner.global_position
	stats.health -= pending_damage.amount
	
	Game.shake_camera(5)
	
