extends Button

@onready var Icon: TextureRect = $Icon
@onready var highlight: TextureRect = $Highlight
@onready var character: Control = get_parent()

@export var Slot := 1

var ItemData : = {}

func Refresh():
	match Slot:
		1:
			if !Inventory.Slot1.is_empty():
				ItemData = Inventory.Slot1
			else:
				ItemData = {}
		2:
			if !Inventory.Slot2.is_empty():
				ItemData = Inventory.Slot2
			else:
				ItemData = {}
		3:
			if !Inventory.Slot3.is_empty():
				ItemData = Inventory.Slot3
			else:
				ItemData = {}
		4:
			if !Inventory.Slot4.is_empty():
				ItemData = Inventory.Slot4
			else:
				ItemData = {}
		5:
			if !Inventory.Slot5.is_empty():
				ItemData = Inventory.Slot5
			else:
				ItemData = {}

	if !ItemData.is_empty():
		Icon.texture = ItemData["Icon"]
	else :
		Icon.texture = null

func Equip():
	Inventory.Equip(ItemData["Name"])

func _physics_process(delta: float) -> void:
	highlight.visible = Inventory.IsChangingSlot
	if Inventory.IsChangingSlot:
		if Inventory.ChangingData["Type"] == "Amour":
			highlight.modulate = Color.RED
		else :
			highlight.modulate = Color.GREEN

func _on_pressed() -> void:
	if Inventory.IsChangingSlot and Inventory.ChangingData["Type"] != "Amour":
		match Slot:
			1:
				if Inventory.EquippedItem == Inventory.Slot1:
					Inventory.UnEquip()
				Inventory.Slot1 = Inventory.ChangingData
			2:
				if Inventory.EquippedItem == Inventory.Slot2:
					Inventory.UnEquip()
				Inventory.Slot2 = Inventory.ChangingData
			3:
				if Inventory.EquippedItem == Inventory.Slot3:
					Inventory.UnEquip()
				Inventory.Slot3 = Inventory.ChangingData
			4:
				if Inventory.EquippedItem == Inventory.Slot4:
					Inventory.UnEquip()
				Inventory.Slot4 = Inventory.ChangingData
			5:
				if Inventory.EquippedItem == Inventory.Slot5:
					Inventory.UnEquip()
				Inventory.Slot5 = Inventory.ChangingData
		Inventory.IsChangingSlot = false
		character.RefreshAll()
