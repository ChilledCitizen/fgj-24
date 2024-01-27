extends CharacterBody2D
class_name Player

@export var speed : float = 400
@export var jokeProjectile : PackedScene
@export var tickleArea : PackedScene
@export var health : int = 100
@export var jokeCooldownTime : float = 1
@export var tickleCooldownTime : float = 1
var jokeCooldown : float = 0
var tickleCooldown : float = 0
var isTickling : bool = false
var tickleInstance


func _physics_process(delta):
	
	if !isTickling:
		get_input()
		move_and_slide()
	
	if(jokeCooldown > 0):
		jokeCooldown -= 1
	
	#pass
	
func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
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
	tickleInstance.transform = transform
	pass

func joke():
	var j = jokeProjectile.instantiate()
	owner.add_child(j)
	j.transform = global_transform
	jokeCooldown = jokeCooldownTime * 60
	pass

func _input(event):
	if event.is_action_pressed("tickle"):
		tickle()
	if event.is_action("joke") && jokeCooldown == 0:
		print_debug("joked")
		joke()
	elif event.is_action_released("tickle"):
		isTickling = false
		tickleInstance.queue_free()
