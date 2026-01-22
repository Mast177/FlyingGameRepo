extends ColorRect

var duration : float
var max_pixel_size := 150.0

func _ready() -> void:
	material = ShaderMaterial.new()
	material.shader = load("res://Assets/Transitions/pixelate_transition.gdshader")
	material.set_shader_parameter("pixel_size", 1.0)
	material.set_shader_parameter("darkness", 0.0)
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func transition_in(target_scene : String):
	#pixelate in
	var tween = create_tween()
	tween.tween_method(set_pixel_size, max_pixel_size, 0.1,  duration / 4)
	tween.tween_method(set_darkness, 0.0, 1.0, duration / 4)
	tween.tween_callback(func(): SceneTransitionController.transition_half_completed.emit(target_scene))
	
	#pixelate out
	tween.tween_method(set_darkness, 1.0, 0.0, duration / 4)
	tween.tween_method(set_pixel_size, 0.1, max_pixel_size, duration / 4)
	tween.tween_callback(func(): SceneTransitionController.transition_completed.emit())

func set_pixel_size(value : float):
	material.set_shader_parameter("pixel_size", value)

func set_darkness(value : float):
	material.set_shader_parameter("darkness", value)
