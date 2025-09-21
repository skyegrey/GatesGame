class_name EnemyManager extends Node2D

const ENEMY_NODE = preload("res://Scenes/enemy_node.tscn")
const BOSS_ENEMY_NODE = preload("res://Scenes/boss_enemy_node.tscn")

# Scene References
@onready var main = $".."
@onready var player = %Player
@onready var boss_fight_display_ui = %BossFightDisplayUI
@onready var round_time_remaining_label = %RoundTimeRemainingLabel
@onready var time_display = %TimeDisplay

@onready var wave_timer = $WaveTimer
@onready var boss_spawn_timer = $BossSpawnTimer
@onready var enemies = $Enemies
@onready var difficulty = 1
@onready var level = 1

@export var level_boss_hp_scaler = 300 # 100, 200, 300 etc.
@export var level_hp_scaler = 10 # 20, 30, 40 etc.


func _ready():
	wave_timer.timeout.connect(_spawn_wave)
	boss_spawn_timer.timeout.connect(_spawn_boss)

func _process(delta):
	difficulty += delta
	round_time_remaining_label.text = _format_timer_text(boss_spawn_timer.time_left)

func _spawn_wave():
	var new_enemy_count = _get_spawn_count()
	for new_enemy_index in new_enemy_count:
		var new_enemy = ENEMY_NODE.instantiate()
		new_enemy.position = _get_spawn_position()
		# Is this legal...?
		new_enemy.hit_player.connect(player.hit)
		enemies.add_child(new_enemy)
		new_enemy.set_hitpoints(_get_normal_enemy_hp())

func _get_spawn_position():
	return Vector2(randf_range(660, 760), randf_range(360*.5, 360*.9))

func _spawn_boss():
	time_display.visible = false
	var boss_enemy = BOSS_ENEMY_NODE.instantiate()
	boss_enemy.position = _get_spawn_position()
	boss_enemy.tree_exited.connect(main.on_boss_defeat)
	enemies.add_child(boss_enemy)
	boss_enemy.set_hitpoints(_get_boss_enemy_hp())
	boss_enemy.boss_fight_display_ui = boss_fight_display_ui
	boss_fight_display_ui.visible = true

func clear_enemies():
	for enemy_node in enemies.get_children():
		enemy_node.queue_free()

func restart_boss_timer():
	boss_spawn_timer.wait_time += level
	boss_spawn_timer.start()

func restart_wave_spawn_timer():
	wave_timer.start()

func _format_timer_text(time: float):
	var minutes = floori(time / 60)
	var seconds = floori(time - (minutes * 60))
	var formated_seconds = '0' + str(seconds) if seconds < 10 else seconds
	return '{minutes}:{seconds}'.format({
		'minutes': minutes,
		'seconds': formated_seconds
	})

func _get_spawn_count():
	# :(
	return floori(1.06 ** difficulty)

func set_difficulty(_new_difficulty):
	level = _new_difficulty
	difficulty = _new_difficulty

func _get_boss_enemy_hp():
	return level * level_boss_hp_scaler

func _get_normal_enemy_hp():
	return level_hp_scaler * (level + 1)
