class_name GateNode extends Node2D

@export var gate_veloctiy: float = 150
@onready var gate_label = $GateLabel

var gate_value

func _physics_process(delta):
	position += gate_veloctiy * Vector2(-1, 0) * delta

func set_gate_value(_gate_value):
	gate_value = _gate_value
	gate_label.text = str("[center]+", gate_value)
