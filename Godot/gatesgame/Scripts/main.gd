class_name Main extends Node2D

# References
@onready var player = %Player
@onready var modal_background = %ModalBackground
@onready var card_select_ui = $UI/CardSelectUI
@onready var game_over_menu = $UI/GameOverMenu
@onready var enemy_manager = %EnemyManager
@onready var gates_manager = %GatesManager
@onready var level_display_label = $UI/LevelDisplayContainer/LevelDisplayLabel
@onready var time_display = %TimeDisplay

# State
@onready var powerups: Array[Powerup]
@onready var current_level = 1

# Powerups
const FASTER_SHOTS = preload("res://Resources/Instances/Powerups/FasterShots.tres")
const GATE_SHOOTING = preload("res://Resources/Instances/Powerups/GateShooting.tres")
const GATE_SPAWNING = preload("res://Resources/Instances/Powerups/GateSpawning.tres")
const MULTISHOT = preload("res://Resources/Instances/Powerups/Multishot.tres")
const PIERCING_SHOT = preload("res://Resources/Instances/Powerups/PiercingShot.tres")
const SPREADSHOT = preload("res://Resources/Instances/Powerups/Spreadshot.tres")
const SPRING_RAIN = preload("res://Resources/Instances/Powerups/SpringRain.tres")
const TORNADO = preload("res://Resources/Instances/Powerups/Tornado.tres")

func _ready():
	player.game_over.connect(_game_over)
	card_select_ui.powerup_clicked.connect(_on_powerup_clicked)
	_load_initial_cards()

func _game_over():
	_pause_game()
	_animate_in_game_over_menu()

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

func _unpause():
	modal_background.visible = false
	get_tree().paused = false

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

func _on_powerup_clicked(powerup: Powerup):
	player.apply_powerup(powerup)
	if powerup.is_unlock:
		powerups.erase(powerup)
	_load_new_level()

func _load_new_level():
	time_display.visible = true
	_advance_current_level()
	_reset_level()
	await _animate_out_card_select()
	_unpause()


func _reset_level():
	_reset_team_characters()
	_reset_gate_debounce()
	_clear_gates()
	_clear_enemies()
	_restart_boss_timer()
	_restart_wave_spawn_timer()

func _advance_current_level():
	current_level += 1
	enemy_manager.set_difficulty(current_level)
	level_display_label.text = str("level", current_level)
	

func _reset_team_characters():
	player.reset_team_characters()

func _reset_gate_debounce():
	player.reset_gate_debounce()

func _clear_gates():
	gates_manager.clear_gates()

func _clear_enemies():
	enemy_manager.clear_enemies()

func _restart_boss_timer():
	enemy_manager.restart_boss_timer()

func _restart_wave_spawn_timer():
	enemy_manager.restart_wave_spawn_timer()

func _animate_out_card_select():
	return card_select_ui.animate_out()

func on_play_again_button_pressed():
	_set_level_to_starting_level()
	_reset_level()
	await _animate_out_game_over_menu()
	_unpause()

func _set_level_to_starting_level():
	current_level = 1 # git gud
	level_display_label.text = str("level", current_level)

func on_main_menu_button_pressed():
	_unpause()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _animate_in_game_over_menu():
	game_over_menu.animate_in()

func _animate_out_game_over_menu():
	return game_over_menu.animate_out()
