class_name MainMenu extends Node2D

@onready var embark_button = %EmbarkButton

func _ready():
	embark_button.button_pressed.connect(_on_play_button_pressed)

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
