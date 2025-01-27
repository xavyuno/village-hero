extends Control

@onready var Holder: HFlowContainer = $ScrollContainer/Holder

var Refreshing := false

func _physics_process(delta: float) -> void:
	if Inventory.RefreshInv and !Refreshing:
		Refreshing = true
		RefreshInv()

func AddSlots():
	for i in Inventory.Data.values():
		var Slot = preload("res://Game/Assets/Interface/Inventory/slot.tscn").instantiate()
		Slot.ItemName = i["Name"]
		Holder.add_child(Slot)

func RefreshInv():
	for i in Holder.get_children():
		i.queue_free()
	AddSlots()
	await get_tree().create_timer(0.1, true, true).timeout
	Inventory.RefreshInv = false
	Refreshing = false
