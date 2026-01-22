class_name KillBox
extends Area2D

#Note: 	KillBox is meant to detect enemies when they leave the area.
#		enemies must have a detectable hitbox in order to be removed


func _init() -> void:
	collision_layer = 0		#0, bc we do not want it to collide with anything
	collision_mask = 2		#2, bc we want it to detect hitboxes

func _ready() -> void:
	connect("area_entered", self._on_area_entered)

func _on_area_entered(hitbox: Hitbox) -> void:
	#print("detected: " + str(hitbox.owner))
	if hitbox == null:
		print("null hitbox detected")
		return
	hitbox.owner.queue_free()
