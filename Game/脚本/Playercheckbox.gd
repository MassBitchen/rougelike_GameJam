extends Area2D
class_name Playercheckbox

signal Ischeck()
signal Nocheck()

var ischeck := false

func _init() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _on_area_entered(area: Area2D) -> void:
	if area.name == "PlayerBody":
		Ischeck.emit()
		ischeck = true

func _on_area_exited(area: Area2D) -> void:
	if area.name == "PlayerBody":
		Nocheck.emit()
		ischeck = false
