extends Node2D

@onready var sword: TextureRect = $Sword
@onready var gun: TextureRect = $Gun
@onready var item: TextureRect = $Item

@onready var barrel: Marker2D = $Gun/Barrel

@onready var HandAnim: AnimationPlayer = $"../../../HandAnim"

var Reloading := false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Slot1"):
		Inventory.SwitchItems(1)
	if Input.is_action_just_pressed("Slot2"):
		Inventory.SwitchItems(2)
	if Input.is_action_just_pressed("Slot3"):
		Inventory.SwitchItems(3)
	if Input.is_action_just_pressed("Slot4"):
		Inventory.SwitchItems(4)
	if Input.is_action_just_pressed("Slot5"):
		Inventory.SwitchItems(5)
	if Input.is_action_just_pressed("NextItem"):
		Inventory.ChangedSlot += 1
		if Inventory.ChangedSlot > 5:
			Inventory.ChangedSlot = 1
		Inventory.SwitchItems(Inventory.ChangedSlot)
	if Input.is_action_just_pressed("PreviousItem"):
		Inventory.ChangedSlot -= 1
		if Inventory.ChangedSlot < 1:
			Inventory.ChangedSlot = 5
		Inventory.SwitchItems(Inventory.ChangedSlot)

	if Input.is_action_just_pressed("Reload"):
		Reload()

	if Input.is_action_just_pressed("DropAmmo") and !Inventory.EquippedItem.is_empty():
		DropAmmo()

	if Input.is_action_just_pressed("Drop") and !Inventory.EquippedItem.is_empty():
		Drop()
	
	if Inventory.IsEquipped and !Inventory.EquippedItem.is_empty():
		Equipped()
	else :
		sword.visible = false
		gun.visible = false
		item.visible = false
		HandAnim.play("RESET")

func Shoot(GunData : Dictionary):
	if Inventory.EquippedItem["CurrentMag"] >= 1 and !Reloading:
		var Bullet = preload("res://Game/Assets/Scenes/Bullet/bullet.tscn").instantiate()
		Bullet.GunData = GunData
		get_tree().root.add_child(Bullet)
		Bullet.global_position = barrel.global_position
		Bullet.rotation = barrel.global_rotation
		
		Inventory.EquippedItem["CurrentMag"] -= 1
	else :
		if !Reloading:
			Reload()

func Reload():
	Reloading = true
	if Inventory.EquippedItem["MagSize"] >= 1 and Inventory.EquippedItem["CurrentMag"] < Inventory.EquippedItem["MaxMag"]:
		if Inventory.EquippedItem["MagSize"] >= Inventory.EquippedItem["MaxMag"]:
			var AmmoAdd : int = Inventory.EquippedItem["MaxMag"] - Inventory.EquippedItem["CurrentMag"]
			Inventory.EquippedItem["CurrentMag"] += AmmoAdd
			Inventory.EquippedItem["MagSize"] -= AmmoAdd
		else :
			for i in Inventory.EquippedItem["MagSize"]:
				Inventory.EquippedItem["CurrentMag"] += 1
				Inventory.EquippedItem["MagSize"] -= 1
	else :
		print("No Ammo")
	Reloading = false

func DropAmmo():
	if Inventory.EquippedItem["Type"] == "Gun" and Inventory.EquippedItem["MagSize"] >= 10:
		var DroppedItem = preload("res://Game/Assets/Scenes/Item/item.tscn").instantiate()
		DroppedItem.ItemData = WeaponIndex.GetItem("Ammo")
		var SetAmmo : int = User.UserDropPercentage * Inventory.EquippedItem["MagSize"]
		DroppedItem.ItemData["SetAmmo"] = SetAmmo
		Inventory.EquippedItem["MagSize"] -= SetAmmo
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

func Drop():
	var DroppedItem = preload("res://Game/Assets/Scenes/Item/item.tscn").instantiate()
	DroppedItem.ItemData = Inventory.EquippedItem
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
	if Inventory.EquippedItem["IsWeapon"]:
		Inventory.RemoveItem(Inventory.EquippedItem["Name"])
		Inventory.UnEquip()
	else :
		if Inventory.RemoveItem(Inventory.EquippedItem["Name"]) <= 0:
			Inventory.UnEquip()

func Equipped():
	if Inventory.EquippedItem["Type"] == "Item":
		sword.visible = false
		gun.visible = false
		item.visible = true
		item.scale = Vector2(Inventory.EquippedItem["Scale"], Inventory.EquippedItem["Scale"])
		item.texture = Inventory.EquippedItem["Icon"]
		HandAnim.play("HoldItem")
		if Input.is_action_just_pressed("Attack"):
			ItemUsage.call(Inventory.EquippedItem["Name"])
			if Inventory.RemoveItem(Inventory.EquippedItem["Name"]) <= 0:
				Inventory.UnEquip()

	elif Inventory.EquippedItem["Type"] == "Sword":
		sword.visible = true
		gun.visible = false
		item.visible = false
		sword.scale = Vector2(Inventory.EquippedItem["Scale"], Inventory.EquippedItem["Scale"])
		sword.texture = Inventory.EquippedItem["Icon"]
		if Input.is_action_pressed("Attack"):
			HandAnim.play("Attack", -1, Inventory.EquippedItem["AttackSpeed"])
		else :
			HandAnim.play("HoldSword")

	elif Inventory.EquippedItem["Type"] == "Gun":
		sword.visible = false
		gun.visible = true
		item.visible = false
		gun.scale = Vector2(Inventory.EquippedItem["Scale"], Inventory.EquippedItem["Scale"])
		gun.texture = Inventory.EquippedItem["Icon"]
		if Input.is_action_pressed("Attack"):
			HandAnim.play("Shoot", -1, Inventory.EquippedItem["AttackSpeed"])
		else :
			HandAnim.play("HoldGun")

	else :
		print("No Identifier for the current equipped item")


func _on_hand_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Shoot":
		Shoot(Inventory.EquippedItem)


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Entity"):
		body.get_parent().Health -= Inventory.EquippedItem["Damage"]
