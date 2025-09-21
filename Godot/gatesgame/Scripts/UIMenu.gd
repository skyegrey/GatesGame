class_name UIMenu extends MarginContainer

@export var animation_time = .5 # seconds
@export var starting_y_position = 360

func animate_in():
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "position:y", 0, animation_time)

func animate_out():
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "position:y", starting_y_position, animation_time)
	return tween
