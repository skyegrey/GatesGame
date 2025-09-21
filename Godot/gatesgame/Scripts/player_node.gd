class_name PlayerNode extends Node2D

# Scene Resources
const TEAM_CHARACTER = preload("res://Scenes/team_character.tscn")

# Scene references
@onready var projectile_manager = %ProjectileManager
@onready var virtual_joystick_control = %VirtualJoystickControl
@onready var particle_manager = %ParticleManager

# Children References
@onready var followpoint = $Followpoint
@onready var gates_detection_area = $Followpoint/GatesDetectionArea
@onready var player_hitbox = $Followpoint/PlayerHitbox
@onready var team_members = $TeamMembers
@onready var lead_player: TeamCharacterNode

# State
@onready var player_stats = PlayerStats.new()
@onready var gate_debounce = {}
@onready var has_keyboard_input
@onready var is_moving
@onready var drag_start_position_y
@onready var resulting_movment

# Signals
signal game_over

# Properties
@export var character_movespeed = 125
@export var max_y_val = 320
@export var min_y_val = 140
@export var modified_stat_key_to_stat = {}

# Private functions
func _ready():
	gates_detection_area.area_entered.connect(_on_gate_area_entered)
	player_hitbox.area_entered.connect(_hit_by_attack)
	_add_initial_character()
	virtual_joystick_control.press_started.connect(_on_press_start)
	virtual_joystick_control.drag_position_changed.connect(_on_drag_position_changed)
	virtual_joystick_control.press_ended.connect(_on_drag_ended)

func _physics_process(delta):
	_detect_keyboard_inputs()
	if is_moving or has_keyboard_input:
		followpoint.position.y = max(
			min_y_val, 
			min(
				max_y_val, 
				(followpoint.position.y + resulting_movment * delta * character_movespeed)))

func _detect_keyboard_inputs():
	if Input.is_action_pressed("character_move_up"):
		has_keyboard_input = true
		resulting_movment = -1
	elif Input.is_action_pressed("character_move_down"):
		has_keyboard_input = true
		resulting_movment = 1
	else:
		has_keyboard_input = false

func _on_press_start(_drag_start_position_y: float):
	is_moving = true
	drag_start_position_y = _drag_start_position_y

func _on_drag_position_changed(drag_position_y: float):
	if not is_moving:
		return
	if drag_position_y > drag_start_position_y:
		resulting_movment = 1
	elif drag_position_y < drag_start_position_y:
		resulting_movment = -1
	else:
		# TODO Deadzone?
		resulting_movment = 0

func _on_drag_ended():
	is_moving = false

func _add_initial_character():
	var initial_character = TEAM_CHARACTER.instantiate()
	initial_character.projectile_manager = projectile_manager
	initial_character.particle_manager = particle_manager
	initial_character.player_node = self
	followpoint.add_child(initial_character)
	lead_player = initial_character

func _generate_new_team_member_offset():
	return Vector2(
		randf_range(-15, -70), 
		randf_range(-15, 15)
	)

func _on_gate_area_entered(gate_area: Area2D):
	var gate: GateNode = gate_area.get_parent()
	if not gate_debounce.has(gate.wave):
		if gate.gate_value > 0:
			_add_characters(gate.gate_value)
		else:
			for index in range(abs(gate.gate_value)):
				_destroy_random_character()
		gate_debounce[gate.wave] = true

func _add_characters(new_characters: int):
	for new_character_index in range(new_characters):
		var new_team_character = TEAM_CHARACTER.instantiate()
		var offset = _generate_new_team_member_offset()
		new_team_character.player_node = self
		team_members.add_child(new_team_character)
		new_team_character.position = offset + followpoint.position
		new_team_character.projectile_manager = projectile_manager
		new_team_character.particle_manager = particle_manager
		new_team_character.offset = offset
		new_team_character.followpoint = followpoint

func _destroy_random_character():
	var team_member_nodes: Array[Node] = team_members.get_children()
	if team_member_nodes.size() > 0:
		team_member_nodes.pick_random().queue_free()
	else:
		game_over.emit()

func _play_damage_flash():
	lead_player.damage_flash()
	for team_character: TeamCharacterNode in team_members.get_children():
		team_character.damage_flash()

func _hit_by_attack(_attack_area: Area2D):
	hit()

# Public Functions
func hit():
	_destroy_random_character()
	_play_damage_flash()

func apply_powerup(powerup: Powerup):
	if not powerup.is_unlock:
		match powerup.modified_stat_key:
			"MULTISHOT_CHANCE":
				player_stats.multishot_chance += .2
			"SPREADSHOT_CHANCE":
				player_stats.spreadshot_chance += .2
			"FIRE_RATE":
				player_stats.shot_cooldown *= .95
			"PIERCE_COUNT":
				player_stats.pierce_count += 1
			"GATE_SPAWN_RATE":
				player_stats.gate_spawn_cooldown *= .95

	else:
		match powerup.unlocked_ability_key:
			"SPRING_RAIN": 
				player_stats.is_spring_rain_unlocked = true
			"TORNADO":
				player_stats.is_tornado_unlocked = true
			"GATE_SHOOTING":
				player_stats.is_gate_shooting_unlocked = true

func reset_team_characters():
	for child in team_members.get_children():
		child.queue_free()

func reset_gate_debounce():
	gate_debounce = {}
