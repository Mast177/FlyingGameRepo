extends Control

func _ready() -> void:
	SignalBus.connect("level_complete", Callable(self, "finished"))
	print("level complete ready")
	
func finished(level : int):
	$AnimationPlayer.play("appear")
	print(PlayerStats.score)
	print(GameManager.levels_score[level])
	if PlayerStats.score > GameManager.levels_score[level]:
		print("new highscore")
		$AnimationPlayer.queue("show_highscore")
	$AnimationPlayer.queue("show_button")
	print("finish signal recieved")
