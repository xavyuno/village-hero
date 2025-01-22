extends Node2D

@export var BodyIcon : Texture

@onready var head: Sprite2D = $Head
@onready var torso: Sprite2D = $Torso
@onready var left_leg: Sprite2D = $LeftLeg
@onready var right_leg: Sprite2D = $RightLeg
@onready var left_arm: Sprite2D = $LeftArm
@onready var right_arm: Sprite2D = $RightArm


func _ready() -> void:
	for i in get_children():
		i.texture = BodyIcon

func _physics_process(delta: float) -> void:
	if get_global_mouse_position().x >= global_position.x:
		head.scale = Vector2(1, 1)
	else :
		head.scale = Vector2(1, -1)
	head.look_at(get_global_mouse_position())
