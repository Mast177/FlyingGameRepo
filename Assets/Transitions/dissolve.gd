extends ColorRect

var noise_texture
var duration : float

func _ready() -> void:
	#create the noise texture
	noise_texture = NoiseTexture2D.new()
	noise_texture.noise = FastNoiseLite.new()
	noise_texture.noise.seed = randi()
	noise_texture.noise.frequency = 0.05
	
	#setup the shader
	material = ShaderMaterial.new()
	material.shader = load("res://Assets/Transitions/dissolve_transition.gdshader")
	material.set_shader_parameter("noise_texture", noise_texture)
	material.set_shader_parameter("threshold", 0.0)
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func transition_in(target_scene : String):
	#dissolve in
	var tween = create_tween()
	tween.tween_method(set_threshold, 0.0, 1.0, duration / 2)
	tween.tween_callback(func(): SceneTransitionController.transition_half_completed.emit(target_scene))
	
	#dissolve out
	tween.tween_method(set_threshold, 1.0, 0.0, duration / 2)
	tween.tween_callback(func(): SceneTransitionController.transition_completed.emit())


func set_threshold(value: float):
	material.set_shader_parameter("threshold", value)
