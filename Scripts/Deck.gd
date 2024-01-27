extends Node2D

@export var Floor : Sprite2D
@export var River : Sprite2D

#@export var sprite : Sprite2D
var width : float
var height : float

# Called when the node enters the scene tree for the first time.
func _ready():
	width = DisplayServer.screen_get_size().x
	height = DisplayServer.screen_get_size().y
	Floor.region_rect = Rect2(0,0,width*5,height*5)
	River.region_rect = Rect2(0,0, width*5.5, height*5.5)
