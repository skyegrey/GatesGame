class_name GatesManager extends Node2D

const GATE_NODE = preload("res://Scenes/gate_node.tscn")

@onready var player = %Player

@onready var gate_spawn_timer = $GateSpawnTimer
@onready var gates = $Gates

@onready var wave = 1

# spacing... ~65px
@export var gate_index_to_spawn_y_value = [
	165,
	230,
	295
]

func _ready():
	gate_spawn_timer.wait_time = player.player_stats.gate_spawn_cooldown
	gate_spawn_timer.timeout.connect(_spawn_gates)

func _spawn_gates():
	var gate_values = []
	for gate_spawn_index in range(3):
		gate_values.append(_roll_gate_value())
	
	var positive_gate_index = randi_range(0, 2)
	if gate_values[positive_gate_index] <= 0:
		# Oh skye cant you just modify the in pla-
		# its by reference idiot its the same speed
		# actually its one less call on the cl-
		# shush
		gate_values[positive_gate_index] = -1 * gate_values[positive_gate_index]
	
	for gate_value_index in gate_values.size():
		var new_gate = GATE_NODE.instantiate()
		new_gate.gate_shooting_unlocked = player.player_stats.is_gate_shooting_unlocked
		gates.add_child(new_gate)
		new_gate.set_gate_value(gate_values[gate_value_index])
		new_gate.wave = wave
		new_gate.position = Vector2(
			700, 
			gate_index_to_spawn_y_value[gate_value_index]
		)
	wave += 1
	gate_spawn_timer.wait_time = player.player_stats.gate_spawn_cooldown

func _roll_gate_position():
	return Vector2(700, randf_range(360*.5, 360*.9))

func _roll_gate_value():
	var gate_value = 0
	while gate_value == 0:
		gate_value = randi_range(-3, 3)
	return gate_value

func clear_gates():
	for gate in gates.get_children():
		gate.queue_free()
