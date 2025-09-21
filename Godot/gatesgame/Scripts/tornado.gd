# TODO Inheret from 'PlayerAttack' or something?
class_name TornadoNode extends Node2D

@onready var sprite = $Sprite
@onready var hitbox = $Hitbox

@export var projectile_speed: float = 375
@export var projectile_despawn_limit = 600
@export var damage = 10


func _ready():
	sprite.animation_finished.connect(_on_animation_finished, CONNECT_ONE_SHOT)
	# It worked for the other one... so...
	sprite.frame_changed.connect(_on_sprite_frame_change)

func _physics_process(delta):
	position.x += projectile_speed * delta
	if position.x >= projectile_despawn_limit:
		_animate_out()

func _on_animation_finished():
	sprite.play("full_spin")

func _animate_out():
	sprite.play("fizzle")
	sprite.animation_finished.connect(queue_free, CONNECT_ONE_SHOT)

func _on_sprite_frame_change():
	# They call him the flipper
	hitbox.monitorable = sprite.frame % 2 == 1
	hitbox.monitoring = sprite.frame % 2 == 1
