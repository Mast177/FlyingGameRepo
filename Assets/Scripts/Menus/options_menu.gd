extends Control

var option_menu_open = false

func _process(_delta: float) -> void:
	if option_menu_open:
		$".".visible = true
	else:
		$".".visible = false

func open():
	$AnimationPlayer.play("options_menu_appear")
	option_menu_open = true

func close():
	$AnimationPlayer.play_backwards("options_menu_disappear")
	#same animation is used for appear/disappear, just different names for
	#identifying which one is being played when setting option_menu_open status
	

#these three functions are called when the volume sliders are changed,
#changeing the Master, Music, and SFX volume and setting the volume Spinbox value
func _on_master_volume_value_changed(value: float) -> void:
	var converted_value = value*100.0
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	var MasterVolumeNum = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MasterVolumeNum
	MasterVolumeNum.value = converted_value


func _on_music_volume_value_changed(value: float) -> void:
	var converted_value = value*100.0
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
	var MusicVolumeNum = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer3/MusicVolumeNum
	
	MusicVolumeNum.value = converted_value


func _on_sfx_volume_value_changed(value: float) -> void:
	var converted_value = value*100.0
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))
	var SFXVolumeNum = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer4/SFXVolumeNum
	SFXVolumeNum.value = converted_value


#these three functions are called when the volume Spinbox values have a change submitted,
#changing the Master, Music, and SFX slider values
func _on_master_volume_num_value_changed(value: float) -> void:
	var converted_value = value/100.0
	var MasterVolumeSlider = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MasterVolumeNum/MasterVolume
	MasterVolumeSlider.value = converted_value


func _on_music_volume_num_value_changed(value: float) -> void:
	var converted_value = value/100.0
	var MusicVolumeSlider = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer3/MusicVolumeNum/MusicVolume
	MusicVolumeSlider.value = converted_value


func _on_sfx_volume_num_value_changed(value: float) -> void:
	var converted_value = value/100.0
	var SFXVolumeSlider = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer4/SFXVolumeNum/SFXVolume
	SFXVolumeSlider.value = converted_value


func _on_fullscreen_toggle_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_options_button_pressed() -> void:
	close()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "options_menu_disappear":
		option_menu_open = false
	
