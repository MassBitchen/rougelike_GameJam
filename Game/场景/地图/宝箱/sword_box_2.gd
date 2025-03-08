extends Interactable

@onready var talk_icon: AnimatedSprite2D = $talk_icon
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var gun: Array[PackedScene]

func _on_interacted() -> void:
	animated_sprite_2d.play("open")
	self.set_deferred("monitoring",false)
	Enemys_skull()

func Enemys_skull() -> void:
	var S = gun.pick_random().instantiate()
	S.global_position = self.global_position
	get_parent().get_parent().add_child(S)

func _on_enter() -> void:
	talk_icon.show()


func _on_exit() -> void:
	talk_icon.hide()
