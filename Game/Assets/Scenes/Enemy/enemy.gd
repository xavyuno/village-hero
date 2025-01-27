extends Node2D

var Accel := 8.5

@export var BodyIcon : Texture
@onready var body_anim: AnimationPlayer = $Body/BodyAnim
@onready var hand_anim: AnimationPlayer = $Body/HandAnim

@onready var torso: Sprite2D = $Body/Torso/Torso
@onready var right_leg: Sprite2D = $Body/RLeg/RightLeg
@onready var left_leg: Sprite2D = $Body/LLeg/LeftLeg
@onready var right_arm: Sprite2D = $Body/Arms/RightArm
@onready var left_arm: Sprite2D = $Body/Arms/LeftArm
@onready var head: Sprite2D = $Body/Head/Head
@onready var arms: Node2D = $Body/Arms
@onready var NODES = []

var Health := 100

func _ready() -> void:
	NODES = [torso, head, right_arm, left_arm, right_leg, left_leg]
	for i in NODES:
			i.texture = BodyIcon

func HealthSystem():
	$Health.text = str(Health)
	if Health <= 0:
		queue_free()

func FollowPlayer():
	position += (User.PlayerPosition - position) / 250
	body_anim.play("Walking", 1, 150 / 150)

func HeadFollow(delta):
	if User.PlayerPosition.x >= global_position.x:
		head.scale = lerp(head.scale, Vector2(1, 1), Accel * delta)
	else :
		head.scale = lerp(head.scale, Vector2(1, -1), Accel * delta)
	head.look_at(User.PlayerPosition)

func _physics_process(delta: float) -> void:
	HeadFollow(delta)
	HealthSystem()
	FollowPlayer()

func ArmsFollow(delta):
	if User.PlayerPosition.x >= global_position.x:
		arms.scale = lerp(arms.scale, Vector2(1, 1), Accel * delta)
	else :
		arms.scale = lerp(arms.scale, Vector2(1, -1), Accel * delta)
	arms.look_at(User.PlayerPosition)

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Bullet"):
		Health -= body.GunData["Damage"]
