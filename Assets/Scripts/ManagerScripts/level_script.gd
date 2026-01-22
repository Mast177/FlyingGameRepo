extends Node2D



func _ready() -> void:
	SignalBus.emit_signal("enter_level")
	SignalBus.connect("player_died", Callable(self, "game_over"))

func game_over() -> void:
	$AudioStreamPlayer["parameters/switch_to_clip"] = "Game Over Effect 1"
	
