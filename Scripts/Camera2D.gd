extends Camera2D

@export var player : CharacterBody2D
@export var speed : float = 400

func _ready():
	position = player.position

func _process(delta):
	position = player.position
	

