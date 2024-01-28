extends Area2D

@export var speed : float = 900
@export var damage : int = 25
var direction : Vector2
var collider : CollisionShape2D
var particles : GPUParticles2D
var has_hit : bool = false

func _ready():
	area_entered.connect(on_body_entered)
	collider = get_node("CollisionShape2D")
	particles = get_node("GPUParticles2D")

func _physics_process(delta):
	if has_hit:
		return

	position +=  direction.normalized() * speed * delta
	look_at(global_transform.origin + direction)
	
func on_timer_end():
	queue_free()

func on_body_entered(body :Node2D):
	if body.is_in_group("enemy"):
		var enemy : Enemy = body
		enemy.ApplyDamage(damage)
		has_hit = true
		collider.set_deferred("disabled", true)
		particles.amount_ratio = 0.2
		var timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = 0.4
		add_child(timer)
		timer.start()
		timer.connect("timeout", self.on_timer_end)
