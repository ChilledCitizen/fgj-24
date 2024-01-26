extends Area2D

@export var speed : float = 900

func _physics_process(delta):
	position += transform.x * speed * delta
	
