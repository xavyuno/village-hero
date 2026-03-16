extends Node2D

@onready var Main: CharacterBody2D = get_parent()

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
var Accel := 8.5

var CustomPos : Vector2

func _ready() -> void:
	RefreshCharacter()

func RefreshCharacter():
	BodyNodes = [torso, right_arm, right_leg, left_arm, left_leg, head]
	AmourNodes = [torso_2, right_arm_2, right_leg_2, left_arm_2, left_leg_2, head_2]
	for i in BodyNodes:
		i.texture = Main.BodyIcon
	if Main.AmourData != null:
		for i in AmourNodes:
			i.texture = Main.AmourData["Icon"]
		Main.Protection = Main.AmourData["Protection"]
	else :
		Main.Protection = 0
		for i in AmourNodes:
			i.texture = null

func HeadFollow(delta):
	if User.PlayerPosition.x >= global_position.x:
		head.scale = lerp(head.scale, Vector2(1, 1), Accel * delta)
	else :
		head.scale = lerp(head.scale, Vector2(1, -1), Accel * delta)
	head.look_at(User.PlayerPosition)
	if User.PlayerPosition.x >= global_position.x:
		head_2.scale = lerp(head_2.scale, Vector2(1, 1), Accel * delta)
	else :
		head_2.scale = lerp(head_2.scale, Vector2(1, -1), Accel * delta)
	head_2.look_at(User.PlayerPosition)

func _physics_process(delta: float) -> void:
	HeadFollow(delta)
	if Main.InRange:
		ArmsFollow(delta)
	else :
		arms.rotation = 0
		arms.scale = lerp(arms.scale, Vector2(1, 1), Accel * delta)

func ArmsFollow(delta):
	if User.PlayerPosition.x >= global_position.x:
		arms.scale = lerp(arms.scale, Vector2(1, 1), Accel * delta)
	else :
		arms.scale = lerp(arms.scale, Vector2(1, -1), Accel * delta)
	arms.look_at(User.PlayerPosition)
