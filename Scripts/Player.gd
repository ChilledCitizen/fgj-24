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
var step_sound_parent : Node
var step_sounds : Array[AudioStreamPlayer2D]
var audio_listener : AudioListener2D
var tickle_sound : AudioStreamPlayer2D
var joke_sound : AudioStreamPlayer2D

enum PlayerState {
	HAPPY,
	NEUTRAL,
	DREAD,
}

var player_state : PlayerState = PlayerState.DREAD

func init_step_sounds():
	step_sound_parent = get_node("StepSounds")
	sprite = get_node("Sprite2D")

	for sound in step_sound_parent.get_children():
		step_sounds.append(sound)

func _ready():
	audio_listener = get_node("AudioListener2D")
	audio_listener.make_current()
	
	tickle_sound = get_node("Tickle")
	joke_sound = get_node("Joke")

	init_step_sounds()
	randomize()

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
	tickle_sound.play()
	pass

func joke():
	var j = jokeProjectile.instantiate()
	owner.add_child(j)
	j.transform = global_transform
	j.direction = get_global_mouse_position() - global_position
	jokeCooldown = jokeCooldownTime * 60
	joke_sound.play()

func play_random_step_sound():
	if !sprite.animation.ends_with("_walk"):
		return
		
	if sprite.frame != 0:
		return

	var index = randi_range(0, 4)

	if index >= len(step_sounds):
		return

	step_sounds[index].play()

func _input(event):
	if event.is_action_pressed("tickle"):
		tickle()
	if event.is_action("joke") && jokeCooldown == 0 && !isTickling:
		print_debug("joked")
		joke()
	elif event.is_action_released("tickle"):
		isTickling = false
		tickleInstance.queue_free()
		tickle_sound.stop()
		tickle_sound.seek(0)


func _on_sprite_2d_frame_changed():
	play_random_step_sound()
