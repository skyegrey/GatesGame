class_name EnemyManager extends Node2D

const ENEMY_NODE = preload("res://Scenes/enemy_node.tscn")
const BOSS_ENEMY_NODE = preload("res://Scenes/boss_enemy_node.tscn")

# Scene References
@onready var main = $".."
@onready var player = %Player
@onready var boss_fight_display_ui = %BossFightDisplayUI

@onready var wave_timer = $WaveTimer
@onready var boss_spawn_timer = $BossSpawnTimer

@onready var difficulty = 1

func _ready():
	wave_timer.timeout.connect(_spawn_wave)
	boss_spawn_timer.timeout.connect(_spawn_boss)

func _process(delta):
	difficulty += delta

func _spawn_wave():
	var new_enemy_count = floor(difficulty)
	for new_enemy_index in new_enemy_count:
		var new_enemy = ENEMY_NODE.instantiate()
		new_enemy.position = _get_spawn_position()
		# Is this legal...?
		new_enemy.hit_player.connect(player.hit)
		add_child(new_enemy)

func _get_spawn_position():
	return Vector2(randf_range(660, 760), randf_range(360*.5, 360*.9))

func _spawn_boss():
	wave_timer.stop()
	var boss_enemy = BOSS_ENEMY_NODE.instantiate()
	boss_enemy.position = _get_spawn_position()
	boss_enemy.boss_defeated.connect(main.on_boss_defeat)
	add_child(boss_enemy)
	boss_enemy.boss_fight_display_ui = boss_fight_display_ui
