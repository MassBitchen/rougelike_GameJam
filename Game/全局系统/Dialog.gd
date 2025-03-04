extends CanvasLayer

@onready var panel_container: PanelContainer = $PanelContainer
@onready var content: RichTextLabel = $PanelContainer/MarginContainer/Content

var dialogs = []
var current = -1

func _ready() -> void:
	hide_dialog_box()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("tall"):
		if current + 1 < dialogs.size(): 
			_show_dialog(current + 1)
		else:
			hide_dialog_box()
	get_viewport().set_input_as_handled()

func show_dialog_box(_dialogs):
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
