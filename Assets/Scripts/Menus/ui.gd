extends CanvasLayer

@export var health_bar : ProgressBar
@export var shield_bar : ProgressBar
@export var score_tally : Label

var player : CharacterBody2D
var player_max_health : int
var player_max_shield : int
var player_health : int
var player_shield : int
var score := 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await  get_tree().process_frame
	#get info about player health and shield
	player = get_tree().get_first_node_in_group("player")
	player_max_health = player.health
	player_max_shield = player.shield
	player_health = player.health
	player_shield = player.shield
	
	#set up healthbar and shield_bar based on player health and shield
	health_bar.max_value = player_max_health
	health_bar.value = player_health
	shield_bar.max_value = player_max_shield
	shield_bar.value = player_shield
	
	#if the player has shield stats = 0, then do not display shield ui
	if player_max_shield <= 0:
		$Control/HBoxContainer/Panel/Shield.visible = false
		$Control/HBoxContainer/Panel/HBoxContainer2/ShieldBar.visible = false
	
	#set up score tally
	score_tally.text = str(score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !player:
		return
	else:
		if player_health != player.health:
			player_health = player.health
			health_bar.value = player_health
		if player_shield != player.shield:
			player_shield = player.shield
			shield_bar.value = player_shield

# called by other scenes (enemies) so that the score can be increased on enemy death
func increase_score(value: int):
	score += value
	score_tally.text = str(score)
	PlayerStats.score = score
