extends CanvasLayer

@export var health_bar : ProgressBar
@export var score_tally : Label

var player : CharacterBody2D
var player_max_health : int
var player_health : int
var score := 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get info about player health
	player = get_tree().get_first_node_in_group("player")
	player_max_health = player.health
	player_health = player.health
	
	#set up healthbar based on player health
	health_bar.max_value = player_max_health
	health_bar.value = player_health
	
	#set up score tally
	score_tally.text = str(score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !player:
		return
	elif player_health != player.health:
		player_health = player.health
		health_bar.value = player_health

# called by other scenes (enemies) so that the score can be increased on enemy death
func increase_score(value: int):
	score += value
	score_tally.text = str(score)
	PlayerStats.score = score
