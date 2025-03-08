extends Interactable

@onready var talk_icon: AnimatedSprite2D = $talk_icon


var velocity :Vector2 = Vector2(0,0)
var k = 0
@export_file("*.tscn") var gun

var now_bullet_num := 1

func _ready() -> void:
	randomize()
	velocity = Vector2(randi_range(-150,150), randi_range(-400,-600))
	await get_tree().create_timer(abs(velocity.y)/500).timeout
	k = 1
	velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	self.global_position += velocity * delta
	if k == 0:
		velocity.y = move_toward(velocity.y, 400, 1000*delta)

func _on_enter() -> void:
	talk_icon.visible = true

func _on_exit() -> void:
	talk_icon.visible = false

func _on_interacted() -> void:
	for child in Game_Player.get_node("weapon").get_children():
		child.queue_free()
	var g = load(gun).instantiate()
	g.now_bullet_num = now_bullet_num
	g.position = Game_Player.get_node("body").get_node("gunpos").position
	Game_Player.get_node("weapon").add_child(g)
	self.queue_free()
