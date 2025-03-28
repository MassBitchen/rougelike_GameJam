extends Control

@onready var num: Label = $HBoxContainer/num
var skull_num := 0

@onready var h_box_container: HBoxContainer = $HBoxContainer

func _ready() -> void:
	GlobalSignal.connect("player_skull_add", Callable(self , "_on_player_skull_add"))
	num.text = str(":") + str(GameProgress.skull_num)

func _on_player_skull_add() -> void:
	GameProgress.skull_num += 1
	num.text = str(":") + str(GameProgress.skull_num)
