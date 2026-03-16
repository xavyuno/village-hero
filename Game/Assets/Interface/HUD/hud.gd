extends Control

func _physics_process(delta: float) -> void:
	$Health.text = "Health: " + str(User.Health) + " Protection: " + str(User.Protection)
	$Level.text = "Level: " + str(User.Level)
	$Level/Progress.value = User.Exp
	$Level/Progress.max_value = User.ReqExp
