extends Node2D

var Accel := 8.5

@export var BodyIcon : Texture

@onready var torso: Sprite2D = $Torso/Torso
@onready var head: Sprite2D = $Head/Head
@onready var right_arm: Sprite2D = $Arms/RightArm
@onready var left_arm: Sprite2D = $Arms/LeftArm
@onready var arms: Node2D = $Arms

@onready var right_leg: Sprite2D = $RLeg/RightLeg
@onready var left_leg: Sprite2D = $LLeg/LeftLeg

var NODES = []

func _ready() -> void:
	NODES = [torso, right_arm, right_leg, left_arm, left_leg, head]
	for i in NODES:
			i.texture = BodyIcon

func HeadFollow(delta):
	if System.MainCursor.x >= global_position.x:
		head.scale = lerp(head.scale, Vector2(1, 1), Accel * delta)
	else :
		head.scale = lerp(head.scale, Vector2(1, -1), Accel * delta)
	head.look_at(System.MainCursor)

func FollowCustomCursor():
	if System.Device == "PC":
		System.MainCursor = get_global_mouse_position()
	else :
		if System.CursorPos == Vector2.ZERO:
			$Cursor.position = System.CursorPos + Vector2(System.CursorPos.x + System.LastLookDir * 55, 0)
			System.MainCursor = $Cursor.global_position
		else :
			$Cursor.position = System.CursorPos + Vector2(System.CursorPos.x, 0)
			System.MainCursor = $Cursor.global_position
	if Input.is_action_just_pressed("JoyLeft"):
		System.LastLookDir = -1
	if Input.is_action_just_pressed("JoyRight"):
		System.LastLookDir = 1

func _physics_process(delta: float) -> void:
	FollowCustomCursor()
	HeadFollow(delta)
	if Inventory.IsEquipped:
		ArmsFollow(delta)
	else :
		arms.rotation = 0
		arms.scale = lerp(arms.scale, Vector2(1, 1), Accel * delta)

func ArmsFollow(delta):
	if System.MainCursor.x >= global_position.x:
		arms.scale = lerp(arms.scale, Vector2(1, 1), Accel * delta)
	else :
		arms.scale = lerp(arms.scale, Vector2(1, -1), Accel * delta)
	arms.look_at(System.MainCursor)
