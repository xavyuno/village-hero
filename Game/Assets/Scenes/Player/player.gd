extends CharacterBody2D

@onready var BodyAnim: AnimationPlayer = $Body/BodyAnim
@onready var HandAnim: AnimationPlayer = $Body/HandAnim
@onready var regenerate: Timer = $Regenerate

var Speed := 150.0
var NormalSpeed := 150.0
var SprintSpeed := 200.0
var Accel := 8.5

func _ready() -> void:
	regenerate.wait_time = User.RegenSpeed
	regenerate.start()

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
	User.PlayerPosition = global_position
	move_and_slide()

func _physics_process(delta: float) -> void:
	Sprint()
	Movement(delta)
	Anim()


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Bullet"):
		if body.ParentName != "Player":
			User.DamageTaken(body.GunData["Damage"])
			body.queue_free()
	if body.is_in_group("Sword"):
		User.DamageTaken(body.get_parent().get_parent().Main.Slot1["Damage"])


func _on_foottimer_timeout() -> void:
	if velocity != Vector2.ZERO:
		var Footprint = preload("res://Game/Assets/Scenes/Footprints/foot_prints.tscn").instantiate()
		Footprint.global_position = $Foot.global_position
		System.AddNode(Footprint)

func _on_regenerate_timeout() -> void:
	regenerate.wait_time = User.RegenSpeed
	User.Health += User.RegenAmount
	User.Protection += User.RegenAmount
	regenerate.start()
