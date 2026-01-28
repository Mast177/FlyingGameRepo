extends Node

var waves_finished := false
var next_level : int = 1
var current_level : int = 0
var in_level := false
var player_alive := true

var levels_unlock : Dictionary = {
	1 : true,
	2 : false,
	3 : false,
	4 : false,
	5 : false
}

var levels_path : Dictionary = {
	1 : "res://Scenes/Levels/level_1.tscn",
	2 : "res://Scenes/Levels/level_2.tscn",
	3 : "res://Scenes/Levels/level_3.tscn",
	4 : "res://Scenes/Levels/level_1.tscn",
	5 : "res://Scenes/Levels/level_1.tscn"
}

var levels_score : Dictionary = {
	1 : 0,
	2 : 0,
	3 : 0,
	4 : 0,
	5 : 0,
}

func _ready() -> void:
	SignalBus.connect("waves_finished", Callable(self, "_on_waves_finished_signal_recieved"))
	#print("game manager prepared")
	SignalBus.connect("enter_level", Callable(self, "_on_level_entered_signal_recieved"))
	SignalBus.connect("level_complete", Callable(self, "_on_level_complete_signal_recieved"))
	SignalBus.connect("player_died", Callable(self, "_on_player_died_signal_recieved"))

func _process(_delta: float) -> void:
	if get_tree().get_nodes_in_group("enemy").size() < 1 and waves_finished and player_alive:
		print("all enemies defeated, level completed!")
		waves_finished = false
		SignalBus.emit_signal("level_complete", current_level)
		#get_tree().change_scene_to_file("res://Scenes/Menus/level_select.tscn")
	
	## process cheats
	if Input.is_action_just_pressed("Level_Skip") and in_level:
		SignalBus.emit_signal("level_complete", current_level)
		print("waves finished on level: " + str(current_level))
		levels_unlock[current_level + 1] = true
		if next_level < (current_level + 1):
			next_level = current_level + 1

func _on_waves_finished_signal_recieved(level : int):
	waves_finished = true
	print("waves finished on level: " + str(level))
	levels_unlock[level + 1] = true
	if next_level < (level + 1):
		next_level = level + 1

#this function is called by the signalbus to tell the game manager that
#the player is in a level and that level-related cheats can be enabled
func _on_level_entered_signal_recieved():
	in_level = true
	player_alive = true
func _on_level_complete_signal_recieved(_level_number : int):
	in_level = false
func _on_player_died_signal_recieved():
	player_alive = false
