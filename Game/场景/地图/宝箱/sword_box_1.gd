extends Interactable

@onready var talk_icon: AnimatedSprite2D = $talk_icon
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var skull = load("res://场景/敌人/物品/skull_coin.tscn")

func _on_interacted() -> void:
	animated_sprite_2d.play("open")
	self.set_deferred("monitoring",false)
	Enemys_skull(randi_range(10,20))

func Enemys_skull(time: int) -> void:
	for i in time:
		var S = skull.instantiate()
		S.global_position = self.global_position
		get_parent().get_parent().add_child(S)

func _on_enter() -> void:
	talk_icon.show()


func _on_exit() -> void:
	talk_icon.hide()
