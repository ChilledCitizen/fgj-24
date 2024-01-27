extends Area2D

@export var damagePerSecond : int = 10
var enemy : Enemy
var hasTarget : bool = false


func _ready():
	area_entered.connect(on_body_entered)
	area_exited.connect(on_body_exited)
	
func _physics_process(delta):
	pass

func on_body_entered(body: Node2D):
	if body.is_in_group("enemy") && !hasTarget:
		enemy = body
		hasTarget = true
	
func on_body_exited(body :Node2D):
	if body.is_in_group("enemy") && hasTarget:
		hasTarget = false
		enemy = null
