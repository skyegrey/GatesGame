class_name BossEnemyNode extends EnemyNode

var attack_position_y_coord
var vertical_movespeed: float = 50
var attack_horizontal_movespeed = -350
var jump_speed = 1000
var fall_speed = 100
var jump_lerp_progress = 0
var fall_lerp_progress = 0
var attack_damage_frame = 14

# Scene References
@onready var boss_fight_display_ui: BossFightDisplayUI

# Children References
@onready var attack_hitbox = $AttackHitbox

# Signals
signal boss_defeated

func _ready():
	max_hitpoints = 50
	super()
	move_speed = -50
	player_attack_line_x_coordinate = 500
	sprite.frame_changed.connect(_on_sprite_frame_changed)

func _physics_process(delta):
	if state == States.MOVING_TO_PLAYER:
		position.x += move_speed * delta
		if position.x <= player_attack_line_x_coordinate:
			_change_state(States.PLAYING_INTRO)
	elif state == States.MOVING_TO_ATTACK:
		var move_direction = 1 if position.y < attack_position_y_coord else -1
		position.y += vertical_movespeed * delta * move_direction
		if abs(position.y - attack_position_y_coord) <= 1:
			_change_state(States.ATTACKING_PLAYER)
	elif state == States.ATTACKING_PLAYER:
		var movement_start_frame = 4
		var movement_end_frame = 14
		if sprite.frame >= movement_start_frame && sprite.frame < movement_end_frame:
			position.x += attack_horizontal_movespeed * delta
	elif state == States.RESETTING_POSITION_JUMP_UP:
		if sprite.animation == "jump_up" && sprite.frame >= 7:
			position.y = lerp(attack_position_y_coord, -1000.0, smoothstep(0.0, 1.0, jump_lerp_progress))
			jump_lerp_progress += delta * 5
			if jump_lerp_progress >= 1:
				jump_lerp_progress = 0
				_change_state(States.RESETTING_POSITION_FALLING_DOWN)
	elif state == States.RESETTING_POSITION_FALLING_DOWN:
		if fall_lerp_progress < 1:
			position.y = lerp(-1000.0, 300.0, fall_lerp_progress)
			fall_lerp_progress += delta * 4
		else:
			fall_lerp_progress = 0
			_change_state(States.LANDING)


func _change_state(new_state: States):
	state = new_state
	if state == States.PLAYING_INTRO:
		sprite.play("intro")
		boss_fight_display_ui.visible = true
		sprite.animation_finished.connect(
			_change_state.bind(States.MOVING_TO_ATTACK), 
			CONNECT_ONE_SHOT
		)
	elif state == States.MOVING_TO_ATTACK:
		attack_position_y_coord = randf_range(360, 180)
		sprite.play("default")
	elif state == States.ATTACKING_PLAYER:
		sprite.play("attacking")
		sprite.animation_finished.connect(
			_change_state.bind(States.RESETTING_POSITION_JUMP_UP),
			CONNECT_ONE_SHOT
		)
	elif state == States.RESETTING_POSITION_JUMP_UP:
		sprite.play("jump_up")
	elif state == States.RESETTING_POSITION_FALLING_DOWN:
		position.x = player_attack_line_x_coordinate
	elif state == States.LANDING:
		sprite.play("landing")
		sprite.animation_finished.connect(
			_change_state.bind(States.MOVING_TO_ATTACK),
			CONNECT_ONE_SHOT
		)

func _spawn_attack_hitbox():
	attack_hitbox.monitoring = true
	attack_hitbox.monitorable = true

func _despawn_attack_hitbox():
	attack_hitbox.monitoring = false
	attack_hitbox.monitorable = false

func _on_sprite_frame_changed():
	if state == States.ATTACKING_PLAYER and sprite.frame == attack_damage_frame:
		_spawn_attack_hitbox()
		sprite.frame_changed.connect(_despawn_attack_hitbox, CONNECT_ONE_SHOT)

func _hit_by_attack(attack_area: Area2D):
	super(attack_area)
	_update_boss_fight_display()

func _update_boss_fight_display():
	boss_fight_display_ui.update_hp_bar(hitpoints / max_hitpoints)

func _die():
	boss_fight_display_ui.visible = false
	boss_defeated.emit()
	super()
