extends RayCast2D

@export var cast_speed := 7000.0
@export var max_length := 2000.0
@export var is_casting := false: set = set_is_casting
@export var color := Color.WHITE: set = set_color
@export var damage_cooldown := 1.0

@export var eye : Sprite2D

@export var growth_time := 0.5


@onready var line_2d: Line2D = $Line2D
@onready var line_width = line_2d.width
@onready var damage_cooldown_timer = $Timer

@onready var casting_particles : GPUParticles2D = $CastingParticles
@onready var hitting_particles : GPUParticles2D = $HittingParticles


var tween: Tween = null

func _ready() -> void:
	set_color(color)
	set_is_casting(is_casting)
	set_physics_process(is_casting)
	target_position.x = 0.0
	line_2d.visible = false
	damage_cooldown_timer.wait_time = damage_cooldown
	
	
	

func _physics_process(delta: float) -> void:
	target_position.x = move_toward(
		target_position.x,
		max_length,
		cast_speed * delta
	)
	var laser_end_position := target_position
	#print(target_position)
	force_raycast_update()
	if is_colliding() and get_collider().is_in_group("Barrier") == false:
		#print("laser hit")
		var target = get_collider()
		if target.has_method("take_damage") and damage_cooldown_timer.is_stopped():
			#target.take_damage(1)
			damage_cooldown_timer.start()
		laser_end_position = to_local(get_collision_point())
	
	hitting_particles.position = laser_end_position
	hitting_particles.emitting = is_colliding()
	line_2d.points[1] = laser_end_position
	

func appear():
	line_2d.points[1] = Vector2(0.0, 0.0)		#reset lazer line position
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(line_2d, "width", line_width, growth_time * 2.0).from(0.0)
	line_2d.visible = true
	
func disappear():
	#line_2d.visible = false
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(line_2d, "width", 0.0, growth_time).from_current()
	tween.tween_callback(line_2d.hide)
	tween.tween_callback(toggle_rotate)
	#line_2d.visible = false

#turn casting on/off
func set_is_casting(new_value: bool) -> void:
	if is_casting == new_value:
		return
	is_casting = new_value
	set_physics_process(is_casting)
	
	if not line_2d:
		return
	
	if is_casting == false:
		target_position.x = 0.0
		disappear()
		casting_particles.emitting = false
		hitting_particles.emitting = false
	else:
		appear()
		toggle_rotate()
		casting_particles.emitting = true

func set_color(new_color: Color) -> void:
	color = new_color
	if line_2d == null:
		return
	line_2d.modulate = new_color
	casting_particles.modulate = new_color
	hitting_particles.modulate = new_color
	

func test():
	print("test callback")

func toggle_rotate():
	if eye.enable_eye_rotate:
		eye.enable_eye_rotate = false
	else:
		eye.enable_eye_rotate = true
