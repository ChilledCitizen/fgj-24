extends CharacterBody2D
class_name Player

@export var speed : float = 400
@export var tickleDist : float = 100
@export var jokeProjectile : PackedScene
@export var tickleArea : PackedScene
@export var health : int = 100
@export var jokeCooldownTime : float = 0.3
@export var tickleCooldownTime : float = 1
var jokeCooldown : float = 0
var tickleCooldown : float = 0
var isTickling : bool = false
var tickleInstance
var sprite : AnimatedSprite2D

enum PlayerState {
	HAPPY,
	NEUTRAL,
	DREAD,
}

var player_state : PlayerState = PlayerState.DREAD

func _ready():
	sprite = get_node("Sprite2D")

func _physics_process(delta):
	
	if !isTickling:
		get_input()
		move_and_slide()
	
	if (jokeCooldown > 0):
		jokeCooldown -= 1

func get_animation_name(animation_type : String) -> String:
	var state = "neutral"

	match player_state:
		PlayerState.HAPPY:
			state = "happy"
		PlayerState.NEUTRAL:
			state = "neutral"
		PlayerState.DREAD:
			state = "dread"

	return state + "_" + animation_type

func play_animation(input : Vector2):
	if input.x == 0 and input.y == 0:
		sprite.play(get_animation_name("idle"))
		return

	if input.x < 0 and transform.x.x > 0:
		transform.x *= -1

	if input.x > 0 and transform.x.x < 0:
		transform.x *= -1

	sprite.play(get_animation_name("walk"))

func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	play_animation(input_direction)
	velocity = input_direction * speed
	
func ApplyDamage(amount :int):
	print_debug("player damaged")
	health =- amount
	if health < 0 :
		visible = false

func tickle():
	isTickling = true
	tickleInstance = tickleArea.instantiate()
	add_child(tickleInstance)
	tickleInstance.global_position = global_position+(Vector2(tickleDist, tickleDist)*(get_global_mouse_position() - global_position).normalized())
	pass

func joke():
	var j = jokeProjectile.instantiate()
	owner.add_child(j)
	j.transform = global_transform
	j.direction = get_global_mouse_position() - global_position
	jokeCooldown = jokeCooldownTime * 60
	pass

func _input(event):
	if event.is_action_pressed("tickle"):
		tickle()
	if event.is_action("joke") && jokeCooldown == 0 && !isTickling:
		print_debug("joked")
		joke()
	elif event.is_action_released("tickle"):
		isTickling = false
		tickleInstance.queue_free()
