extends Node2D
class_name GameManager

@export var UI : Control
@export var Player : CharacterBody2D
@export var EnemyTypes : Array[PackedScene]
@export var StartEnemyAmount : int = 5
@export var EnemySpwanRate : float = 0.5
@export var DifficultyRampRate : float = 1.5
@export var DifficultyRampTime : float = 10
@export var MaxEnemies : int = 15
@export var Deck : Deck
var MainMenu : PackedScene
var enemies : Array
var laughtered : int = 0
var laughteredNumber 
var spawnTimer : int = 0
@onready var rand : RandomNumberGenerator = RandomNumberGenerator.new()
var _enemySpawnRate

var music : AudioStreamPlayer
var death_jingle : AudioStreamPlayer
var pause_music : AudioStreamPlayer

var should_spawn_enemy : bool = true
var difficultyRampTimer : Timer

signal player_drown

func _ready():
	randomize()
	_enemySpawnRate = EnemySpwanRate*60
	#Player.tree_exited.connect(_on_player_killed)
	#EnemyTypes[0].tree_exited.connect(_on_enemy_slain)
	MainMenu = ResourceLoader.load("res://Scenes/menu.tscn")
	laughteredNumber = UI.get_node("Laughtered/LaughteredNumber")
	Player.state_changed.connect(_player_state_changed)
	UI.retry_pressed.connect(_retry_pressed)
	UI.exit_pressed.connect(_exit_pressed)
	UI.continue_pressed.connect(continueGame)
	
	difficultyRampTimer = Timer.new()
	difficultyRampTimer.wait_time = DifficultyRampTime
	difficultyRampTimer.timeout.connect(rampUpDifficulty)
	difficultyRampTimer.one_shot = false
	add_child(difficultyRampTimer)
	difficultyRampTimer.start()
	
	music = get_node("MainMusic")
	death_jingle = get_node("DeathJingle")
	pause_music = get_node("PauseMusic")
	
	for i in StartEnemyAmount:
		spawnRandomEnemy()
	
	var children = get_children()
	for child in children:
		if child.is_in_group("enemy"):
			enemies.append(child)
			child.tree_exited.connect(_on_enemy_slain)
			print_debug("added enemy")
	
	if DifficultyRampRate <= 0:
		DifficultyRampRate = 1
	
	
func _physics_process(delta):
	if spawnTimer >= _enemySpawnRate && len(enemies) < MaxEnemies:
		spawnRandomEnemy()
		print_debug("added enemy in update")
		spawnTimer = 0
	else:
		spawnTimer+=1	
	
	CheckPlayerOverboard()

func CheckPlayerOverboard():
	if abs(Player.global_position.x) > Deck.floorArea.x/2 + Player.spriteSize.x|| abs(Player.global_position.y) > Deck.floorArea.y/2 + Player.spriteSize.y:
		_on_player_overboard()

func _on_enemy_slain():
	updateLaughtered()
	enemies.pop_front()

func _on_player_killed():
	#player_drown.emit()
	pass

func _on_player_overboard():
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
		newEnemy.global_position = enemySpawnLocation()
		newEnemy.tree_exited.connect(_on_enemy_slain)
		enemies.append(newEnemy)

func enemySpawnLocation():
	var location  = Vector2(0,0)
	var validArea = Vector2(Deck.floorArea.x/2, Deck.floorArea.y/2)
	var playerPosition = Player.global_position
	#Spawn outside of screen
	var randomAngle = rand.randi()*PI*2
	var randomPoint = Vector2(cos(randomAngle)*100, sin(randomAngle)*100)
	var screenArea = Vector2(Deck.width, Deck.height)
	var rawLocation = Player.global_position+screenArea*(randomPoint-Player.global_position).normalized()
	location = clamp(rawLocation,-validArea, validArea)
	
	return location
	
func _player_state_changed(state):
	UI.UpdateState(state)
	if state == Player.PlayerState.DEAD or state == Player.PlayerState.DROWN:
		should_spawn_enemy = false
		music.stop()
		death_jingle.play()
		HighscoreManager.SetHighscore(laughtered)
		UI.SetEndScores(laughtered)
	
	UI.UpdateState(state)

func _exit_pressed():
	if get_tree().paused:
		get_tree().paused = false
	get_tree().change_scene_to_packed(MainMenu)
	
func _retry_pressed():
	get_tree().reload_current_scene()

func pauseGame():
	get_tree().paused = true
	UI.OpenPauseMenu()
	pause_music.play()

func continueGame():
	get_tree().paused = false
	pause_music.stop()

func _input(event):
	if event.is_action("pause"):
		pauseGame()

func rampUpDifficulty():
	MaxEnemies = MaxEnemies*DifficultyRampRate
	_enemySpawnRate = clamp(_enemySpawnRate/DifficultyRampRate, 1, INF)
	print_debug("ramp difficulty, max enemies: " + str(MaxEnemies) +", rate: " + str(_enemySpawnRate))
	
	
