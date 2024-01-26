extends CharacterBody2D
class_name Enemy

@export var speed : float = 200
@export var health : int = 100
var player

func _ready():
	player = get_tree().root.get_child(0).get_node("Player")

func _physics_process(delta):
	moveTowardsPlayer()
	move_and_slide()

func moveTowardsPlayer():
	velocity = global_position.direction_to(player.global_position)*speed
