extends EnemyDefault

#@export var Eye_Right_Particle_Emitter : GPUParticles2D
#@export var Eye_Left_Particle_Emitter : GPUParticles2D

#@export var Eye_Right_Ray : RayCast2D
#@export var Eye_Left_Ray : RayCast2D

func _physics_process(delta: float) -> void:
	move_down(delta)

func _on_warning_timer_timeout() -> void:
	
	$Body/EyeRight.set_casting(true)
	$Body/EyeLeft.set_casting(true)
	$Body/EyeRight.set_warning_particles(false)
	$Body/EyeLeft.set_warning_particles(false)
	$AudioStreamPlayer["parameters/switch_to_clip"] = "BeamFire"


func _on_attack_timer_timeout() -> void:
	print("timer activated")
	if $Body/EyeRight.get_casting():
		#turn off eye lazers
		$Body/EyeRight.set_casting(false)
		$Body/EyeLeft.set_casting(false)
	else:
		#start lazer attack (including warning time)
		$WarningTimer.start()
		$Body/EyeRight.set_warning_particles(true)
		$Body/EyeLeft.set_warning_particles(true)
		
		$AudioStreamPlayer["parameters/switch_to_clip"] = "BeamCharge"
		$AudioStreamPlayer.play()
