class_name BossFightDisplayUI extends MarginContainer

# Children References
@onready var boss_hp_bar = $Hbox/BossHpBar

@onready var starting_hp_percentage = 1 # percent

func update_hp_bar(new_value):
	boss_hp_bar.value = new_value
