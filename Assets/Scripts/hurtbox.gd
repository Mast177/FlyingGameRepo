class_name Hurtbox
extends Area2D

#Note: Hurtbox is what takes damage designated by the colliding hitbox

@export var audio : AudioStreamPlayer2D
@export var enable_friendly_fire : bool = false ## if enabled, this can take damage from other enemies

func _init() -> void:
	collision_layer = 0		#0, bc we do not want it to collide with anything
	collision_mask = 2		#2, bc we want it to detect hitboxes

func _ready() -> void:
	connect("area_entered", self._on_area_entered)
	

func damage(hitbox: Hitbox):
	#only call take_damage() func if owner has that method
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)

func _on_area_entered(hitbox: Hitbox) -> void:
	#simple check. make sure that only hitboxes are aknowledged to prevent bugs
	if hitbox == null or hitbox.owner == self.owner or \
	(hitbox.owner.is_in_group("player_projectiles") and self.owner.is_in_group("player") or \
	(hitbox.owner.is_in_group("enemy_projectiles") and self.owner.is_in_group("enemy"))):
		return
	
	if hitbox.is_in_group("Explosion"):
		damage(hitbox)
		return
	
	#check for friendly fire
	if !enable_friendly_fire and (hitbox.owner.is_in_group("enemy") and self.owner.is_in_group("enemy")):
		return
	else:
		damage(hitbox)
