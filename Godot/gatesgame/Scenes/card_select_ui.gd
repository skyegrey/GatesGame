class_name CardSelectUI extends MarginContainer

@export var animation_time = .5 # seconds

@onready var card_container = $CardSelectUIVbox/CardDisplayMarginContainer/HBoxContainer

const POWERUP_CARD = preload("res://Scenes/powerup_card.tscn")

func animate_in():
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "position:y", 0, animation_time)

func reset_cards():
	for card in card_container.get_children():
		card.queue_free()

func set_card(powerup: Powerup):
	var new_powerup_card = POWERUP_CARD.instantiate()
	card_container.add_child(new_powerup_card)
	new_powerup_card.set_card_resource(powerup)
