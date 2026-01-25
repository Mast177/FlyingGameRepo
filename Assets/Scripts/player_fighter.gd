extends CharacterBody2D
class_name Player

@export var player : CharacterBody2D
@export var anim : AnimationPlayer
@export var health := 10
@export var MOVEMENT_SPEED : int
@export var damage := 2
@export var weapon_count := 1

@export var shield := 0
@export var shoot_cooldown : float = 0.1
@export var shield_regen_time : float = 3.0
@export var shield_stun_time : float = 5.0

@onready var main = get_tree().get_first_node_in_group("main")
@onready var projectile = load("res://Scenes/Projectiles/orange_projectile.tscn")

var can_shoot = true
var is_dead = false
var shield_up = false
var shield_regen_hp : int = 0

var shield_max = shield
@onready var shield_sprite = $AnimatedSprite2D/AnimatedSprite2DShield
@onready var shield_timer = $ShieldRegenTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	update_stats()
	shield_max = shield
	print("Health: " + str(health))
	print("Speed: " + str(MOVEMENT_SPEED))
	print("Damage: " + str(damage))
	print("Weapon Count: " + str(weapon_count))
	print("Shield: " + str(shield))
	if shield_max > 0:
		shield_up = true
		shield_sprite.play("Shield_Start_Up")
	else:
		shield_sprite.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#allow for shooting with just one button press or by holding down button
	if Input.is_action_just_pressed("Shoot"):
		if can_shoot:
			shoot()
	elif Input.is_action_pressed("Shoot"):
		if can_shoot:
			shoot()

func _physics_process(_delta: float) -> void:
	var input_vector = Input.get_vector("Move_Left","Move_Right","Move_Up","Move_Down")
	#player.velocity = input_vector * MOVEMENT_SPEED
	play_animations(input_vector)
	if is_dead:
		return
	velocity = input_vector * MOVEMENT_SPEED
	move_and_slide()

func update_stats():
	health = PlayerStats.current_health
	MOVEMENT_SPEED = PlayerStats.current_speed
	damage = PlayerStats.current_damage
	weapon_count = PlayerStats.current_weapon_count
	shield = PlayerStats.current_shield

func take_damage(damage_taken: int):
	shield_timer.start(shield_stun_time)
	if shield > 0 and shield_up:
		if shield > damage_taken:
			shield -= damage_taken
			#play shield hit sfx
			print("shield damaged!" + str(shield))
			shield_sprite.play("Shield_Hit")
			return
		elif shield == damage_taken:
			shield = 0
			print("shield downed!")
			shield_sprite.play("Shield_Break")
			shield_up = false
			return
		else:
			damage_taken -= shield
			shield_sprite.play("Shield_Break")
			shield = 0
			shield_up = false
	
	
	health -= damage_taken
	$AudioStreamPlayer.play()
	$AudioStreamPlayer["parameters/switch_to_clip"] = "Hit"
	print(health)
	if health <= 0:
		is_dead = true
		SignalBus.emit_signal("player_died")
		$AudioStreamPlayer["parameters/switch_to_clip"] = "Death"



func play_animations(vector: Vector2):
	if is_dead:
		anim.play("Death")
		return
	if vector.x > 0:
		#right
		if anim.name != "Roll_Right":
			anim.play("Roll_Right")
	elif vector.x < 0:
		#left
		if anim.name != "Roll_Left":
			anim.play("Roll_Left")
	else:
		#level
		if anim.name != "Level":
			anim.play("Level")
#
#func _input(event: InputEvent) -> void:
	#pass


func shoot():
	if is_dead:
		return
	#spawn in projectile
	var instance = projectile.instantiate()
	instance.dir = rotation
	instance.spawnPos = $ProjectileSource.global_position
	instance.spawnRot = rotation
	instance.z_index = (player.z_index -1)
	instance.damage = damage
	instance.add_to_group("player_projectiles")
	main.add_child.call_deferred(instance)
	
	#start weapon cooldown timer
	can_shoot = false
	$ShootCooldownTimer.start(shoot_cooldown)
	

func _on_shoot_cooldown_timer_timeout() -> void:
	can_shoot = true



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Death":
		print("you died")
		queue_free()



func _on_shield_regen_timer_timeout() -> void:
	#print("shield timer out")
	shield_timer.start(shield_regen_time)
	if shield >= shield_max:
		print("Shield hp: " + str(shield) + " Shield_Up = " + str(shield_up))
		return
	if shield_max > 0:
		#from here, assume that shield is always less than shield_max
		if shield_up:
			shield += 1
			print("Shield hp: " + str(shield) + " Shield_Up = " + str(shield_up))
			return
		else:
			shield_regen_hp += 1
		if shield_regen_hp >= shield_max:
			shield_regen_hp = 0
			shield_up = true
			shield = shield_max
			shield_timer.stop()
			shield_sprite.play("Shield_Start_Up")
			print("Shield hp: " + str(shield) + " Shield_Up = " + str(shield_up))
			return
