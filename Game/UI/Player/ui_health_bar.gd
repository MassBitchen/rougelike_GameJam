extends Control

@export var stats: Stats

@onready var health_bar: TextureProgressBar = $V/HealthBar
@onready var energy_bar: TextureProgressBar = $V/EnergyBar

func _ready() -> void:
	if not stats:
		stats = Game.player_stats
		
	stats.health_changed.connect(update_health)
	update_health(true)
	stats.energy_changed.connect(update_energy)
	update_energy()
	
	tree_exited.connect(func ():
		stats.health_changed.disconnect(update_health)
		stats.energy_changed.disconnect(update_energy)
	)

func update_health(skip_anim := false) -> void:
	var percentage := stats.health / float(stats.max_health)
	health_bar.value = percentage
	
	if skip_anim:
		pass
	else:
		pass

func update_energy() -> void:
	var percentage := stats.energy / stats.max_energy
	energy_bar.value = percentage
