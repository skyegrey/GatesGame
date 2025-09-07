class_name EnemyNode extends Node2D

# References
@onready var hurtbox = $Hurtbox
@onready var sprite: AnimatedSprite2D = $Sprite

# Properties
@export var move_speed: float = -75
@export var player_attack_line_x_coordinate: float = 200
@onready var max_hitpoints: float = 20
@onready var attack_damaging_frame: int = 4

# State
enum States {
	# friends :)
	MOVING_TO_PLAYER, PLAYING_INTRO, MOVING_TO_ATTACK, ATTACKING_PLAYER, 
	RESETTING_POSITION_JUMP_UP, RESETTING_POSITION_FALLING_DOWN, LANDING
}
@onready var state = States.MOVING_TO_PLAYER
@onready var hitpoints: float

# Signals
signal hit_player

func _ready():
	hurtbox.area_entered.connect(_hit_by_attack)
	sprite.set_frame_and_progress(randi_range(0, 10), 0)
	sprite.frame_changed.connect(_on_sprite_frame_change)
	hitpoints = max_hitpoints

func _physics_process(delta):
	if state == States.MOVING_TO_PLAYER:
		position.x += move_speed * delta
		if position.x <= player_attack_line_x_coordinate:
			_change_state(States.ATTACKING_PLAYER)

func _take_damage(damage_amount: int):
	hitpoints -= damage_amount
	if hitpoints <= 0:
		_die()

func _hit_by_attack(attack_area: Area2D):
	var attack_node = attack_area.get_parent()
	_take_damage(attack_node.damage)
	_damage_flash()
	
func _die():
	queue_free()

func _damage_flash():
	var flash_duration = .15
	var damage_tween = get_tree().create_tween()
	damage_tween.tween_property(sprite, "self_modulate", Color.RED, flash_duration)
	damage_tween.tween_property(sprite, "self_modulate", Color.WHITE, flash_duration)
	damage_tween.set_loops(2)

func _change_state(new_state: States):
	state = new_state
	if new_state == States.ATTACKING_PLAYER:
		sprite.play("attacking")

func _on_sprite_frame_change():
	if state != States.ATTACKING_PLAYER:
		return
	if sprite.frame == attack_damaging_frame:
		hit_player.emit()
