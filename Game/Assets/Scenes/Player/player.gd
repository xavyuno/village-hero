extends CharacterBody2D

@onready var BodyAnim: AnimationPlayer = $Body/BodyAnim
@onready var HandAnim: AnimationPlayer = $Body/HandAnim

var Speed := 150.0
var NormalSpeed := 150.0
var SprintSpeed := 200.0
var Accel := 8.5

func GetInputVel():
	var motion : Vector2
	motion.x = Input.get_axis("Left", "Right")
	motion.y = Input.get_axis("Up", "Down")
	return motion.normalized() * Speed

func Sprint():
	if Input.is_action_pressed("Sprint"):
		Speed = SprintSpeed
	if Input.is_action_just_released("Sprint"):
		Speed = NormalSpeed

func Anim():
	if GetInputVel() != Vector2.ZERO:
		BodyAnim.play("Walking", 1, Speed / 150)
	else :
		BodyAnim.play("Idle", 1)

func Movement(delta: float):
	velocity.x = lerp(velocity.x, GetInputVel().x, delta * Accel)
	velocity.y = lerp(velocity.y, GetInputVel().y, delta * Accel)
	
	move_and_slide()

func _physics_process(delta: float) -> void:
	Sprint()
	Movement(delta)
	Anim()
