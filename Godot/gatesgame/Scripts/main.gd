class_name Main extends Node2D

# References
@onready var player = %Player
@onready var modal_background = %ModalBackground

func _ready():
	player.game_over.connect(_game_over)

func _game_over():
	_pause_game()

func _pause_game():
	modal_background.visible = true
	get_tree().paused = true

func _display_cards():
	pass

func on_boss_defeat():
	_pause_game()
	_display_cards()
