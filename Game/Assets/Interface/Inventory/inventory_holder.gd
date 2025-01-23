extends Control

@onready var Holder: HFlowContainer = $ScrollContainer/Holder

func _physics_process(delta: float) -> void:
	if Inventory.RefreshInv:
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
	Inventory.RefreshInv = false
