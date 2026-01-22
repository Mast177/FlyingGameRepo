class_name Hitbox
extends Area2D

#Node: hitbox is what deals damage to the hurtbox

@export var damage := 2


func _init() -> void:
	
	collision_layer = 2		#where the hitbox resides
	collision_mask = 0		#0, bc hitbox does not check for where it can collide
