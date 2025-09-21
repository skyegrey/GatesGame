class_name CardSelectUI extends UIMenu

@onready var card_container = $CardSelectUIVbox/CardDisplayMarginContainer/HBoxContainer

const POWERUP_CARD = preload("res://Scenes/powerup_card.tscn")

signal powerup_clicked

func reset_cards():
	for card in card_container.get_children():
		card.queue_free()

func set_card(powerup: Powerup):
	var new_powerup_card = POWERUP_CARD.instantiate()
	card_container.add_child(new_powerup_card)
	new_powerup_card.set_card_resource(powerup)
	new_powerup_card.powerup_clicked.connect(_on_powerup_clicked)

func _on_powerup_clicked(powerup: Powerup):
	reset_cards()
	powerup_clicked.emit(powerup)
