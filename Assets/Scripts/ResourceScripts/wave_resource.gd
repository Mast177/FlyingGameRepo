extends Resource
class_name Wave

@export var enemy_wave : Array[PackedScene]

@export_group("Wave Parameters")
@export_enum("Spawn One", "Spawn In Line", "Random Spawn", "Left To Right",\
"Right To Left","Spawn In Arrow Down", "Test") var WAVE_SPAWN_BEHAVIOR: String = "Random Spawn"
@export var spawn_index := 0	##The specific spawn index which you want to start spawning at
@export var enemy_index := 0	##The index of an enemy in enemy array ("used for Spawn One")

@export_group("Wave Timing")
@export var wave_cooldown : float = 10.0	## time between waves
@export var spawn_interval : float = 1.0	## time between each enemy spawning
