extends Sprite2D
var PlayerPos

func _ready() -> void:
	randomize()
	#玩家位置
	GlobalSignal.connect("player_position_update", Callable(self,"_on_player_position_update"))
	await get_tree().create_timer(3).timeout
	var tween := create_tween()
	tween.tween_property(self, "global_position",PlayerPos, 0.5)
	await get_tree().create_timer(0.5).timeout
	GlobalSignal.emit_signal("player_skull_add")
	queue_free()

func _on_player_position_update(PlayerPosition):
	PlayerPos = PlayerPosition
