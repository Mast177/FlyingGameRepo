extends EnemyDefault

#@export var Eye_Right_Particle_Emitter : GPUParticles2D
#@export var Eye_Left_Particle_Emitter : GPUParticles2D

#@export var Eye_Right_Ray : RayCast2D
#@export var Eye_Left_Ray : RayCast2D
var MAXHEALTH : int
var stage_2_set := false

func child_ready():
	
	MAXHEALTH = HEALTH
	BEHAVIOR = "Down"
	await get_tree().create_timer(5).timeout
	$Body/AnimationPlayer.play("Laugh")
	BEHAVIOR = "Still"
	await $Body/AnimationPlayer.animation_finished
	$Body/AnimationPlayer.play("Idle")
	$AttackTimer.start()
	BEHAVIOR = "Zigzag"


func cancel_attacks():
	$AttackTimer.stop()
	$WarningTimer.stop()
	$Body/EyeRight.cancel()
	$Body/EyeLeft.cancel()

func play_explosions():
	$Body/EyeRight.queue_free()
	$Body/EyeLeft.queue_free()
	var explosion_sprites = $Body/Explosions.get_children()
	for sprite in explosion_sprites:
		sprite.play()
		$Body/Explosions/AudioStreamPlayer.play()
		await get_tree().create_timer(0.25).timeout
	await get_tree().create_timer(3.0).timeout
	queue_free()

func take_damage(damage : int):
	#print("took damage")
	HEALTH -= damage
	print("Heath: ", HEALTH)
	if HEALTH <= 0 and is_alive:
		cancel_attacks()
		play_explosions()
		#print("enemy dead")
		
		$Body/AnimationPlayer.play("Death")
		#$AudioStreamPlayer["parameters/switch_to_clip"] = "Death"
		is_alive = false
		var UI = get_tree().get_first_node_in_group("UI")
		if UI.has_method("increase_score"):
			UI.increase_score(SCORE_VALUE)
	
	@warning_ignore("integer_division")
	if HEALTH < MAXHEALTH / 2 and !stage_2_set:
		print("Half health")
		stage_2_set = true
		SPEED *= 2
		$AttackTimer.wait_time = 1.5

func _on_warning_timer_timeout() -> void:
	
	$Body/EyeRight.set_casting(true)
	$Body/EyeLeft.set_casting(true)
	$Body/EyeRight.set_warning_particles(false)
	$Body/EyeLeft.set_warning_particles(false)
	$AudioStreamPlayer["parameters/switch_to_clip"] = "BeamFire"
	$AudioStreamPlayer.play()


func _on_attack_timer_timeout() -> void:
	print("timer activated")
	if $Body/EyeRight.get_casting() or is_alive == false:
		#turn off eye lazers
		$Body/EyeRight.set_casting(false)
		$Body/EyeLeft.set_casting(false)
		set_physics_process(true)
	else:
		#start lazer attack (including warning time)
		$WarningTimer.start()
		$Body/EyeRight.set_warning_particles(true)
		$Body/EyeLeft.set_warning_particles(true)
		
		$AudioStreamPlayer["parameters/switch_to_clip"] = "BeamCharge"
		$AudioStreamPlayer.play()
		#stop movement
		set_physics_process(false)
