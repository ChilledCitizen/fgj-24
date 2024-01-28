extends Area2D
class_name Enemy

@export var base_speed : float = 100
@export var health : int = 100
@export var damage : int = 5
@onready var collision_shape_2d = %CollisionShape2D
var player : Player
#var inEnemy : bool = false
var neighbour : Enemy
var speed
var rand
var tickling : bool = false
var hit : bool = false
var tickleDamage = 0
var wander : bool = false
#var rngVector : Vector2 = Vector2(-100, 100)

var step_sound_parent : Node
var step_sounds : Array[AudioStreamPlayer2D]
var sprite : AnimatedSprite2D
var can_make_sound : bool = false
var laugh_sound : AudioStreamPlayer2D
var hit_particles : GPUParticles2D

var death_timer : Timer
var death_delay : float = 1.0

var damage_flash_count : int = 8
var flashes_left : int = 8
var flashing : bool = false

func init_step_sounds():
	step_sound_parent = get_node("StepSounds")
	sprite = get_node("Sprite2D")
	for sound in step_sound_parent.get_children():
		step_sounds.append(sound)

func _ready():
	randomize()
	player = get_tree().root.get_child(0).get_node("Player")
	body_entered.connect(on_body_entered)
	area_entered.connect(on_body_entered)
	area_exited.connect(_on_body_exited)
	body_exited.connect(_on_body_exited)
	rand = RandomNumberGenerator.new()
	speed = rand.randi_range(base_speed/2, base_speed*2)
	init_step_sounds()
	player.state_changed.connect(_on_player_dead)
	laugh_sound = get_node("LaughSound")
	hit_particles = get_node("HitParticles")
	init_death_timer()
	
func _physics_process(delta):
	if !tickling && !hit && !wander && health > 0:
		global_position += global_position.direction_to(player.global_position+Vector2(rand.randi_range(-10,10), rand.randi_range(-10,10))) * speed * delta 
	elif tickling:
		ApplyDamage(tickleDamage)
	elif wander:
		global_position += (global_position - player.global_position).normalized() * speed*2 * delta
		
func _process(delta):
	if Engine.get_physics_frames() % 8 == 0 and flashing:
		sprite.visible = !sprite.visible
		flashes_left -= 1
	
	if flashes_left == 0:
		flashing = false

func init_death_timer():
	death_timer = Timer.new()
	death_timer.wait_time = death_delay
	death_timer.one_shot = true
	add_child(death_timer)
	death_timer.connect("timeout", self.on_timer_end)

func on_timer_end():
	queue_free()

func ApplyDamage(damage : int):
	health -= damage
	hit_particles.emitting = true
	flashes_left = damage_flash_count
	flashing = true
	if health <= 0:
		flashing = false
		sprite.visible = true
		collision_shape_2d.disabled = true
		sprite.play("laugh")
		if laugh_sound:
			laugh_sound.play()
		death_timer.start()
		
func play_random_step_sound():
	if sprite.animation != "walk":
		print("wrong anim")
		return

	if sprite.frame != 0:
		return

	var index = randi_range(0, len(step_sounds) - 1)

	if index >= len(step_sounds):
		print("index")
		return

	step_sounds[index].play()
		
func on_body_entered(body :Node2D):
	if body.is_in_group("player"):
		var player : Player = body
		player.ApplyDamage(damage)
	elif body.is_in_group("enemy"):
		pass
		#inEnemy = true
		#neighbour = body
	elif body.is_in_group("player_attack"):
		if body.is_in_group("tickle"):
			if body.hasTarget == false:
				tickling = true
				tickleDamage = body.damagePerSecond
		else:
			hit = true

func _on_body_exited(body :Node2D):
	#inEnemy = false
	#neighbour = null
	if body.is_in_group("player_attack"):
		tickling = false
		hit = false

func _on_sprite_2d_frame_changed():
	play_random_step_sound()
		
func _on_player_dead(state):
	if state == Player.PlayerState.DEAD:
		wander = true
