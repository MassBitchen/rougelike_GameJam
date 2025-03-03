class_name Stats
extends Node

signal health_changed

@export var max_health: float = 3

@onready var health: float = max_health:
	set(v):
		v = clampi(v, 0, max_health)
		if health == v:
			return
		health = v
		health_changed.emit()
