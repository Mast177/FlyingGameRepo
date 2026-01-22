extends Control

#@export var level_path = "res://Scenes/Menus/main_menu_levels_first.tscn"

func _ready() -> void:
	$Label/RetryButton.next_scene = get_tree().current_scene.scene_file_path
	SignalBus.connect("player_died", Callable(self, "game_over"))

func game_over():
	print("game over")
	$AnimationPlayer.play("appear")
	$AnimationPlayer.queue("show_button")
