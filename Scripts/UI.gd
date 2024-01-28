extends Control
class_name UI


signal exit_pressed
signal retry_pressed
signal continue_pressed



@export var rect : TextureRect
@export var gameOver : Control
@export var gameOver_buttons : Array[Button]
@export var pause : Control
@export var pause_buttons : Array[Button]

enum PlayerState {
	HAPPY,
	NEUTRAL,
	DREAD,
	DROWN,
	DEAD
}

@export var faces : Array[Texture2D]

func _ready():
	gameOver.visible = false
	pause.visible = false
	
	for button in gameOver_buttons:
		match button.name:
			"Retry":
				button.pressed.connect(_on_retry_pressed)
			"Exit":
				button.pressed.connect(_on_exit_pressed)
		button.disabled = true
		
	for button in pause_buttons:
		match button.name:
			"Continue":
				button.pressed.connect(_on_continue_pressed)
			"Exit":
				button.pressed.connect(_on_exit_pressed)
	

func OpenPauseMenu():
	pause.visible = true
	
func UpdateState(state):
	var face = faces[0]
	match state:
		PlayerState.HAPPY:
			face = faces[0]
			pass
		PlayerState.NEUTRAL:
			face = faces[1]
			pass
		PlayerState.DREAD:
			face = faces[2]
			pass
		PlayerState.DEAD:
			face = faces[3]
			for button in gameOver_buttons:
				button.disabled = false
			gameOver.visible = true
			pass
	
	rect.texture = face
	
func _on_retry_pressed():
	retry_pressed.emit()

func _on_exit_pressed():
	exit_pressed.emit()

func _on_continue_pressed():
	pause.visible = false
	continue_pressed.emit()
