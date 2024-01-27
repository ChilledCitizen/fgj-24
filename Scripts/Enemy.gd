extends Area2D
class_name Enemy

@export var speed : float = 200
@export var health : int = 100
@export var damage : int = 20
var player

func _ready():
	player = get_tree().root.get_child(0).get_node("Player")
	body_entered.connect(on_body_entered)

func _physics_process(delta):
	global_position += global_position.direction_to(player.global_position) * speed * delta

func ApplyDamage(damage : int):
	health -= damage
	if health <= 0:
		queue_free()
		
func on_body_entered(body :Node2D):
	if body.is_in_group("player"):
		var player : Player = body
		player.ApplyDamage(damage)
		
