extends CharacterBody2D

@onready var BodyAnim: AnimationPlayer = $Body/BodyAnim
@onready var HandAnim: AnimationPlayer = $Body/HandAnim
@onready var health: Label = $Health
@onready var ai_timer: Timer = $AITimer

@export var BodyIcon : Texture
@export var Slot1 : Sword
@export var Slot2 : Gun
@export var AmourData : Amour

@export var DifficultyRate := 1.0
@export_enum("Easy", "Medium", "Hard", "Hard+") var AI

var Accel := 8.5

var Speed := 150.0
var NormalSpeed := 150.0
var SprintSpeed := 200.0

var Health := 100
var Protection := 0

var InRange := false
var FollowingPlayer := false
var Sprinting := false

var State := ""
var Decision := ""

var CustomPos : Vector2

func _ready() -> void:
	randomize()
	CustomPos = Vector2(randf_range(global_position.x - 150, global_position.x + 150),
	randf_range(global_position.y - 150, global_position.y + 150))
	ai_timer.wait_time = randf_range(10, 25)
	ai_timer.start()

func AISystem():
	if InRange:
		if Slot2["MagSize"] <= 0 and Slot2["CurrentMag"] <= 0:
			FollowingPlayer = true
		else :
			FollowingPlayer = false
	else :
		FollowingPlayer = false

func GetInputVel():
	var motion := Vector2.ZERO
	if InRange and global_position.distance_to(User.PlayerPosition) <= 1050:
		motion += (global_position - User.PlayerPosition)
	if global_position.distance_to(CustomPos) > 1.5:
		motion += (CustomPos - global_position)
	return motion.normalized() * Speed

func Sprint():
	if Sprinting:
		Speed = SprintSpeed
	else :
		Speed = NormalSpeed

func Anim():
	if velocity > Vector2(1, 1) or velocity < Vector2(-1, -1):
		BodyAnim.play("Walking", 1, Speed / NormalSpeed)
	else :
		BodyAnim.play("Idle", 1)

func Movement(delta: float):
	velocity.x = lerp(velocity.x, GetInputVel().x, delta * Accel)
	velocity.y = lerp(velocity.y, GetInputVel().y, delta * Accel)
	move_and_slide()

func HealthSystem():
	health.text = "Hp: " + str(Health)
	if Health <= 0:
		queue_free()

func _physics_process(delta: float) -> void:
	AISystem()
	HealthSystem()
	Sprint()
	Movement(delta)
	Anim()

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Bullet"):
		Health -= clamp(body.GunData["Damage"] - Protection, 0, 1000000000000000000000000000000000000000000)
	if body.is_in_group("Sword"):
		Health -= clamp(Inventory.EquippedItem["Damage"] - Protection, 0, 100000000000000000000000000000000)

func _on_radius_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		InRange = false

func _on_radius_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		InRange = false

func _on_ai_timer_timeout() -> void:
	randomize()
	ai_timer.wait_time = randf_range(10, 25)
	ai_timer.start()
	CustomPos = Vector2(randf_range(global_position.x - 150, global_position.x + 150),
	randf_range(global_position.y - 150, global_position.y + 150))
