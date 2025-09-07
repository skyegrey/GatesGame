class_name BossFightDisplayUI extends MarginContainer

# Children References
@onready var boss_hp_bar = $Hbox/BossHpBar

@onready var starting_hp_percentage = 1 # percent

func update_hp_bar(new_value):
	var resulting_color = Color.GREEN
	if new_value >= .5:
		# Set color between Green & Yellow
		resulting_color = Color.GREEN * ((new_value - .5) * 2) + Color.YELLOW * ((1 - new_value) * 2)
	else:
		# Set color between Yellow & Red
		resulting_color = Color.RED * ((.5 - new_value) * 2) + Color.YELLOW * (new_value * 2)

	boss_hp_bar.get_theme_stylebox("fill").bg_color = resulting_color
	boss_hp_bar.value = new_value
