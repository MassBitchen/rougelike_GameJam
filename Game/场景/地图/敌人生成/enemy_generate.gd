extends Node2D

# 怪物场景配置（在编辑器中拖拽预设场景）
@export var melee_enemy_scenes: Array[PackedScene]
@export var ranged_enemy_scene: PackedScene

# 生成参数配置
@export var initial_spawn_delay: float = 2.0    # 初始生成延迟
@export var min_spawn_interval: float = 3.0     # 最小生成间隔
@export var max_spawn_interval: float = 8.0      # 最大生成间隔
@export var melee_spawn_weight: int = 2          # 近战生成权重
@export var ranged_spawn_weight: int = 1         # 远程生成权重

var spawn_points: Array[Marker2D]

func _ready():
	# 获取所有生成点
	spawn_points = [$pos1]
	# 设置初始定时器
	$Timer.wait_time = initial_spawn_delay
	$Timer.start()

func _on_timer_timeout():
	# 随机选择生成点
	var selected_point = spawn_points.pick_random()
	# 根据权重选择怪物类型
	var enemy_scene = get_weighted_random_enemy()
	# 生成实例
	var new_enemy = enemy_scene.instantiate()
	new_enemy.global_position = selected_point.global_position
	get_parent().add_child(new_enemy)
	# 设置下次生成时间
	reset_timer()

func get_weighted_random_enemy() -> PackedScene:
	var total_weight = melee_spawn_weight + ranged_spawn_weight
	var random_value = randi_range(1, total_weight)
	
	if random_value <= melee_spawn_weight:
		return melee_enemy_scenes.pick_random()
	else:
		return ranged_enemy_scene

func reset_timer():
	$Timer.wait_time = randf_range(min_spawn_interval, max_spawn_interval)
	$Timer.start()
