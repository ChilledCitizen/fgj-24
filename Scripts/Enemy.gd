extends Area2D
class_name Enemy

@export var base_speed : float = 150
@export var health : int = 100
@export var damage : int = 20
@onready var collision_shape_2d = %CollisionShape2D
var player
var inEnemy : bool = false
var neighbour : Enemy
var speed
var rand
#var rngVector : Vector2 = Vector2(-100, 100)

func _ready():
	randomize()
	player = get_tree().root.get_child(0).get_node("Player")
	body_entered.connect(on_body_entered)
	area_entered.connect(on_body_entered)
	area_exited.connect(_on_body_exited)
	body_exited.connect(_on_body_exited)
	rand = RandomNumberGenerator.new()
	speed = rand.randi_range(base_speed/2, base_speed*2)
	
func _physics_process(delta):
	#if !inEnemy:
	global_position += global_position.direction_to(player.global_position+Vector2(rand.randi_range(-10,10), rand.randi_range(-10,10))) * speed * delta 
	#else:
		#global_position += global_position.direction_to(-neighbour.position) * speed * delta 

func ApplyDamage(damage : int):
	health -= damage
	if health <= 0:
		queue_free()
		
func on_body_entered(body :Node2D):
	if body.is_in_group("player"):
		var player : Player = body
		player.ApplyDamage(damage)
	elif body.is_in_group("enemy"):
		inEnemy = true
		neighbour = body

func _on_body_exited(body :Node2D):
	inEnemy = false
	neighbour = null
