extends Control
@onready var anim = $AnimationPlayer


func _ready() -> void:
	anim.play("RESET")

func resume():
	get_tree().paused = false
	if $Options.option_menu_open:
		$Options.close()
	anim.play_backwards("pause_menu_blur")

func pause():
	get_tree().paused = true
	anim.play("pause_menu_blur")

#activate whenever the pause button is pressed
func toggle_pause():
	if Input.is_action_just_pressed("Pause") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("Pause") and get_tree().paused:
		if $Options.option_menu_open:
			$Options.close()
		else:
			resume()

func _process(_delta: float) -> void:
	toggle_pause()
	

func _on_continue_button_pressed() -> void:
	resume()


func _on_reset_button_pressed() -> void:
	resume()
	get_tree().reload_current_scene()


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_options_button_pressed() -> void:
	$Options.open()
	
