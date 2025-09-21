class_name VirtualJoystickControl extends Node

# now are you RUSHING or are you DRAGGING?
var is_dragging: bool = false
var event_start_y_position: float

signal press_started
signal drag_position_changed
signal press_ended

@onready var player = %Player

func _ready():
	pass

func _input(event):
	if event is InputEventScreenTouch:
		_handle_touch_screen_press(event)

	if event is InputEventScreenDrag:
		_update_movement(event)

func _handle_touch_screen_press(event: InputEventScreenTouch):
	if event.pressed:
		press_started.emit(event.position.y)
	else:
		press_ended.emit()

func _update_movement(event: InputEventScreenDrag):
	drag_position_changed.emit(event.position.y)
