extends Enemys

@export var bullet_speed :int
@export var bullet_free_time :int

@onready var navigation_agent_2d: NavigationAgent2D = $Nacigation/NavigationAgent2D
@onready var idle_timer: Timer = $Timer/IdleTimer
@onready var attack_timer: Timer = $Timer/AttackTimer
@onready var shoot_pos: Marker2D = $Body/shoot_pos
@onready var BULLET = load("res://场景/敌人/子弹/enmey3_bullet.tscn")
#基础数据
var SPEED := 40
var move_direction :Vector2 = Vector2(1,0)
var knockback_direction
var pending_damage
var KNOCKBACK_AMOUNT := 100
#远程敌人的设置
var min_player_length = 200
var max_player_length = 300
#所有状态
enum State{
	IDLE_DOWN,
	IDLE_UP,
	IDLE_LR,
	WALK_DOWN,
	WALK_UP,
	WALK_LR,
	ATTACK_DOWN,
	ATTACK_UP,
	ATTACK_LR,
	HURT,
	DIE,
}

func tick_physics(state: State, _delta: float) -> void:
	match state:
		State.IDLE_DOWN,State.IDLE_UP,State.IDLE_LR:
			Enemy_move(_delta,1)
		State.WALK_DOWN,State.WALK_UP,State.WALK_LR:
			Enemy_move(_delta,1)
		State.ATTACK_DOWN,State.ATTACK_UP,State.ATTACK_LR:
			Enemy_stand(_delta)
		State.DIE,State.HURT:
			Enemy_stand(_delta)

func get_next_state(state: State) -> int:
	var player_self_dir = (PlayerPos-self.global_position).normalized()
	if stats.health == 0:
		return StateMachine.KEEP_CURRENT if state == State.DIE else State.DIE
	if pending_damage:
		return State.HURT
	if (state == State.WALK_DOWN or State.WALK_UP or State.WALK_LR) and attack_timer.is_stopped():
		if (player_self_dir.angle() < PI/4 and player_self_dir.angle() > -PI/4):
			return State.ATTACK_LR
		elif (player_self_dir.angle() > 3*PI/4 or player_self_dir.angle() < -3*PI/4):
			return State.ATTACK_LR
		elif player_self_dir.angle() < -PI/4 and player_self_dir.angle() > -3*PI/4:
			return State.ATTACK_UP
		elif player_self_dir.angle() > PI/4 and player_self_dir.angle() < 3*PI/4:
			return State.ATTACK_DOWN
	match state:
		State.IDLE_DOWN,State.IDLE_UP,State.IDLE_LR:
			if idle_timer.is_stopped() and not velocity == Vector2.ZERO:
				if move_direction.angle() < -PI/4 and move_direction.angle() > -3*PI/4:
					return State.WALK_UP
				elif move_direction.angle() > PI/4 and move_direction.angle() < 3*PI/4:
					return State.WALK_DOWN
				else:
					return State.WALK_LR
		State.WALK_DOWN:
			if move_direction.angle() < PI/4 or move_direction.angle() > 3*PI/4:
				return State.WALK_LR
		State.WALK_UP:
			if move_direction.angle() > -PI/4 or move_direction.angle() < -3*PI/4:
				return State.WALK_LR
		State.WALK_LR:
			if move_direction.angle() < -PI/4 and move_direction.angle() > -3*PI/4:
				return State.WALK_UP
			elif move_direction.angle() > PI/4 and move_direction.angle() < 3*PI/4:
				return State.WALK_DOWN
		State.ATTACK_DOWN:
			if not animation_player.is_playing():
				return State.IDLE_DOWN
		State.ATTACK_UP:
			if not animation_player.is_playing():
				return State.IDLE_UP
		State.ATTACK_LR:
			if not animation_player.is_playing():
				return State.IDLE_LR
		State.HURT:
			if not animation_player.is_playing():
				return State.WALK_DOWN
		State.DIE:
			pass
	return StateMachine.KEEP_CURRENT

