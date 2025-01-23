extends Button

@onready var AmountLabel: Label = $Amount
@onready var Icon: TextureRect = $Icon

var ItemName := ""
var ItemData := {}

func _ready() -> void:
	ItemData = Inventory.Data[ItemName]
	Icon.texture = ItemData["Icon"]
	if !Inventory.Data[ItemName]["IsWeapon"]:
		AmountLabel.text = str(ItemData["Amount"])

func _on_pressed() -> void:
	Inventory.Equip(ItemName)
