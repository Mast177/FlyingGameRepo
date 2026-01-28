extends Node2D

@export var level_number := 0

func _ready() -> void:
	SignalBus.emit_signal("enter_level")
	SignalBus.connect("player_died", Callable(self, "game_over"))
	##
	## set game_manager current level
	##
	GameManager.current_level = level_number

func game_over() -> void:
	$AudioStreamPlayer["parameters/switch_to_clip"] = "Game Over Effect 1"
	
