extends Resource
class_name Item

@export var Name := ""
@export var Icon : Texture
@export var Amount := 1
@export var Scale := 0.4
@export_enum("Common", "Rare", "Epic", "Legendary", "Mythic", "Limited", "Seaonal", "Battlepas") var Rarity := PackedStringArray(["Common", "limited"])

@export_category("Ammo")
@export var SetAmmo := 0

func GetData():
	return {
		"Name": Name,
		"Icon": Icon,
		"Scale": Scale,
		"Type": "Item",
		"Amount": Amount,
		"IsWeapon": false,
		"SetAmmo": SetAmmo
	}
