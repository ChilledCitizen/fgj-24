extends Sprite2D

#@export var sprite : Sprite2D
var width : float
var height : float

# Called when the node enters the scene tree for the first time.
func _ready():
	width = DisplayServer.screen_get_size().x
	height = DisplayServer.screen_get_size().y
	region_rect = Rect2(0,0,width*5,height*5)
