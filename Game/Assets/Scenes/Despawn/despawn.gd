extends Timer

@export var RandomTime : bool
@export var MinTime = 0.1
@export var MaxTime = 1.0

func _ready() -> void:
	if RandomTime:
		wait_time = randf_range(MinTime, MaxTime)
	start()

func _on_timeout() -> void:
	get_parent().queue_free()
