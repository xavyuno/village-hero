extends CharacterBody2D

@onready var BodyAnim: AnimationPlayer = $Body/BodyAnim
@onready var HandAnim: AnimationPlayer = $Body/HandAnim
@onready var health: Label = $Health
@onready var ai_timer: Timer = $AITimer

@export var BodyIcon : Texture
@export var Slot1 : Sword
@export var Slot2 : Gun
@export var AmourData : Amour

@export var RewardList : Array[Resource]

var Accel := 8.5

var Speed := 120.0
var NormalSpeed := 150.0

var Health := 100
var Protection := 0

var InitialHealth := 0
var InitialProtection := 0

var InRange := false
var FollowingPlayer := false
var FollowingFootprints := false
var FootprintPos := Vector2.ZERO
var FollowPrevPrint := false
var Sprinting := false

var Decision := ""

var CustomPos : Vector2
var Dir := 1

var Died := false

func DropLoot():
	if RewardList.size() >= 1:
		for i in RewardList:
			var DroppedItem = preload("res://Game/Assets/Scenes/Item/item.tscn").instantiate()
			DroppedItem.ItemData = i.GetData()
			DroppedItem.global_position = global_position
			DroppedItem.Move = true
			randomize()
			var MinMove := 50
			var MaxMove := 200
			DroppedItem.MoveToPos = Vector2(
				global_position.x + clamp(randf_range(-MaxMove, MaxMove), -MinMove, MinMove)
				,global_position.y + clamp(randf_range(-MaxMove, MaxMove), -MinMove, MinMove)
			)
			get_tree().current_scene.get_node("World/Enviroment").add_child(DroppedItem)
	User.Exp += (InitialHealth + InitialProtection) * (.3 * User.Difficulty)
	queue_free()

func _ready() -> void:
	InitialHealth = Health
	InitialProtection = Protection
	randomize()
	match User.Difficulty:
		1:
			$Body.ReactionAccel = 5
			var Set := 50
			$Body.LookPos = Vector2(randf_range(-Set, Set), randf_range(-Set, Set))
		2:
			$Body.ReactionAccel = 10
			var Set := 25
			$Body.LookPos = Vector2(randf_range(-Set, Set), randf_range(-Set, Set))
		3:
			$Body.ReactionAccel = 15
			$Body.LookPos = Vector2.ZERO
	CustomPos = Vector2(randf_range(global_position.x - 150, global_position.x + 150),
	randf_range(global_position.y - 150, global_position.y + 150))
	if CustomPos.x > global_position.x:
		Dir = 1
	else :
		Dir = -1
	ai_timer.wait_time = randf_range(10, 25)
	ai_timer.start()

func AISystem():
	if InRange:
		if Slot2 != null:
			if Slot2["MagSize"] <= 0 and Slot2["CurrentMag"] <= 0:
				FollowingPlayer = true
				Decision = "Attacking"
			else :
				FollowingPlayer = false
				Decision = "Shooting"
		else :
			FollowingPlayer = true
			Decision = "Attacking"
	else :
		FollowingPlayer = false

func GetInputVel():
	var motion := Vector2.ZERO
	if InRange and global_position.distance_to(User.PlayerPosition) <= 350 and !FollowingPlayer  and User.Difficulty >= 3:
		motion += (global_position - User.PlayerPosition)
	if InRange and FollowingPlayer or global_position.distance_to(User.PlayerPosition) >= 400 and User.Difficulty >= 2:
		motion += (User.PlayerPosition - global_position)
	if global_position.distance_to(CustomPos) > 1.5 and !InRange and !FollowingFootprints:
		motion += (CustomPos - global_position)
	if FollowingFootprints and User.Difficulty >= 2:
		motion += (FootprintPos - global_position)
	return motion.normalized() * Speed

func Anim():
	if velocity.x > 10 or velocity.x < -10:
		BodyAnim.play("Walking", 1, Speed / NormalSpeed)
	else :
		BodyAnim.play("Idle", 1)

func Movement(delta: float):
	velocity.x = lerp(velocity.x, GetInputVel().x, delta * Accel)
	velocity.y = lerp(velocity.y, GetInputVel().y, delta * Accel)
	move_and_slide()

func HealthSystem():
	health.text = "Hp: " + str(Health)
	if Health <= 0 and !Died:
		Died = true
		DropLoot()

func _physics_process(delta: float) -> void:
	AISystem()
	HealthSystem()
	Movement(delta)
	Anim()

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Bullet"):
		if body.ParentName != "Enemy":
			Health -= clamp(body.GunData["Damage"] - Protection, 0, 100000)
			body.queue_free()
	if body.is_in_group("Sword"):
		Health -= clamp(Inventory.EquippedItem["Damage"] - Protection, 0, 100000)

func _on_radius_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		InRange = true
		FollowingFootprints = false
	if body.is_in_group("Footprint") and User.Difficulty >= 2:
		if !InRange:
			FollowPrevPrint = true
			FootprintPos = body.global_position
			FollowingFootprints = true

func _on_radius_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		InRange = false
		FollowingFootprints = true
	if body.is_in_group("Footprint") and User.Difficulty >= 2:
		FollowingFootprints = false
		CustomPos = Vector2(randf_range(FootprintPos.x - 150, FootprintPos.x + 150),
		randf_range(FootprintPos.y - 150, FootprintPos.y + 150))

func _on_ai_timer_timeout() -> void:
	match User.Difficulty:
		1:
			$Body.ReactionAccel = 5
			var Set := 250
			$Body.LookPos = Vector2(randf_range(-Set, Set), randf_range(-Set, Set))
		2:
			$Body.ReactionAccel = 10
			var Set := 100
			$Body.LookPos = Vector2(randf_range(-Set, Set), randf_range(-Set, Set))
		3:
			$Body.ReactionAccel = 15
			$Body.LookPos = Vector2.ZERO
	randomize()
	ai_timer.wait_time = randf_range(10, 25)
	ai_timer.start()
	if FootprintPos != Vector2.ZERO and FollowPrevPrint  and User.Difficulty >= 3:
		FollowPrevPrint = false
		CustomPos = Vector2(randf_range(FootprintPos.x - 150, FootprintPos.x + 150),
		randf_range(FootprintPos.y - 150, FootprintPos.y + 150))
	else :
		CustomPos = Vector2(randf_range(global_position.x - 150, global_position.x + 150),
		randf_range(global_position.y - 150, global_position.y + 150))
	if CustomPos.x > global_position.x:
		Dir = 1
	else :
		Dir = -1
