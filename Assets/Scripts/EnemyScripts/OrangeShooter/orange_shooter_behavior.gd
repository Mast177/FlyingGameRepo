extends EnemyDefault
class_name OrangeShooter

@export_group("Shooter Parameters")
@export var point_to_player := false
@export var projectile : PackedScene
@export var projectile_damage := 2
@export var rotation_speed := 0.25 	##The speed at which the enemy is allowed to rotate
@export var rotation_time := 0.1	##The amount of time which the enemy must take to turn to the player
@onready var enemy := self
@onready var main = get_tree().get_first_node_in_group("main")



func _ready() -> void:
	$AnimatedSprite2D/AnimationPlayer.play("Shooter/Charge_And_Shoot")
	player = get_tree().get_first_node_in_group("player")
	#if spawnPos and spawnRot are initialized, then set the position and rotation
	if spawnPos:
		global_position = spawnPos
		#global_rotation = spawnRot
	#await get_tree().process_frame
	#print("enemy damage: " + str(projectile_damage))


func shoot():
	#spawn in projectile
	var instance = projectile.instantiate()
	instance.dir = rotation + deg_to_rad(180)
	instance.spawnPos = $ProjectileSource.global_position
	instance.spawnRot = rotation + deg_to_rad(180)
	instance.z_index = (enemy.z_index -1)
	instance.target = "player"
	
	instance.damage = projectile_damage
	
	instance.add_to_group("enemy_projectiles")
	main.add_child.call_deferred(instance)
	#print("enemy shoot")

func _process(delta: float) -> void:
	if point_to_player and is_instance_valid(player):
		#smooth rotate to player
		player_pos = player.global_position
		var direction = (player_pos - position)
		var target_angle = direction.angle() - deg_to_rad(90)
		rotation = lerp_angle(rotation, target_angle, (rotation_speed * delta) / rotation_time)
		
