class_name Background extends Node2D

@export var scroll_speed: float = 50
@export var image_size: int = 360
var bg_teleport_x_coordinate: int

func _ready():
	bg_teleport_x_coordinate = -image_size / 2

func _process(delta):
	for bg_sprite in get_children():
		bg_sprite.position.x -= delta * scroll_speed
		if bg_sprite.position.x <= bg_teleport_x_coordinate:
			bg_sprite.position.x += image_size * 3
