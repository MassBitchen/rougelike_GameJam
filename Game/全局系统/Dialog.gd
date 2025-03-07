extends CanvasLayer

@onready var panel_container: PanelContainer = $PanelContainer
@onready var content: RichTextLabel = $PanelContainer/MarginContainer/Content

@onready var icon: TextureRect = $PanelContainer/icon
var dialogs = []
var current = -1

var npc_1 = load("res://资源/6/1/npc_1_icon.png")

func _ready() -> void:
	hide_dialog_box()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("tall"):
		if current + 1 < dialogs.size(): 
			_show_dialog(current + 1)
		else:
			hide_dialog_box()
	get_viewport().set_input_as_handled()

func show_dialog_box(_dialogs,num :int):
	if num == 1:
		icon.texture = npc_1
	if not panel_container.visible:
		dialogs = _dialogs
		panel_container.show()
		_show_dialog(0)
	
func _show_dialog(index):
	current = index
	var dialog = dialogs[current]
	content.text = tr(dialog.text)

func hide_dialog_box() -> void:
	panel_container.hide()
