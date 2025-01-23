extends Node

var CursorPos := Vector2.ZERO
var MainCursor := Vector2.ZERO
var Device := "PC"
var LastLookDir := 1

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		Device = "Console"
	if event is InputEventMouseMotion:
		Device = "PC"

func _physics_process(delta: float) -> void:
	if Device == "Console" :
		var ConsoleCursor = Input.get_vector("JoyLeft", "JoyRight", "JoyUp", "JoyDown")
		CursorPos = Vector2(
			ConsoleCursor.x * 55
			,ConsoleCursor.y * 55
		)
