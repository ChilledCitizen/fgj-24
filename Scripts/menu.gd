extends Control

var playScene : PackedScene
var intro : PackedScene
var play : Button
var credits : Button
var exit : Button

var main_menu_container : VBoxContainer
var options_menu_container : VBoxContainer
var credits_container : VBoxContainer

var ui_hover_audio : AudioStreamPlayer

var main_volume_index = AudioServer.get_bus_index("Master")
var music_volume_index = AudioServer.get_bus_index("Music")
var sfx_volume_index = AudioServer.get_bus_index("SFX")

var main_volume_slider : HSlider
var sfx_volume_slider : HSlider
var music_volume_slider : HSlider

# Called when the node enters the scene tree for the first time.
func _ready():
	
	playScene = ResourceLoader.load('res://Scenes/steamboat_deck.tscn')
	intro = ResourceLoader.load('res://Scenes/intro_cutscene.tscn')
	
	play = get_node("CenterContainer/MainMenuContainer/ButtonContainer/Play")
	credits = get_node("CenterContainer/MainMenuContainer/ButtonContainer/Credits")
	exit = get_node("CenterContainer/MainMenuContainer/ButtonContainer/Exit")
	
	main_menu_container = get_node("CenterContainer/MainMenuContainer")
	options_menu_container = get_node("CenterContainer/OptionsMenuContainer")
	credits_container = get_node("CenterContainer/CreditsContainer")
	
	main_volume_slider = get_node("CenterContainer/OptionsMenuContainer/VolumeSliderContainer/MainVolumeSlider")
	if main_volume_slider:
		main_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(main_volume_index))
	
	sfx_volume_slider = get_node("CenterContainer/OptionsMenuContainer/VolumeSliderContainer/SoundVolumeSlider")
	if sfx_volume_slider:
		sfx_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_volume_index))
	
	music_volume_slider = get_node("CenterContainer/OptionsMenuContainer/VolumeSliderContainer/MusicVolumeSlider")
	if music_volume_slider:
		music_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_volume_index))
	
	ui_hover_audio = get_node("UIHover")
	
	play.pressed.connect(_on_play_pressed)
	credits.pressed.connect(_on_credits_pressed)
	exit.pressed.connect(_on_exit_pressed)

func _on_play_pressed():
	# get_tree().change_scene_to_packed(playScene)
	get_tree().change_scene_to_packed(intro)

func _on_options_pressed():
	main_menu_container.visible = false
	options_menu_container.visible = true

func _on_credits_pressed():
	main_menu_container.visible = false
	credits_container.visible = true

func _on_exit_pressed():
	get_tree().quit()

func _on_button_hover():
	ui_hover_audio.play()

func _on_main_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(main_volume_index, linear_to_db(value))


func _on_sound_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(sfx_volume_index, linear_to_db(value))


func _on_music_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(music_volume_index, linear_to_db(value))


func _on_back_pressed():
	options_menu_container.visible = false
	credits_container.visible = false
	main_menu_container.visible = true

