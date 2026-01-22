extends CharacterBody2D
class_name EnemyDefault
@export var death_sfx : AudioStream
@export var SCORE_VALUE : int = 100
@export var SPEED : int = 100
@export var HEALTH : int = 10
@export_enum("Follow", "Edge Bounce", "Zigzag", "Down", "Still") var BEHAVIOR: String = "Follow"
@export_group("Edge Bounce Angle")
@export_range(0, 180, 1) var angle : float = 0 ## 0 = full right. 180 = full left. 90 = down
#note: damage is kept in hitbox node
@export_group("Zigzag Parameters")
@export_range(0, 180, 1) var zig_angle : float = 45 ## 0 = full right. 180 = full left. 90 = down
@export var direction_change_interval : float = 3.0 ## this is the distance that the enemy will move before changing direction

@export_group("Animation Names")
@export var death : String




@onready var player : CharacterBody2D


var player_pos
var target_pos
var is_alive := true
var edge_bouce_count := 0
var spawnPos : Vector2
var spawnRot : float
var zigzag_behavior_enable := false

var audio_error := false

func _init() -> void:
	motion_mode = MOTION_MODE_FLOATING

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	#if spawnPos and spawnRot are initialized, then set the position and rotation
	if spawnPos:
		global_position = spawnPos
		#global_rotation = spawnRot
	child_ready()
	
	if has_node("AudioStreamPlayer") and death_sfx != null:
		$AudioStreamPlayer.stream = death_sfx
	else:
		print("Error: ", self, "does not have audionode or deathsfx")
		audio_error = true


#this is a function used by child classes to execute their code on _ready()
#without overriding their inherited _ready() function
func child_ready():
	pass

func _physics_process(delta: float) -> void:
	match BEHAVIOR:
		"Follow":
			move_to_player(delta)
		"Edge Bounce":
			edge_bouce(delta)
		"Down":
			move_down(delta)
		"Zigzag":
			zigzag(delta)
			if !zigzag_behavior_enable:
				zigzag_behavior_enable = true
				$ZigzagTimer.wait_time = direction_change_interval
				$ZigzagTimer.start()
	#move_to_player(delta)
	move_and_slide()

#move in a zigzag pattern downwards at designated angle and interval. also bouce off designated playspace walls
func zigzag(delta: float):
	var rad = deg_to_rad(zig_angle)
	#change velocity based on if we had just bounced off an edge
	if edge_bouce_count % 2 == 0:
		target_pos = Vector2(cos(rad), sin(rad))
	else:
		target_pos = Vector2(-cos(rad), sin(rad))
	#target_pos = Vector2(cos(opp_rad), sin(opp_rad))
	if is_alive:
		position += (target_pos * SPEED * delta)

#move enemy straight down
func move_down(delta: float):
	target_pos = Vector2(0, 1)
	if is_alive:
		position += (target_pos * SPEED * delta)

#move enemy directly towards player
func move_to_player(delta: float):
	if !player:
		move_down(delta)
		return
	player_pos = player.position
	target_pos = (player_pos - position).normalized()
	if position.distance_to(player_pos) > 1 and is_alive:
		position += (target_pos * SPEED * delta)

#bouce off of edges of playspace at designated angle
func edge_bouce(delta: float):
	var rad = deg_to_rad(angle)
	#change velocity based on if we had just bounced off an edge
	if edge_bouce_count % 2 == 0:
		target_pos = Vector2(cos(rad), sin(rad))
	else:
		target_pos = Vector2(-cos(rad), sin(rad))
	#target_pos = Vector2(cos(opp_rad), sin(opp_rad))
	if is_alive:
		position += (target_pos * SPEED * delta)


func take_damage(damage : int):
	HEALTH -= damage
	if HEALTH <= 0 and is_alive:
		$AnimatedSprite2D/AnimationPlayer.play(death)
		if audio_error:
			print(self, " audio error death_sfx")
		else:
			$AudioStreamPlayer.play()
		is_alive = false
		var UI = get_tree().get_first_node_in_group("UI")
		if UI.has_method("increase_score"):
			UI.increase_score(SCORE_VALUE)



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == death:
		queue_free()


#here we increment edge_bounce_count whenever we want to bounce on a edge either for zigzag or 
#edge bounce behavior
func _on_edge_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Edge"):
		edge_bouce_count += 1
func _on_zigzag_timer_timeout() -> void:
	edge_bouce_count += 1

#simply remove the enemy without adding points or playing special animation
func remove():
	queue_free()
