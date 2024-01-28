extends Node2D

var play_scene : PackedScene

var minnie_voice : AudioStreamPlayer
var minnie_text : Label

var time_to_character : float = 0.1
var current_line : int = 0

var lines = [
	"Help me, Wilhelm!",
	"The on-board entertainment on my steamboat went horribly wrong!",
	"The comedian we hired was hopelessly unfunny...",
	"...and now all the passengers are beyond sad!",
	"They are walking around inflicting their sadness upon others!",
	"Please help me spread joy on this steamboat.",
	"Try tickling (Hold Left Click) them or telling jokes (Right Click) to them.",
	"But be careful! If they get too close to you their dread will wear off on you!",
	"(not good)",
	"Good luck!"
]

func _ready():
	randomize()
	
	play_scene = ResourceLoader.load('res://Scenes/steamboat_deck.tscn')
	minnie_text = get_node("CanvasLayer/TextBoxContainer/TextBox/MarginContainer/Dialogue")
	minnie_voice = get_node("MinnieVoice")
	
	progress_scene()


func _process(delta):
	if Input.is_action_just_released("dialogue_next_line"):
		current_line += 1
		progress_scene()

	if current_line >= 0 and current_line < len(lines) and minnie_text.visible_characters < len(lines[current_line]):
		minnie_text.visible_characters += 1
	else:
		minnie_voice.stop()

func progress_scene():
	if current_line >= len(lines):
		get_tree().change_scene_to_packed(play_scene)
		return

	minnie_text.visible_characters = 0
	var line = lines[current_line]
	minnie_text.text = line
	var offset = randf_range(0, minnie_voice.stream.get_length())
	minnie_voice.play(offset)
