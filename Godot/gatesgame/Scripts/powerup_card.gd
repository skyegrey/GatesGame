class_name PowerupCard extends NinePatchRect

# Children references
@onready var card_name = $CardMarginContainer/CardInformationVBox/CardName
@onready var powerup_icon = $CardMarginContainer/CardInformationVBox/PowerupIcon
@onready var card_description = $CardMarginContainer/CardInformationVBox/CardDescription

# State
@onready var is_hovered
@onready var powerup_resource: Powerup

# Signals
signal powerup_clicked

func _ready():
	mouse_entered.connect(_set_is_hovered.bind(true))
	mouse_exited.connect(_set_is_hovered.bind(false))

func set_card_resource(_powerup_resource: Powerup):
	powerup_resource = _powerup_resource
	card_name.text = powerup_resource.name
	powerup_icon.texture = powerup_resource.icon
	card_description.text = powerup_resource.description

func _input(event):
	if event is InputEventMouseButton:
		if is_hovered and event.button_index == MOUSE_BUTTON_LEFT:
			powerup_clicked.emit(powerup_resource)

	elif event is InputEventScreenTouch:
		if event.pressed and _is_event_on_element(event.position):
			powerup_clicked.emit(powerup_resource)

func _set_is_hovered(_is_hovered: bool):
	is_hovered = _is_hovered

func _is_event_on_element(event_position: Vector2):
	if global_position.x <= event_position.x and \
	event_position.x <= global_position.x + size.x:
		if global_position.y <= event_position.y and \
		event_position.y <= global_position.y + size.y:
			return true
	return false
