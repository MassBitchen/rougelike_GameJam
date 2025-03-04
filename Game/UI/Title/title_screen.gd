extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var describe: Label = $start/Panel/describe
@onready var down: AnimatedSprite2D = $start/Panel/down
@onready var lr: AnimatedSprite2D = $start/Panel/lr
@onready var up: AnimatedSprite2D = $start/Panel/up


#options
@onready var language: OptionButton = $options/language2/language
@onready var scanline_button: CheckButton = $options/scanline/scanline_button

var Player_1 = str("res://场景/玩家/player.tscn")

func _on_start_pressed() -> void:
	animation_player.play("start")

func _on_options_pressed() -> void:
	animation_player.play("options")

func _on_start_back_pressed() -> void:
	animation_player.play("main_2")

func _on_options_back_pressed() -> void:
	animation_player.play("main_1")

func _on_player_1_pressed() -> void:
	Game.new_game(Player_1) # 还没写的方法




#视觉效果
func _on_player_1_mouse_entered() -> void:
	describe.text = tr("player_1")
	describe.visible = true
	down.visible = true
	up.visible = true
	lr.visible = true


func _on_player_2_mouse_entered() -> void:
	describe.text = tr("player_2")
	describe.visible = true
	down.visible = false
	up.visible = false
	lr.visible = false




#语言选择控件
func _on_language_item_selected(index: int) -> void:
	if language.selected == 0:
		TranslationServer.set_locale("ch")
	elif language.selected == 1:
		TranslationServer.set_locale("en")

#扫描线开关
func _on_check_button_pressed() -> void:
	Game.scanline.visible = scanline_button.button_pressed
