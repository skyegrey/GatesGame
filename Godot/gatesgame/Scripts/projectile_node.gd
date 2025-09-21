class_name ProjectileNode extends Node2D

@onready var projectile_speed: float = 750
@onready var projectile_despawn_limit = 1500
@onready var damage = 10
@onready var area_2d = $Area2D
@onready var y_tilt: float = 0
@onready var piercing: int

signal hit_target

func _ready():
	area_2d.area_entered.connect(_enemy_hit)

func _physics_process(delta):
	position.x += projectile_speed * delta
	if y_tilt:
		position.y += y_tilt * delta
	if position.x >= projectile_despawn_limit:
		queue_free()

func _enemy_hit(_enemy_area: Area2D):
	if _enemy_area.get_parent() is GateNode:
		return
	hit_target.emit()
	piercing -= 1
	if piercing <= 0:
		queue_free()
