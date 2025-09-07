class_name PowerupCard extends NinePatchRect

@onready var card_name = $CardMarginContainer/CardInformationVBox/CardName
@onready var powerup_icon = $CardMarginContainer/CardInformationVBox/PowerupIcon
@onready var card_description = $CardMarginContainer/CardInformationVBox/CardDescription

func set_card_resource(powerup_resource: Powerup):
	card_name.text = powerup_resource.Name
	powerup_icon.texture = powerup_resource.Icon
	card_description.text = powerup_resource.Description
