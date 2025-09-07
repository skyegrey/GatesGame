class_name ProjectileNode extends Node2D

@onready var projectile_speed: float = 750
@onready var projectile_despawn_limit = 1500
@onready var damage = 10
@onready var area_2d = $Area2D

func _ready():
	area_2d.area_entered.connect(_enemy_hit)

func _physics_process(delta):
	position.x += projectile_speed * delta
	if position.x >= projectile_despawn_limit:
		queue_free()

func _enemy_hit(_enemy_area: Area2D):
	queue_free()
