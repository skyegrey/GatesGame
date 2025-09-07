class_name GatesManager extends Node2D

const GATE_NODE = preload("res://Scenes/gate_node.tscn")

@onready var gate_spawn_timer = $GateSpawnTimer

func _ready():
	gate_spawn_timer.timeout.connect(_spawn_gates)

func _spawn_gates():
	var new_gate = GATE_NODE.instantiate()
	add_child(new_gate)
	new_gate.set_gate_value(_roll_gate_value())
	new_gate.position = _roll_gate_position()

func _roll_gate_position():
	return Vector2(700, randf_range(360*.5, 360*.9))

func _roll_gate_value():
	return randi_range(1, 3)
