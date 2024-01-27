extends Node2D
class_name Deck

@export var Floor : Sprite2D
@export var River : Sprite2D
@export var Size : float = 3

#@export var sprite : Sprite2D
var width : float
var height : float
var floorArea : Vector2 = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	width = DisplayServer.screen_get_size().x
	height = DisplayServer.screen_get_size().y
	Floor.region_rect = Rect2(0,0,width*Size,height*Size)
	River.region_rect = Rect2(0,0, width*Size*1.1, height*Size*1.1)
	
	floorArea = Floor.get_rect().size

func _physics_process(delta):
	pass
