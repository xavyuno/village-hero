extends Node2D

var Accel := 8.5

@export var BodyIcon : Texture

@onready var torso: Sprite2D = $Torso/Torso
@onready var head: Sprite2D = $Head/Head
@onready var right_arm: Sprite2D = $Arms/RightArm
@onready var left_arm: Sprite2D = $Arms/LeftArm
@onready var arms: Node2D = $Arms

@onready var torso_2: Sprite2D = $Torso/Torso2
@onready var right_leg_2: Sprite2D = $RLeg/RightLeg2
@onready var left_leg_2: Sprite2D = $LLeg/LeftLeg2
@onready var right_arm_2: Sprite2D = $Arms/RightArm/RightArm2
@onready var left_arm_2: Sprite2D = $Arms/LeftArm/LeftArm2
@onready var head_2: Sprite2D = $Head/Head2


@onready var right_leg: Sprite2D = $RLeg/RightLeg
@onready var left_leg: Sprite2D = $LLeg/LeftLeg

var BodyNodes = []
var AmourNodes = []

func _ready() -> void:
	RefreshCharacter()

func RefreshCharacter():
	BodyNodes = [torso, right_arm, right_leg, left_arm, left_leg, head]
	AmourNodes = [torso_2, right_arm_2, right_leg_2, left_arm_2, left_leg_2, head_2]
	for i in BodyNodes:
		i.texture = User.Character
	if !Inventory.AmourEquipped.is_empty():
		for i in AmourNodes:
			i.texture = Inventory.AmourEquipped["Icon"]
		User.Protection = Inventory.AmourEquipped["Protection"]
	else :
		User.Protection = 0
		for i in AmourNodes:
			i.texture = null

func HeadFollow(delta):
	if System.MainCursor.x >= global_position.x:
		head.scale = lerp(head.scale, Vector2(1, 1), Accel * delta)
	else :
		head.scale = lerp(head.scale, Vector2(1, -1), Accel * delta)
	head.look_at(System.MainCursor)
	if System.MainCursor.x >= global_position.x:
		head_2.scale = lerp(head_2.scale, Vector2(1, 1), Accel * delta)
	else :
		head_2.scale = lerp(head_2.scale, Vector2(1, -1), Accel * delta)
	head_2.look_at(System.MainCursor)

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
	if Inventory.AmourChanged:
		Inventory.AmourChanged = false
		RefreshCharacter()
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
