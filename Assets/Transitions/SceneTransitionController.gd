extends CanvasLayer

signal transition_half_completed(target_scene : String)
signal transition_completed

var current_transition : Node = null
var is_transitioning : bool = false

func change_scene(target_scene : String, transition_type : String = "fade", duration : float = 1.0):
	if is_transitioning:
		return
	is_transitioning = true
	
	#create the transition effect
	var transition_scene : Node = null
	
	match transition_type:
		"pixelate":
			transition_scene = load("res://Assets/Transitions/pixelate.tscn").instantiate()
		"circular":
			transition_scene = load("res://Assets/Transitions/circular.tscn").instantiate()
		"dissolve":
			transition_scene = load("res://Assets/Transitions/dissolve.tscn").instantiate()
		"wipe":
			transition_scene = load("res://Assets/Transitions/wipe.tscn").instantiate()
		"fade":
			transition_scene = load("res://Assets/Transitions/fade.tscn").instantiate()
		_:
			#default if transition type not provided
			transition_scene = load("res://Assets/Transitions/fade.tscn").instantiate()
	
	#set duration
	transition_scene.duration = duration
	
	transition_half_completed.connect(_on_transition_half_completed)
	transition_completed.connect(_on_transition_completed)
	
	#add to scene tree
	add_child(transition_scene)
	current_transition = transition_scene
	
	#start transition
	transition_scene.transition_in(target_scene)

func _on_transition_half_completed(target_scene : String):
	#change to target string
	get_tree().change_scene_to_file(target_scene)

func _on_transition_completed():
	#clean up
	if current_transition:
		current_transition.queue_free()
		current_transition = null
		
		#disconnect old signals
		transition_half_completed.disconnect(_on_transition_half_completed)
		transition_completed.disconnect(_on_transition_completed)
	
	is_transitioning = false
