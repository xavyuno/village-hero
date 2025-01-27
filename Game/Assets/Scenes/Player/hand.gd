extends Node2D

@onready var sword: Sprite2D = $Sword
@onready var gun: Sprite2D = $Gun
@onready var item: Sprite2D = $Item

@onready var barrel: Marker2D = $Gun/Barrel

@onready var HandAnim: AnimationPlayer = $"../../../HandAnim"

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("PrimaryWeapon"):
		Inventory.SwitchWeapons(1)
	if Input.is_action_just_pressed("SecondaryWeapon"):
		Inventory.SwitchWeapons(2)
	
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
	var Bullet = preload("res://Game/Assets/Scenes/Bullet/bullet.tscn").instantiate()
	Bullet.GunData = GunData
	get_tree().root.add_child(Bullet)
	Bullet.global_position = barrel.global_position
	Bullet.rotation = barrel.global_rotation

func Reload():
	pass

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
	Inventory.RemoveWeapon(Inventory.EquippedItem["Name"])
	Inventory.UnEquip()

func Equipped():
	if Inventory.EquippedItem["Type"] == "Item":
		sword.visible = false
		gun.visible = false
		item.visible = true
		item.texture = Inventory.EquippedItem["Icon"]
		HandAnim.play("HoldItem")

	elif Inventory.EquippedItem["Type"] == "Sword":
		sword.visible = true
		gun.visible = false
		item.visible = false
		sword.texture = Inventory.EquippedItem["Icon"]
		if Input.is_action_pressed("Attack"):
			HandAnim.play("Attack", -1, Inventory.EquippedItem["AttackSpeed"])
		else :
			HandAnim.play("HoldSword")

	elif Inventory.EquippedItem["Type"] == "Gun":
		sword.visible = false
		gun.visible = true
		item.visible = false
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
