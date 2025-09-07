class_name Main extends Node2D

# References
@onready var player = %Player
@onready var modal_background = %ModalBackground
@onready var card_select_ui = $UI/CardSelectUI

# State
@onready var powerups: Array[Powerup]

# Powerups
const FASTER_SHOTS = preload("res://Resources/Instances/Powerups/Faster Shots.tres")
const GATE_SHOOTING = preload("res://Resources/Instances/Powerups/GateShooting.tres")
const GATE_SPAWNING = preload("res://Resources/Instances/Powerups/GateSpawning.tres")
const MULTISHOT = preload("res://Resources/Instances/Powerups/Multishot.tres")
const PIERCING_SHOT = preload("res://Resources/Instances/Powerups/PiercingShot.tres")
const SPREADSHOT = preload("res://Resources/Instances/Powerups/Spreadshot.tres")
const SPRING_RAIN = preload("res://Resources/Instances/Powerups/SpringRain.tres")
const TORNADO = preload("res://Resources/Instances/Powerups/Tornado.tres")

func _ready():
	player.game_over.connect(_game_over)
	_load_initial_cards()

func _game_over():
	_pause_game()

func _load_initial_cards():
	powerups = [
		FASTER_SHOTS, 
		GATE_SHOOTING,
		GATE_SPAWNING,
		MULTISHOT,
		PIERCING_SHOT,
		SPREADSHOT,
		SPRING_RAIN,
		TORNADO
	]

func _pause_game():
	modal_background.visible = true
	get_tree().paused = true

func _display_cards():
	card_select_ui.reset_cards()
	var rolled_powerups = _roll_cards()
	for powerup: Powerup in rolled_powerups:
		card_select_ui.set_card(powerup)
	card_select_ui.animate_in()

func _roll_cards():
	powerups.shuffle()
	return powerups.slice(0, 3)

func on_boss_defeat():
	_pause_game()
	_display_cards()
