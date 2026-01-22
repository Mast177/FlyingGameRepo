extends ColorRect

@onready var wipe : ColorRect = self

var duration : float

func transition_in(target_scene : String):
	#start off to the left
	wipe.position.x = -get_viewport().size.x
	
	#first half, slide in from left
	var tween = create_tween()
	tween.tween_property(wipe, "position:x", 0, duration / 2)
	tween.tween_callback(func(): SceneTransitionController.transition_half_completed.emit(target_scene))
	
	#second half, slide out to right
	tween.tween_property(wipe, "position:x", get_viewport().size.x, duration / 2)
	tween.tween_callback(func(): SceneTransitionController.transition_completed.emit())
	
