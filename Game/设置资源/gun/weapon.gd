extends Resource
class_name Weapon

@export var name: String
@export var money: int
@export_multiline var description: String
@export_multiline var ps: String

@export_file("*.tscn") var player_can_use: String
@export_file("*.tscn") var Pickup: String
