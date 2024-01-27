extends Node2D
class_name GameManager

@export var UI : Control
@export var Player : CharacterBody2D
@export var EnemyTypes : Array[PackedScene]
@export var StartEnemyAmount : int = 5
@export var EnemySpwanRate : float = 0.5
@export var MaxEnemies : int = 15
@export var Deck : Deck
var MainMenu : PackedScene
var enemies : Array
var laughtered : int = 0
var laughteredNumber 
var spawnTimer : int = 0
@onready var rand : RandomNumberGenerator = RandomNumberGenerator.new()


func _ready():
	randomize()
	#Player.tree_exited.connect(_on_player_killed)
	#EnemyTypes[0].tree_exited.connect(_on_enemy_slain)
	MainMenu = ResourceLoader.load("res://Scenes/menu.tscn")
	Player.visibility_changed.connect(_on_player_killed)
	laughteredNumber = UI.get_node("Laughtered/LaughteredNumber")
	
	for i in StartEnemyAmount:
		spawnRandomEnemy()
	
	var children = get_children()
	for child in children:
		if child.is_in_group("enemy"):
			enemies.append(child)
			child.tree_exited.connect(_on_enemy_slain)
			print_debug("added enemy")
			
	
	
func _physics_process(delta):
	if spawnTimer >= EnemySpwanRate*60:
		spawnRandomEnemy()
		spawnTimer = 0
	else:
		spawnTimer+=1	
	
	CheckPlayerOverboard()

func CheckPlayerOverboard():
	if Player.global_position > Deck.floorArea:
		get_tree().change_scene_to_packed(MainMenu)

func _on_enemy_slain():
	updateLaughtered()
	enemies.pop_front()

func _on_player_killed():
	get_tree().change_scene_to_packed(MainMenu)

func updateLaughtered():
	laughtered += 1
	laughteredNumber.text = str(laughtered)
	print_debug("update laughtered")
	
func spawnRandomEnemy():
	if enemies.size() < MaxEnemies:
		var r = rand.randi_range(0, EnemyTypes.size()-1)
		var newEnemy : Enemy = EnemyTypes[r].instantiate()
		add_child(newEnemy)
		newEnemy.global_position = Vector2(rand.randi_range(Player.global_position.x+200, Player.global_position.x+800), rand.randi_range(Player.global_position.y+200,Player.global_position.y+800))
		enemies.append(newEnemy)
