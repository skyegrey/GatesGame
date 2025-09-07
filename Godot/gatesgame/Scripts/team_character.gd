class_name TeamCharacterNode extends Node2D

# Scene references
var projectile_manager
var followpoint: Marker2D

const PROJECTILE_NODE = preload("res://Scenes/projectile_node.tscn")

@export var y_follow_deadzone: float = 15
@export var movespeed = 10

@onready var sprite = $Sprite
@onready var attack_timer = $AttackTimer
@onready var offset: Vector2

@onready var is_moving: bool = false

func _ready():
	attack_timer.timeout.connect(_attack)
	_randomize_timer()
	attack_timer.start()

func _attack():
	_play_attack_animation()
	_spawn_projectile()
	_randomize_timer()
	

func _physics_process(delta):
	if followpoint:
		if abs(followpoint.position.y - position.y) >= y_follow_deadzone:
			is_moving = true
		if is_moving:
			var target = followpoint.position.y + offset.y
			var direction = 1 if target > position.y else -1
			var distance = abs(position.y - target)
			var speed = max(1, distance) * movespeed
			position.y += speed * direction * delta
			if abs(position.y - (followpoint.position.y + offset.y)) <= .05:
				is_moving = false

func _play_attack_animation():
	sprite.play("attacking")
	sprite.offset = Vector2(0, -10)
	sprite.animation_finished.connect(_play_run_animation, CONNECT_ONE_SHOT)

func _play_run_animation():
	sprite.offset = Vector2(0, 0)
	sprite.play("default")

func _spawn_projectile():
	var new_projectile = PROJECTILE_NODE.instantiate()
	projectile_manager.add_child(new_projectile)
	new_projectile.position = global_position

func _randomize_timer():
	attack_timer.wait_time = randf_range(1, 2)

func damage_flash():
	var flash_duration = .10
	var damage_tween = get_tree().create_tween()
	damage_tween.tween_property(sprite, "self_modulate", Color.RED, flash_duration)
	damage_tween.tween_property(sprite, "self_modulate", Color.WHITE, flash_duration)
	damage_tween.set_loops(2)
