class_name TeamCharacterNode extends Node2D

# Scene references
var player_node: PlayerNode
var projectile_manager
var particle_manager
var followpoint: Marker2D

# Scenes
const PROJECTILE_NODE = preload("res://Scenes/projectile_node.tscn")
const SPRING_RAIN_PROJECTILE_NODE = preload("res://Scenes/spring_rain_projectile_node.tscn")
const TORNADO = preload("res://Scenes/tornado.tscn")

# Properties
@export var y_follow_deadzone: float = 15
@export var movespeed = 10
@export var spring_rain_attack_chance = .05
@export var spring_rain_projectile_spawn_frame = 5
@export var spring_rain_spawn_x_coordinate = 570
@export var tornado_attack_chance = .05
@export var tornado_attack_spawn_frame = 14
@export var tornado_attack_x_offset = 20

@onready var sprite = $Sprite
@onready var attack_timer = $AttackTimer
@onready var offset: Vector2

@onready var is_moving: bool = false

func _ready():
	attack_timer.timeout.connect(_attack)
	_randomize_timer()
	attack_timer.start()
	sprite.frame_changed.connect(_on_sprite_frame_change)

func _attack():
	if player_node.player_stats.is_spring_rain_unlocked:
		if randf() <= spring_rain_attack_chance:
			_spring_rain_attack()
			return
	if player_node.player_stats.is_tornado_unlocked:
		if randf() <= tornado_attack_chance:
			_tornado_attack()
			return
	_play_attack_animation()
	var attack_count = _roll_multishot_count()
	for attack_index in range(attack_count):
		if attack_index != 0:
			_spawn_projectile()
		else:
			if randf() <= player_node.player_stats.spreadshot_chance:
				_spawn_spreadhshot()
			else:
				_spawn_projectile()
		await get_tree().create_timer(.05).timeout
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
	new_projectile.position = global_position + Vector2(0, randf_range(-5, 5))
	new_projectile.piercing = player_node.player_stats.pierce_count
	new_projectile.hit_target.connect(particle_manager.spawn_on_hit_particle.bind(new_projectile))

func _spawn_spreadhshot():
	var north_projectile = PROJECTILE_NODE.instantiate()
	var south_projectile = PROJECTILE_NODE.instantiate()
	var middle_projectile = PROJECTILE_NODE.instantiate()
	
	for projectile: ProjectileNode in [
		north_projectile,
		middle_projectile,
		south_projectile
	]: 
		projectile.position = global_position
		projectile_manager.add_child(projectile)
		projectile.piercing = player_node.player_stats.pierce_count
	
	north_projectile.rotate(deg_to_rad(-15))
	north_projectile.y_tilt = -200
	
	south_projectile.rotate(deg_to_rad(15))
	south_projectile.y_tilt = 200

func _randomize_timer():
	attack_timer.wait_time = randf_range(
		player_node.player_stats.shot_cooldown*.8, 
		player_node.player_stats.shot_cooldown*1.2
	)

func damage_flash():
	var flash_duration = .10
	var damage_tween = get_tree().create_tween()
	damage_tween.tween_property(sprite, "self_modulate", Color.RED, flash_duration)
	damage_tween.tween_property(sprite, "self_modulate", Color.WHITE, flash_duration)
	damage_tween.set_loops(2)

func _roll_multishot_count():
	if player_node.player_stats.multishot_chance > 0:
		if randf() <= player_node.player_stats.multishot_chance:
			return 2
	return 1

func _spring_rain_attack():
	_play_spring_rain_animation()
	

func _play_spring_rain_animation():
	sprite.play("spring_rain")
	sprite.animation_finished.connect(_on_special_attack_finished, CONNECT_ONE_SHOT)

func _spawn_spring_rain_aoe():
	var spring_rain_node = SPRING_RAIN_PROJECTILE_NODE.instantiate()
	projectile_manager.add_child(spring_rain_node)
	spring_rain_node.position = Vector2(
		spring_rain_spawn_x_coordinate, global_position.y
	)

func _on_sprite_frame_change():
	if sprite.animation == "spring_rain" \
		and sprite.frame == spring_rain_projectile_spawn_frame:
		_spawn_spring_rain_aoe()
	
	if sprite.animation == "tornado" \
		and sprite.frame == tornado_attack_spawn_frame:
			_spawn_tornado()

func _on_special_attack_finished():
	_play_run_animation()
	_randomize_timer()

func _tornado_attack():
	sprite.play("tornado")
	sprite.animation_finished.connect(
		_on_special_attack_finished, 
		CONNECT_ONE_SHOT
	)

func _spawn_tornado():
	var tornado_projectile_node = TORNADO.instantiate()
	projectile_manager.add_child(tornado_projectile_node)
	tornado_projectile_node.position = Vector2(
		global_position.x + tornado_attack_x_offset,
		global_position.y
	)
