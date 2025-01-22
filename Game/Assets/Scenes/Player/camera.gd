extends Camera2D

var Accel := 15

var MaxZoom := Vector2(2, 2)
var MinZoom := Vector2(0.4, 0.4)

var CamPos := 55

var ZoomSpeed := 0.1

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("NormalZoom"):
		zoom = Vector2(1, 1)
	
	if (Input.is_action_pressed("ZoomOut") or Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_UP)) && zoom >= MinZoom:
		zoom = lerp(zoom, Vector2(zoom.x - ZoomSpeed, zoom.y - ZoomSpeed), Accel * delta)
	if (Input.is_action_pressed("ZoomIn") or Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_DOWN)) && zoom <= MaxZoom:
		zoom = lerp(zoom, Vector2(zoom.x + ZoomSpeed, zoom.y + ZoomSpeed), Accel * delta)
	if Input.is_action_pressed("Aim"):
		DynamicCam(delta)
	else:
		position = lerp(position, Vector2.ZERO, 5 * delta)

func DynamicCam(delta):
	var CustomPos = position
	if get_local_mouse_position().x > CamPos:
		CustomPos.x = (CamPos * 2) / zoom.x
	if get_local_mouse_position().x < -CamPos:
		CustomPos.x = -CamPos / zoom.x
	if get_local_mouse_position().y > CamPos:
		CustomPos.y = CamPos / zoom.x
	if get_local_mouse_position().y < -CamPos:
		CustomPos.y = -CamPos / zoom.x

	position = lerp(position, CustomPos, 5 * delta)
