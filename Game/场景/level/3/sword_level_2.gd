extends SeordLevel

@onready var playercheckbox: Playercheckbox = $Playercheckbox


func _on_playercheckbox_ischeck() -> void:
	Game.player_stats.health += 3
	playercheckbox.queue_free()
