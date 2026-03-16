extends Node2D

@onready var Main: CharacterBody2D = $"../../../.."
@onready var sword: TextureRect = $Sword
@onready var gun: TextureRect = $Gun
@onready var barrel: Marker2D = $Gun/Barrel
@onready var HandAnim: AnimationPlayer = $"../../../HandAnim"

var CurrentSlot := {}

var Reloading := false

func _physics_process(delta: float) -> void:
	if Main.Decision == "Reload":
		Reload()

	if Main.Decision == "DropAmmo" and !CurrentSlot.is_empty():
		DropAmmo()
	
	if Main.InRange and !CurrentSlot.is_empty():
		Equipped()
	else :
		sword.visible = false
		gun.visible = false
		HandAnim.play("Hand/RESET")

func Shoot(GunData : Dictionary):
	if CurrentSlot["CurrentMag"] >= 1 and !Reloading:
		var Bullet = preload("res://Game/Assets/Scenes/Bullet/bullet.tscn").instantiate()
		Bullet.GunData = GunData
		get_tree().root.add_child(Bullet)
		Bullet.global_position = barrel.global_position
		Bullet.rotation = barrel.global_rotation
		
		CurrentSlot["CurrentMag"] -= 1
	else :
		if !Reloading:
			Reloading = true
			HandAnim.play("Hand/Reload")

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
		#print("No Ammo")
		pass
	Reloading = false

func DropAmmo():
	if CurrentSlot["Type"] == "Gun" and CurrentSlot["MagSize"] >= 10:
		var DroppedItem = preload("res://Game/Assets/Scenes/Item/item.tscn").instantiate()
		DroppedItem.ItemData = WeaponIndex.GetItem("Ammo")
		var SetAmmo : int = User.UserDropPercentage * CurrentSlot["MagSize"]
		DroppedItem.ItemData["SetAmmo"] = SetAmmo
		CurrentSlot["MagSize"] -= SetAmmo
		DroppedItem.global_position = global_position
		DroppedItem.Move = true
		randomize()
		var MinMove := 100
		var MaxMove := 250
		DroppedItem.MoveToPos = Vector2(
			global_position.x + clamp(randf_range(-MaxMove, MaxMove), -MinMove, MinMove)
			,global_position.y + clamp(randf_range(-MaxMove, MaxMove), -MinMove, MinMove)
		)
		get_tree().current_scene.get_node("World/Enviroment").add_child(DroppedItem)

func Equipped():
	if CurrentSlot["Type"] == "Sword":
		sword.visible = true
		gun.visible = false
		sword.scale = Vector2(CurrentSlot["Scale"], CurrentSlot["Scale"])
		sword.texture = CurrentSlot["Icon"]
		if Main.Decision == "Attack":
			HandAnim.play("Hand/Attack", -1, CurrentSlot["AttackSpeed"])
		else :
			HandAnim.play("Hand/HoldSword")

	if CurrentSlot["Type"] == "Gun":
		sword.visible = false
		gun.visible = true
		gun.scale = Vector2(CurrentSlot["Scale"], CurrentSlot["Scale"])
		gun.texture = CurrentSlot["Icon"]
		if Input.is_action_pressed("Attack"):
			HandAnim.play("Hand/Shoot", -1, CurrentSlot["AttackSpeed"])
		else :
			HandAnim.play("Hand/HoldGun")

func _on_hand_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Hand/Shoot":
		Shoot(CurrentSlot)

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Entity"):
		body.get_parent().Health -= CurrentSlot["Damage"]
