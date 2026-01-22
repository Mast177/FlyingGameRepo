extends EnemyDefault
class_name Poofer

var rotation_speed = 0.5
var rotate_opposite = false

#when spawning in, randomly choose rotation direction
func child_ready():
	if randi_range(1,2) == 1:
		rotate_opposite = true


func _process(delta: float) -> void:
	if rotate_opposite:
		rotation = (rotation - rotation_speed * delta)
	else:
		rotation = (rotation + rotation_speed * delta)

#when the player enters the detector area, explode
func _on_player_detector_area_entered(area: Area2D) -> void:
	if area.owner.is_in_group("player"):
		print("player trigger blast")
		$AnimatedSprite2D/AnimationPlayer.play(death)
		is_alive = false
