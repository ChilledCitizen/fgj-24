extends Control

var playScene : PackedScene
var play : Button
var credits : Button
var exit : Button

var ui_hover_audio : AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	
	playScene = ResourceLoader.load('res://Scenes/steamboat_deck.tscn')
	
	play = get_node("CenterContainer/VBoxContainer/Play")
	credits = get_node("CenterContainer/VBoxContainer/Credits")
	exit = get_node("CenterContainer/VBoxContainer/Exit")
	
	ui_hover_audio = get_node("UIHover")
	
	play.pressed.connect(_on_play_pressed)
	credits.pressed.connect(_on_credits_pressed)
	exit.pressed.connect(_on_exit_pressed)

func _on_play_pressed():
	get_tree().change_scene_to_packed(playScene)

func _on_credits_pressed():
	pass

func _on_exit_pressed():
	get_tree().quit()

func _on_play_mouse_entered():
	ui_hover_audio.play()

func _on_credits_mouse_entered():
	ui_hover_audio.play()

func _on_exit_mouse_entered():
	ui_hover_audio.play()
