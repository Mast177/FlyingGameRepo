extends Resource
class_name transition_resource

#note: keep transition_type names in lowercase and make sure that scenetransitioncontroler is updated
@export_enum("fade") var transition_type : String = "fade"
@export var next_scene : String		## file path of scene being transitioned to
@export var duration : float = 1.0 	## total time that the transition will take
