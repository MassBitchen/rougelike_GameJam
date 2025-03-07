class_name Stats
extends Node

signal health_changed
signal energy_changed

@export var max_health: int = 3
@export var max_energy: float = 10


@onready var health: int = max_health:
	set(v):
		v = clampi(v, 0, max_health)
		if health == v:
			return
		health = v
		health_changed.emit()

@onready var energy: float = max_energy:
	set(v):
		v = clampf(v, 0, max_energy)
		if energy == v:
			return
		energy = v
		energy_changed.emit()

func to_dict() -> Dictionary:
	return {
		max_energy=max_energy,
		max_health=max_health,
		health=health,
	}

func from_dict(dict: Dictionary) -> void:
	max_energy = dict.max_energy
	max_health = dict.max_health
	health = dict.health
