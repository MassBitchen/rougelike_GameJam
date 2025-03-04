extends Interactable

@onready var talk_icon: AnimatedSprite2D = $talk_icon

func interact() -> void:
	super()
	Dialog.show_dialog_box([
		{text = ""},
		{text = "npc_1_1"},
		{text = "npc_1_2"},
		{text = "npc_1_3"}
	])

func _on_enter() -> void:
	talk_icon.visible = true

func _on_exit() -> void:
	talk_icon.visible = false
	Dialog.hide_dialog_box()
