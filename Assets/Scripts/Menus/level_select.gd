extends Control

var level_buttons : Array = []
var level_highscore_labels : Array = []

var transition_type : String = "pixelate"
var transition_duration : float = 1.0

func _ready() -> void:
	level_buttons = get_tree().get_nodes_in_group("level_buttons")
	level_highscore_labels = get_tree().get_nodes_in_group("level_highscore_labels")
	var index = 0
	for level in GameManager.levels_unlock:
		if GameManager.levels_unlock[level] == true:
			#level_buttons[index]
			print("Level " + str(level) + " is unlocked")
			level_buttons[index].disabled = false
		else:
			print("Level " + str(level) + " isn't unlocked")
			#level_buttons[index].button_mask = 0
			level_buttons[index].disabled = true
			#$MarginContainer/VBoxContainer/HBoxContainer/Button2.button_mask = 0
			#$MarginContainer/VBoxContainer/HBoxContainer/Button2.disabled = true
		index += 1
	
	apply_highscore()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_T:
			SceneTransitionController.change_scene("res://Scenes/Levels/TestWorld.tscn")

func apply_highscore() -> void:
	for level in GameManager.levels_unlock:
		if GameManager.levels_unlock[level] == true and GameManager.levels_score[level] > 0:
			level_highscore_labels[level - 1].text = str(GameManager.levels_score[level])

func _on_back_button_pressed() -> void:
	get_parent().get_node("AnimationPlayer").play("level select to main")



func _on_button_1_pressed() -> void:
	#get_tree().change_scene_to_file("res://Scenes/Levels/level_1.tscn")
	SceneTransitionController.change_scene("res://Scenes/Levels/level_1.tscn", transition_type, transition_duration)


func _on_button_2_pressed() -> void:
	SceneTransitionController.change_scene("res://Scenes/Levels/level_2.tscn", transition_type, transition_duration)


func _on_button_3_pressed() -> void:
	SceneTransitionController.change_scene("res://Scenes/Levels/level_3.tscn", transition_type, transition_duration)


func _on_button_4_pressed() -> void:
	print("button 4 pressed")


func _on_button_5_pressed() -> void:
	print("button 5 pressed")


func _on_ship_upgrade_menu_button_pressed() -> void:
	get_parent().get_node("AnimationPlayer").play("level select to upgrades")
