extends Interactable

@onready var talk_icon: AnimatedSprite2D = $talk_icon
var k = 0

var gun = load("res://场景/玩家/枪/gun1/gun_1_pickup.tscn")

func _on_enter() -> void:
	talk_icon.visible = true

func _on_exit() -> void:
	talk_icon.visible = false
	Dialog.hide_dialog_box()

func _on_interacted() -> void:
	if k == 0:
		k += 1
		Dialog.show_dialog_box([
		{text = ""},
		{text = "npc_1_1"},
		{text = "npc_1_2"},
		{text = "npc_1_3"},
		{text = "npc_1_4"},
		{text = "npc_1_5"},
		{text = "npc_1_6"},
		{text = "npc_1_7"}
		],1)
	else:
		Dialog.show_dialog_box([
		{text = ""},
		{text = "npc_1_2"},
		{text = "npc_1_3"},
		{text = "npc_1_4"},
		{text = "npc_1_5"},
		{text = "npc_1_6"},
		{text = "npc_1_7"}
		],1)
