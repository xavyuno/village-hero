extends Node2D

@onready var Main: CharacterBody2D = $"../../../.."
@onready var sword: TextureRect = $Sword
@onready var gun: TextureRect = $Gun
@onready var barrel: Marker2D = $Gun/Barrel
@onready var HandAnim: AnimationPlayer = $"../../../HandAnim"

var CurrentSlot := {}

var Reloading := false

func _ready() -> void:
	if Main.Slot1 != null:
		sword.texture = Main.Slot1
	if Main.Slot2 != null:
		gun.texture = Main.Slot2

func _physics_process(delta: float) -> void:
	if Main.InRange:
		Equipped()
	else :
		sword.visible = false
		gun.visible = false
		HandAnim.play("Hand/RESET")

func Shoot(GunData : Dictionary):
	if CurrentSlot["CurrentMag"] >= 1 and !Reloading:
		var Bullet = preload("res://Game/Assets/Scenes/Bullet/bullet.tscn").instantiate()
		Bullet.GunData = GunData
		Bullet.ParentName = "Enemy"
		get_tree().root.add_child(Bullet)
		Bullet.global_position = barrel.global_position
		Bullet.rotation = barrel.global_rotation
		
		CurrentSlot["CurrentMag"] -= 1

func Reload():
	if CurrentSlot["MagSize"] >= 1 and CurrentSlot["CurrentMag"] < CurrentSlot["MaxMag"]:
		if CurrentSlot["MagSize"] >= CurrentSlot["MaxMag"]:
			var AmmoAdd : int = CurrentSlot["MaxMag"] - CurrentSlot["CurrentMag"]
			CurrentSlot["CurrentMag"] += AmmoAdd
			CurrentSlot["MagSize"] -= AmmoAdd
		else :
			for i in CurrentSlot["MagSize"]:
				CurrentSlot["CurrentMag"] += 1
				CurrentSlot["MagSize"] -= 1
	else :
		Main.Slot2["CurrentMag"] = 0
		Main.Slot2["MagSize"] = 0
	Reloading = false

func Equipped():
	if Main.Decision == "Shooting":
		if CurrentSlot.is_empty():
			CurrentSlot = Main.Slot2.GetData()
	else :
		CurrentSlot = Main.Slot1.GetData()

	if CurrentSlot["Type"] == "Sword":
		sword.visible = true
		gun.visible = false
		sword.scale = Vector2(CurrentSlot["Scale"], CurrentSlot["Scale"])
		sword.texture = CurrentSlot["Icon"]
		if Main.Decision == "Attacking" and global_position.distance_to(User.PlayerPosition) <= 20:
			if User.Difficulty == 2:
				await get_tree().create_timer(1).timeout
			if User.Difficulty == 3:
				await get_tree().create_timer(2).timeout
			HandAnim.play("Hand/Attack", -1, CurrentSlot["AttackSpeed"])
		else :
			HandAnim.play("Hand/HoldSword")

	if CurrentSlot["Type"] == "Gun":
		sword.visible = false
		gun.visible = true
		gun.scale = Vector2(CurrentSlot["Scale"], CurrentSlot["Scale"])
		gun.texture = CurrentSlot["Icon"]
		if Main.Decision == "Shooting" and !Reloading:
			if CurrentSlot["CurrentMag"] >= 1:
				if User.Difficulty == 2:
					await get_tree().create_timer(1).timeout
				if User.Difficulty == 3:
					await get_tree().create_timer(2).timeout
				HandAnim.play("Hand/Shoot", -1, CurrentSlot["AttackSpeed"])
			else :
				if !Reloading:
					Reloading = true
					Reload()
			
		else :
			HandAnim.play("Hand/HoldGun")
	

func _on_hand_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Hand/Shoot":
		Shoot(CurrentSlot)


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Entity"):
		body.get_parent().Health -= CurrentSlot["Damage"]
