extends ColorRect

var duration : float
var center = Vector2(0.5, 0.5)

func _ready() -> void:
	#setup the shader
	material = ShaderMaterial.new()
	material.shader = load("res://Assets/Transitions/circular_tramsition.gdshader")
	material.set_shader_parameter("center", center)
	material.set_shader_parameter("radius", 0.0)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
func transition_in(target_scene : String):
	#expand the circle
	var tween = create_tween()
	tween.tween_method(set_radius, 0.0, 1.5, duration / 2)
	tween.tween_callback(func(): SceneTransitionController.transition_half_completed.emit(target_scene))
	
	#contract the circle
	tween.tween_method(set_radius, 1.5, 0.0, duration / 2)
	tween.tween_callback(func(): SceneTransitionController.transition_completed.emit())
	
func set_radius(value : float):
	material.set_shader_parameter("radius", value)

func set_center(value: Vector2):
	material.set_shader_parameter("center", value)