func transition_state(_from: State, to: State) -> void:
	if to == State.IDLE_DOWN or State.IDLE_UP or State.IDLE_LR:
		idle_timer.start()
	match to:
		State.IDLE_DOWN:
			animation_player.play("idle_down")
		State.IDLE_UP:
			animation_player.play("idle_up")
		State.IDLE_LR:
			animation_player.play("idle_lr")
		State.WALK_DOWN:
			animation_player.play("walk_down")
		State.WALK_UP:
			animation_player.play("walk_up")
		State.WALK_LR:
			animation_player.play("walk_lr")
		State.ATTACK_DOWN:
			animation_player.play("attack_down")
			velocity = Vector2.ZERO
			attack_timer.start()
		State.ATTACK_UP:
			animation_player.play("attack_up")
			velocity = Vector2.ZERO
			attack_timer.start()
		State.ATTACK_LR:
			animation_player.play("attack_lr")
			velocity = Vector2.ZERO
			attack_timer.start()
		State.HURT:
			animation_player.play("hurt")
			velocity = Vector2.ZERO
			var knockback_dir :Vector2 = PlayerPos.direction_to(self.global_position)
			velocity += knockback_dir * KNOCKBACK_AMOUNT
			pending_damage = null
		State.DIE:
			animation_player.play("die")
			navigation_agent_2d.avoidance_enabled = false
			rotation = PI * randf_range(0,1)
			SoundManager.play_sfx("enemy_die")
			GameProgress.queen_enemy += 1
			Enemys_skull(1)

#基础移动函数
func Enemy_move(_delta: float,rate: float) -> void:
	#左右方向
	if PlayerPos.x < self.global_position.x:
		direction = Direction.LEFT
	elif PlayerPos.x > self.global_position.x:
		direction = Direction.RIGHT
	#开启避障

	#寻路移动
	var pos = (PlayerPos-self.global_position).normalized()
	#self.rotation = pos.angle()
	if (PlayerPos - self.global_position).length() > max_player_length:
		navigation_agent_2d.avoidance_enabled = true
		move_direction = (navigation_agent_2d.get_next_path_position()-self.global_position).normalized()
	elif (PlayerPos - self.global_position).length() < min_player_length:
		navigation_agent_2d.avoidance_enabled = true
		move_direction = -(navigation_agent_2d.get_next_path_position()-self.global_position).normalized()
	#else:
		#navigation_agent_2d.avoidance_enabled = false
		#velocity = Vector2.ZERO
	navigation_agent_2d.set_velocity(move_direction * SPEED * rate)
	move_and_slide()
func Enemy_stand(_delta: float) -> void:
	#关闭避障
	navigation_agent_2d.avoidance_enabled = false
	velocity = lerp(velocity, Vector2.ZERO, 0.1)
	move_and_slide()
func Enemy_shoot() -> void:
	var bullet = BULLET.instantiate()
	bullet.global_position = shoot_pos.global_position
	bullet.free_time = bullet_free_time
	bullet.Speed = bullet_speed
	bullet.ShootPos = (PlayerPos - self.global_position).normalized()
	#这里需要修改，感觉写的不太好
	get_parent().get_parent().add_child(bullet)
#信号
func _on_path_timer_timeout() -> void:
	#每0.1秒将玩家的位置设置为敌人的导航最终位置
	navigation_agent_2d.target_position = PlayerPos 
func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()
func _on_hurtbox_hurt(hitbox: Bullet) -> void:
	SoundManager.play_sfx("Enemy_hurt")
	
	pending_damage = Damage.new()
	pending_damage.amount = hitbox.damage()
	pending_damage.source = hitbox.owner
	stats.health -= pending_damage.amount
	
	Game.shake_camera(2)
func _on_attack_timer_timeout() -> void:
	attack_timer.wait_time = randf_range(1,3)
