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
		{text = "npc_1_3"}
		])
		await get_tree().create_timer(1).timeout
		var g = gun.instantiate()
		g.global_position = self.global_position
		#这里需要修改，感觉写的不太好
		get_parent().add_child(g)
	else:
		Dialog.show_dialog_box([
		{text = ""},
		{text = "npc_1_3"}
		])
