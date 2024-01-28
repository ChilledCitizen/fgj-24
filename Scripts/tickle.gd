extends Area2D
class_name Tickle

signal stopping
@export var damagePerSecond : int = 5
var enemy : Enemy
var hasTarget : bool = false
var player : Player


func _ready():
	area_entered.connect(on_body_entered)
	area_exited.connect(on_body_exited)
	player.tickle_stopped.connect(_on_tickle_stopped)
func _physics_process(delta):
	pass

func on_body_entered(body: Node2D):
	if body.is_in_group("enemy") && enemy == null:
		enemy = body
		enemy.laughed.connect(_on_enemy_laughed)
		print_debug("tickle started on enemy " + body.name)
		
	
func on_body_exited(body :Node2D):
	if body.is_in_group("enemy") && body == enemy:
		print_debug("tickle stopped on enemy " + body.name)
		enemy = null
func _on_enemy_laughed():
	stopping.emit()
	queue_free()
func _on_tickle_stopped():
	stopping.emit()
	queue_free()
