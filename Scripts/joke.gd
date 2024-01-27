extends Area2D

@export var speed : float = 900
@export var damage : int = 25
var direction : Vector2

func _ready():
	area_entered.connect(on_body_entered)

func _physics_process(delta):
	position +=  direction.normalized() * speed * delta
	

func on_body_entered(body :Node2D):
	if body.is_in_group("enemy"):
		print_debug("hit enemy")
		var enemy : Enemy = body
		enemy.ApplyDamage(damage)
		queue_free()
