extends AnimatedSprite2D

@export var talk_name :String

@onready var label: Label = $Label

func _ready() -> void:
	label.text = talk_name
