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


func _ready() -> void:
	for i in get_children():
		if i is Node2D:
			if i.name == "Arms":
				i.get_child(1).texture = BodyIcon
			i.get_child(0).texture = BodyIcon

func HeadFollow(delta):
	if get_global_mouse_position().x >= global_position.x:
		head.scale = lerp(head.scale, Vector2(1, 1), Accel * delta)
	else :
		head.scale = lerp(head.scale, Vector2(1, -1), Accel * delta)
	head.look_at(get_global_mouse_position())

func _physics_process(delta: float) -> void:
	HeadFollow(delta)
	if Inventory.IsEquipped:
		ArmsFollow(delta)

func Point(delta):
	if get_global_mouse_position().x >= global_position.x:
		right_arm.scale = lerp(right_arm.scale, Vector2(1, 1), Accel * delta)
	else :
		right_arm.scale = lerp(arms.scale, Vector2(1, -1), Accel * delta)
	right_arm.look_at(get_global_mouse_position())

func ArmsFollow(delta):
	if get_global_mouse_position().x >= global_position.x:
		arms.scale = lerp(arms.scale, Vector2(1, 1), Accel * delta)
	else :
		arms.scale = lerp(arms.scale, Vector2(1, -1), Accel * delta)
	arms.look_at(get_global_mouse_position())
