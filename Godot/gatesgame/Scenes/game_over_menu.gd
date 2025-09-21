class_name GameOverMenu extends UIMenu

@onready var play_again_button = $VBoxContainer/MarginContainer/VBoxContainer2/PlayAgainButton
@onready var main_menu_button = $VBoxContainer/MarginContainer/VBoxContainer2/MainMenuButton

@onready var main = $"../.."

func _ready():
	play_again_button.button_pressed.connect(main.on_play_again_button_pressed)
	main_menu_button.button_pressed.connect(main.on_main_menu_button_pressed)
