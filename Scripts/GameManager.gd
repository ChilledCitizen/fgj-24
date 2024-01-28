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

var music : AudioStreamPlayer
var death_jingle : AudioStreamPlayer

var should_spawn_enemy : bool = true

signal player_drown

func _ready():
	randomize()
	EnemySpwanRate = EnemySpwanRate*60
	#Player.tree_exited.connect(_on_player_killed)
	#EnemyTypes[0].tree_exited.connect(_on_enemy_slain)
	MainMenu = ResourceLoader.load("res://Scenes/menu.tscn")
	Player.visibility_changed.connect(_on_player_killed)
	laughteredNumber = UI.get_node("Laughtered/LaughteredNumber")
	Player.state_changed.connect(_player_state_changed)
	UI.retry_pressed.connect(_retry_pressed)
	UI.exit_pressed.connect(_exit_pressed)
	UI.continue_pressed.connect(continueGame)
	
	music = get_node("MainMusic")
	death_jingle = get_node("DeathJingle")
	
	for i in StartEnemyAmount:
		spawnRandomEnemy()
	
	var children = get_children()
	for child in children:
		if child.is_in_group("enemy"):
			enemies.append(child)
			child.tree_exited.connect(_on_enemy_slain)
			print_debug("added enemy")
			
	
	
func _physics_process(delta):
	if spawnTimer >= EnemySpwanRate && len(enemies) < MaxEnemies:
		spawnRandomEnemy()
		print_debug("added enemy in update")
		spawnTimer = 0
	else:
		spawnTimer+=1	
	
	CheckPlayerOverboard()

func CheckPlayerOverboard():
	if abs(Player.global_position.x) > Deck.floorArea.x/2 + Player.spriteSize.x|| abs(Player.global_position.y) > Deck.floorArea.y/2 + Player.spriteSize.y:
		_on_player_killed()

func _on_enemy_slain():
	updateLaughtered()
	enemies.pop_front()

func _on_player_killed():
	player_drown.emit()

func updateLaughtered():
	laughtered += 1
	laughteredNumber.text = str(laughtered)
	print_debug("update laughtered")
	
func spawnRandomEnemy():
	if !should_spawn_enemy:
		return

	if enemies.size() < MaxEnemies:
		var r = rand.randi_range(0, EnemyTypes.size()-1)
		var newEnemy : Enemy = EnemyTypes[r].instantiate()
		add_child(newEnemy)
		newEnemy.global_position = Vector2(rand.randi_range(Player.global_position.x+200, Player.global_position.x+800), rand.randi_range(Player.global_position.y+200,Player.global_position.y+800))
		newEnemy.tree_exited.connect(_on_enemy_slain)
		enemies.append(newEnemy)
		
func _player_state_changed(state):
	UI.UpdateState(state)
	if state == Player.PlayerState.DEAD or state == Player.PlayerState.DROWN:
		should_spawn_enemy = false
		music.stop()
		death_jingle.play()
		
func _exit_pressed():
	if get_tree().paused:
		get_tree().paused = false
	_on_player_killed()
	
func _retry_pressed():
	get_tree().reload_current_scene()

func pauseGame():
	get_tree().paused = true
	UI.OpenPauseMenu()

func continueGame():
	get_tree().paused = false

func _input(event):
	if event.is_action("pause"):
		pauseGame()
