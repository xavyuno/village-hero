extends Area2D

@onready var icon: TextureRect = $Icon
@onready var gun_shadow: Sprite2D = $GunShadow
@onready var sword_shadow: Sprite2D = $SwordShadow

@export var PreData : Resource

var ItemData := {}

func _ready() -> void:
	if PreData != null:
		ItemData = PreData.GetData()
	icon.texture = ItemData["Icon"]
	gun_shadow.texture = ItemData["Icon"]
	sword_shadow.texture = ItemData["Icon"]
	if ItemData["Type"] == "Gun":
		sword_shadow.visible = false
	if ItemData["Type"] == "Sword":
		gun_shadow.visible = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and Inventory.SlotsUsed < Inventory.MaxSlots:
		match ItemData["Type"]:
			"Gun":
				Inventory.AddWeapon(ItemData)
				queue_free()
			"Sword":
				Inventory.AddWeapon(ItemData)
				queue_free()
			"Item":
				Inventory.AddItem(ItemData["Name"])
				queue_free()


func _on_timer_timeout() -> void:
	$Collision.disabled = false
