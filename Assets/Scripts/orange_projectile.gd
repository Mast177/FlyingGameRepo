extends CharacterBody2D
class_name OrangeProjectile

@export var SPEED : float


var damage := 2
var dir : float
var spawnPos : Vector2
var spawnRot : float
var target := "enemy"

func _ready() -> void:
	global_position = spawnPos
	global_rotation = spawnRot
	await get_tree().process_frame
	$Hitbox.damage = damage
	

func _physics_process(_delta: float) -> void:
	velocity = Vector2(0, -SPEED).rotated(dir)
	move_and_slide()


#this is used to remove the projectile after it exists for too long or after it explodes
func _on_life_time_timeout() -> void:
	queue_free()



#this allows for the projectile to specifically despawn when it detects the hitbox of an enemy
func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.owner.is_in_group(target):
		#print("hit")
		$HitSFX.play()
		explode()

#function that creates particle effects on the removal of the projectile
func explode():
	#wait until next frame to explode incase collision is on same frame as spawning
	await get_tree().process_frame
	$ExplosionParticles.emitting = true
	$TrailParticles.emitting = false
	$LifeTime.start(1.0)
	SPEED = 0
	$Hitbox.queue_free()	#here we remove hitbox and hurtbox to prevent the projectile from detecting
	$Hurtbox.queue_free()	#other objects as it is exploding. Prevents extra damage and crashing
	$Sprite2D.visible = false
	
