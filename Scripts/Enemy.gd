extends Area2D
class_name Enemy

const SEPARATION_WEIGHT = 0.1
const ALIGNMENT_WEIGHT = 0.1
const COHESION_WEIGHT = 0.1

@export var speed : float = 150
@export var health : int = 100
@export var damage : int = 20
@onready var collision_shape_2d = %CollisionShape2D

var player
var _direction = Vector2(1,1)
var _local_flockmates : Array
var _separation_distance = 2

func _ready():
	player = get_tree().root.get_child(0).get_node("Player")
	body_entered.connect(on_body_entered)
	area_entered.connect(on_body_entered)
	body_exited.connect(_on_detection_radius_body_exited)
	
func _physics_process(delta):
	global_position += global_position.direction_to(player.global_position) * speed * delta * _flock_direction().normalized()

func ApplyDamage(damage : int):
	health -= damage
	if health <= 0:
		queue_free()
		
func on_body_entered(body :Node2D):
	if body.is_in_group("player"):
		var player : Player = body
		player.ApplyDamage(damage)
	elif body.is_in_group("enemy"):
		_local_flockmates.push_back(body)


func _flock_direction():
	var separation = Vector2()
	var heading = _direction
	var cohesion = Vector2()

	for flockmate in _local_flockmates:
		heading += flockmate.get_direction()
		cohesion += flockmate.position

		var distance = self.position.distance_to(flockmate.position)

		if distance < _separation_distance:
			separation -= (flockmate.position - self.position).normalized() * (_separation_distance / distance * speed)

	if _local_flockmates.size() > 0:
		heading /= _local_flockmates.size()
		cohesion /= _local_flockmates.size()
		var center_direction = self.position.direction_to(cohesion)
		var center_speed = speed * self.position.distance_to(cohesion) / collision_shape_2d.shape.radius

		cohesion = center_direction * center_speed

	return (
		_direction +
		separation * SEPARATION_WEIGHT +
		heading * ALIGNMENT_WEIGHT +
		cohesion * COHESION_WEIGHT
	)


func _on_detection_radius_body_exited(body):
	if body.is_in_group("enemy"):
		_local_flockmates.erase(body)

func get_direction():
	return _direction
