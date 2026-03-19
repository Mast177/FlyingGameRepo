extends Node2D


func _on_warning_timer_timeout() -> void:
	$Body/EyeRight/RayCast2D.is_casting = true
	$Body/EyeRight/LazerWarningParticles.emitting = false
	$AudioStreamPlayer["parameters/switch_to_clip"] = "BeamFire"


func _on_attack_timer_timeout() -> void:
	print("timer activated")
	if $Body/EyeRight/RayCast2D.is_casting:
		#turn off eye lazers
		$Body/EyeRight/RayCast2D.is_casting = false
	else:
		#start lazer attack (including warning time)
		$WarningTimer.start()
		$Body/EyeRight/LazerWarningParticles.emitting = true
		
		$AudioStreamPlayer["parameters/switch_to_clip"] = "BeamCharge"
		$AudioStreamPlayer.play()
