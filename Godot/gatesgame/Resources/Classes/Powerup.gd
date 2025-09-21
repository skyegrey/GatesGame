class_name Powerup extends Resource

@export var name: String
@export var icon: Texture2D
@export var description: String
@export var modified_stat_key: String
@export var modified_stat_operator: String
@export var modified_stat_value: float
@export var is_unlock: bool
@export var unlocked_ability_key: String
@export var unlocked_cards: Array[Powerup]
