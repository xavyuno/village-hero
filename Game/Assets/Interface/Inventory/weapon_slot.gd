extends Button

@onready var Icon: TextureRect = $Icon
@onready var highlight: TextureRect = $Highlight
@onready var character: Control = get_parent().get_parent()

@export_enum("Primary", "Secondary", "Shield") var SlotType : String

var ItemData : = {}

func Refresh():
	match SlotType:
		"Primary":
			if !Inventory.PrimaryWeapon.is_empty():
				ItemData = Inventory.PrimaryWeapon
			else:
				ItemData = {}
		"Secondary":
			if !Inventory.SecondaryWeapon.is_empty():
				ItemData = Inventory.SecondaryWeapon
			else :
				ItemData = {}
		"Shield":
			if !Inventory.Shield.is_empty():
				ItemData = Inventory.Shield
			else :
				ItemData = {}
	if !ItemData.is_empty():
		Icon.texture = ItemData["Icon"]
	else :
		Icon.texture = null

func Equip():
	Inventory.Equip(ItemData["Name"])

func _physics_process(delta: float) -> void:
	highlight.visible = Inventory.IsChangingWeapon

func _on_pressed() -> void:
	if Inventory.IsChangingWeapon:
		match SlotType:
			"Primary":
				if Inventory.EquippedItem == Inventory.PrimaryWeapon:
					Inventory.UnEquip()
				if Inventory.ChangingData["Type"] == "Gun" or Inventory.ChangingData["Type"] == "Sword":
					Inventory.PrimaryWeapon = Inventory.ChangingData
			"Secondary":
				if Inventory.EquippedItem == Inventory.SecondaryWeapon:
					Inventory.UnEquip()
				if Inventory.ChangingData["Type"] == "Gun":
					Inventory.SecondaryWeapon = Inventory.ChangingData
			"Shield":
				if Inventory.ChangingData["Type"] == "Shield":
					Inventory.Shield = Inventory.ChangingData
		Inventory.IsChangingWeapon = false
		character.RefreshAll()
