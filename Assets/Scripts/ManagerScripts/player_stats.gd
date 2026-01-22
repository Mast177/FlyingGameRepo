extends Node

var default_health : int = 10
var default_speed : int = 200
var default_damage : int = 2
var default_weapon_count : int = 1
var default_shield : int = 5

var current_health : int
var current_speed : int
var current_damage : int
var current_weapon_count : int
var current_shield : int

var score : int = 0

var cash : int = 0
var cash_earned : int = 0
var total_cash_earned : int = 200
var health_upgrade_amount : int = 0
var speed_upgrade_amount : int = 0
var damage_upgrade_amount : int = 0
var weapon_count_upgrade_amount : int = 0
var shield_upgrade_amount : int = 0

#for first time startup, set current stats to default
func _ready() -> void:
	reset_stats()
	SignalBus.connect("level_complete", Callable(self, "score_cash_convert"))

func score_cash_convert(level : int):
	var highscore = GameManager.levels_score[level]
	if score > highscore:
		print("New Highscore!")
		@warning_ignore("integer_division")
		cash_earned = (score - highscore) / 100
		#wait for other functions using the previous level score to finish
		await get_tree().process_frame
		GameManager.levels_score[level] = score
	else:
		print("No New Highscore")

#set default stat values
func set_default_stats(set_heath : int, set_speed : int, set_damage : int, 
set_weapon_count : int, set_shield : int):
	default_health = set_heath
	default_speed = set_speed
	default_damage = set_damage
	default_weapon_count = set_weapon_count
	default_shield = set_shield

#reset current stats to their defaults
func reset_stats():
	#set current stats to default stats
	current_health = default_health
	current_speed = default_speed
	current_damage = default_damage
	current_weapon_count = default_weapon_count
	current_shield = default_shield
	
	#set upgrade amounts to zero
	health_upgrade_amount = 0
	speed_upgrade_amount = 0
	damage_upgrade_amount = 0
	weapon_count_upgrade_amount = 0
	shield_upgrade_amount = 0
	
	#set current cash to total cash earned
	cash = total_cash_earned

#upgrade current stats
func upgrade_stats(upgrade_heath : int, upgrade_speed : int, upgrade_damage : int, 
upgrade_weapon_count : int, upgrade_shield : int):
	current_health += upgrade_heath
	current_speed += upgrade_speed
	current_damage += upgrade_damage
	current_weapon_count += upgrade_weapon_count
	current_shield += upgrade_shield
