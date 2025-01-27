extends Area2D

@onready var icon: TextureRect = $Icon
@onready var gun_shadow: Sprite2D = $Icon/GunShadow
@onready var sword_shadow: Sprite2D = $Icon/SwordShadow

@export var PreData : Resource
@export var Move := false

var ItemData := {}
var MoveToPos := Vector2.ZERO
var FollowPlayer := false

func _physics_process(delta: float) -> void:
	if FollowPlayer and !Move:
		global_position += (User.PlayerPosition - global_position) / 50
	if Move:
		global_position += (MoveToPos - global_position) / 50
	if global_position.distance_to(MoveToPos) <= 0.5:
		Move = false

func _ready() -> void:
	if PreData != null:
		ItemData = PreData.GetData()
	icon.texture = ItemData["Icon"]
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


func _on_radius_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		FollowPlayer = true

func _on_radius_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		FollowPlayer = false
