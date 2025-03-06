extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var scanline: ColorRect = $scanline
@onready var animation_player: AnimationPlayer = $Lodging/AnimationPlayer
@onready var level_name: Label = $level/level_name
#玩家血量
@onready var player_stats: Stats = $PlayerStats

const CONFIG_PATH := "user://config.ini"

signal camera_should_shake(amount: float)

var cursor_texture = load("res://资源/shoot.png")

func _ready() -> void:
	color_rect.color.a = 0
	Input.set_custom_mouse_cursor(cursor_texture, Input.CURSOR_ARROW, Vector2(16, 16))
	TranslationServer.set_locale("en")
	load_config()

func shake_camera(amount: float) -> void:
	camera_should_shake.emit(amount)

func new_game(player: String) -> void:
	var tree := get_tree()
	var tween := create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(color_rect, "color:a", 1, 0.3)
	await tween.finished
	
	animation_player.play("guo")
	await  animation_player.animation_finished
	tree.change_scene_to_file("res://场景/level/1/level_1.tscn")
	await tree.tree_changed
	
	tree.current_scene.new_game(player)
	tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(color_rect, "color:a", 0, 0.3)

func change_scene(path: String) -> void:
	var tree := get_tree()
	tree.paused = true
	var tween := create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(color_rect, "color:a", 1, 0.3)
	await tween.finished
	
	animation_player.play("guo")
	await  animation_player.animation_finished
	
	tree.change_scene_to_file(path)
	await tree.tree_changed
	
	tree.paused = false
	tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(color_rect, "color:a", 0, 0.3)

func save_config() -> void:
	var config := ConfigFile.new()
	config.set_value("audio", "master", SoundManager.get_volume(SoundManager.Bus.MASTER))
	config.set_value("audio", "sfx", SoundManager.get_volume(SoundManager.Bus.SFX))
	config.set_value("audio", "bgm", SoundManager.get_volume(SoundManager.Bus.BGM))
	config.save(CONFIG_PATH)

func load_config() -> void:
	var config := ConfigFile.new()
	config.load(CONFIG_PATH)
	SoundManager.set_volume(
		SoundManager.Bus.MASTER,
		config.get_value("audio", "master", 0.5)
	)
	SoundManager.set_volume(
		SoundManager.Bus.SFX,
		config.get_value("audio", "sfx", 1.0)
	)
	SoundManager.set_volume(
		SoundManager.Bus.BGM,
		config.get_value("audio", "bgm", 1.0)
	)
