class_name VirtualJoystick extends Node2D

@export var controller_center_point: Vector2 = Vector2(0, 0)
@export var touch_screen_controller_radius: float = 32

signal movement_started
signal movement_vector_calculated(movement_vector)
signal movement_finished

@onready var touch_screen_cursor = $TouchScreenCursor

func _ready():
	touch_screen_cursor.position = controller_center_point

func _input(event):
	if event is InputEventScreenTouch:
		_handle_touch_screen_press(event)

	if event is InputEventScreenDrag:
		_update_movement(event)

func _begin_move(event):
	movement_started.emit()
	_update_movement(event)

func _end_move():
	_reset_cursor()
	movement_finished.emit()

func _handle_touch_screen_press(event):
	if event.pressed:
		_begin_move(event)
	else:
		_end_move()

func _update_movement(event):
	var movement_vector = _calculate_movement_vector(event)
	movement_vector = _clamp_movement_vector_to_circle_radius(movement_vector)
	_update_touch_screen_cusror(movement_vector)
	movement_vector = _scale_movement_vector_magnitude(movement_vector)
	movement_vector_calculated.emit(movement_vector)

func _calculate_movement_vector(event):
	return to_local(event.position) - controller_center_point

func _clamp_movement_vector_to_circle_radius(movement_vector):
	var movement_vector_magnitude = movement_vector.length()
	if movement_vector_magnitude > touch_screen_controller_radius:
		var magnitude_scalar = touch_screen_controller_radius / movement_vector_magnitude
		movement_vector = movement_vector * magnitude_scalar
	return movement_vector

func _scale_movement_vector_magnitude(movement_vector):
	movement_vector /= touch_screen_controller_radius
	return movement_vector

func _update_touch_screen_cusror(new_position):
	touch_screen_cursor.position = new_position
	
func _reset_cursor():
	_update_touch_screen_cusror(Vector2(0, 0))
