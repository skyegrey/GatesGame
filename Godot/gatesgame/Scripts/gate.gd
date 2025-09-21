class_name GateNode extends Node2D

@export var gate_veloctiy: float = 150

@onready var gate_label = $GateLabel
@onready var gate_upgrade_hitbox = $GateUpgradeHitbox
@onready var gate_upgrade_progress_bar = $GateUpgradeProgressBar
@onready var gate_holo = $GateHolo
@onready var red_gate_holo = $RedGateHolo

var gate_shooting_unlocked
var gate_value
var wave

@onready var gate_upgrade_progress = 0

func _ready():
	gate_upgrade_hitbox.area_entered.connect(_on_hit_by_projectile)
	if gate_shooting_unlocked:
		gate_upgrade_progress_bar.visible = true

func _physics_process(delta):
	position += gate_veloctiy * Vector2(-1, 0) * delta

func set_gate_value(_gate_value):
	gate_value = 1 if _gate_value == 0 else _gate_value
	gate_label.text = str("[center]", "+" if gate_value > 0 else "", gate_value)
	if gate_value < 0:
		gate_holo.visible = false
		red_gate_holo.visible = true

func _on_hit_by_projectile(projectile_area: Area2D):
	if not gate_shooting_unlocked:
		return
	gate_upgrade_progress += 1.0 / gate_value ** 2
	if gate_upgrade_progress >= 1:
		_upgrade_gate()
		gate_upgrade_progress = 0
	gate_upgrade_progress_bar.value = gate_upgrade_progress

func _upgrade_gate():
	set_gate_value(gate_value + 1)
