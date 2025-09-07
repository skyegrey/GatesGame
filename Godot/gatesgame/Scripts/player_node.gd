class_name PlayerNode extends Node2D

# Scene Resources
const TEAM_CHARACTER = preload("res://Scenes/team_character.tscn")

# Scene references
@onready var projectile_manager = %ProjectileManager

# Children References
@onready var followpoint = $Followpoint
@onready var gates_detection_area = $Followpoint/GatesDetectionArea
@onready var player_hitbox = $Followpoint/PlayerHitbox
@onready var team_members = $TeamMembers
@onready var lead_player: TeamCharacterNode


# Signals
signal game_over

# Properties
@export var character_movespeed = 125
@export var max_y_val = 320
@export var min_y_val = 140


# Private functions
func _ready():
	gates_detection_area.area_entered.connect(_on_gate_area_entered)
	player_hitbox.area_entered.connect(_hit_by_attack)
	_add_initial_character()

func _physics_process(delta):
	var movement_direction = _get_player_input()
	followpoint.position.y = max(
		min_y_val, 
		min(
			max_y_val, 
			(followpoint.position.y + movement_direction * delta * character_movespeed)))

func _get_player_input():
	var movement_direction = 0
	if Input.is_action_pressed("character_move_up"):
		movement_direction = -1
	elif Input.is_action_pressed("character_move_down"):
		movement_direction = 1
	return movement_direction

func _add_initial_character():
	var initial_character = TEAM_CHARACTER.instantiate()
	initial_character.projectile_manager = projectile_manager
	followpoint.add_child(initial_character)
	lead_player = initial_character

func _generate_new_team_member_offset():
	return Vector2(
		randf_range(-15, -70), 
		randf_range(-15, 15)
	)

func _on_gate_area_entered(gate_area: Area2D):
	var gate: GateNode = gate_area.get_parent()
	_add_characters(gate.gate_value)

func _add_characters(new_characters: int):
	for new_character_index in range(new_characters):
		var new_team_character = TEAM_CHARACTER.instantiate()
		var offset = _generate_new_team_member_offset()
		team_members.add_child(new_team_character)
		new_team_character.position = offset + followpoint.position
		new_team_character.projectile_manager = projectile_manager
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
