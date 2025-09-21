class_name SpringRainAoENode extends Node2D

@onready var sprite = $Sprite
# Lol?
@onready var aoe_hitbox = $AoEHitbox
@onready var damage = 10

# This is really stupid but its juicy
@onready var hitbox_frames = [
	2, 4, 7, 14, 19, 21
]

func _ready():
	sprite.frame_changed.connect(_on_frame_change)
	sprite.animation_finished.connect(queue_free)

func _on_frame_change():
	aoe_hitbox.monitorable = sprite.frame in hitbox_frames
	aoe_hitbox.monitoring = sprite.frame in hitbox_frames
