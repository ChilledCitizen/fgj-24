extends Node2D
class_name GameManager

@export var UI : Control
@export var Player : CharacterBody2D
@export var EnemyTypes : Array[PackedScene]
var MainMenu : PackedScene
var enemies : Array[CharacterBody2D]
var laughtered : int = 0
var laughteredNumber 


func _ready():
	#Player.tree_exited.connect(_on_player_killed)
	#EnemyTypes[0].tree_exited.connect(_on_enemy_slain)
	laughteredNumber = UI.get_node("Laughtered/LaughteredNumber")
	var children = get_children()
	for child in children:
		if child.is_in_group("enemy"):
			enemies.append(child)
			child.tree_exited.connect(_on_enemy_slain)
			print_debug("added enemy")
	
func _physics_process(delta):
	pass
	
func _on_enemy_slain():
	updateLaughtered()

func _on_player_killed():
	get_tree().change_scene_to_packed(MainMenu)

func updateLaughtered():
	laughtered += 1
	laughteredNumber.text = str(laughtered)
	print_debug("update laughtered")
