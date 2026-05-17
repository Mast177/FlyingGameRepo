extends Sprite2D

@export var rotation_speed := 0.2 	##The speed at which the enemy is allowed to rotate
@export var rotation_time := 0.1	##The amount of time which the enemy must take to turn to the player


@onready var player : CharacterBody2D
@onready var enable_eye_rotate := true
@export var eye_caster : RayCast2D
@export var EYE_DAMAGE := 1



func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")


func _process(delta: float) -> void:
	if  is_instance_valid(player) and enable_eye_rotate:
		#smooth rotate to player
		var player_pos = player.global_position
		var direction = (player_pos - global_position)
		var target_angle = direction.angle() - deg_to_rad(90)
		rotation = lerp_angle(rotation, target_angle, (rotation_speed * delta) / rotation_time)

func cancel():
	set_casting(false)
	set_warning_particles(false)
	

func set_casting(is_casting: bool) -> void:
	$RayCast2D.is_casting = is_casting

func get_casting() -> bool:
	return $RayCast2D.is_casting

func set_warning_particles(is_on: bool) -> void:
	$LazerWarningParticles.emitting = is_on

func take_damage(damage : int) -> void:
	#print("eye took damage")
	if owner.has_method("take_damage"):
		#print("damage from eye to body")
		owner.take_damage(damage*2)
