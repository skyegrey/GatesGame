class_name TouchButton extends NinePatchRect

signal button_pressed

func _input(event):
	if event is InputEventMouseButton:
		if event.button_mask == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if _is_event_on_element(event.position):
					button_pressed.emit()
	elif event is InputEventScreenTouch:
		if event.pressed:
			if _is_event_on_element(event.position):
				button_pressed.emit()

func _is_event_on_element(event_position: Vector2):
	if global_position.x <= event_position.x and \
	event_position.x <= global_position.x + size.x:
		if global_position.y <= event_position.y and \
		event_position.y <= global_position.y + size.y:
			return true
	return false
