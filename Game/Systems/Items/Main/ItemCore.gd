extends Resource
class_name Item

@export var Name := ""
@export var Icon : Texture
@export var Amount := 1
@export_enum("Common", "Rare", "Epic", "Legendary", "Mythic", "Limited", "Seaonal", "Battlepas") var Rarity := PackedStringArray(["Common", "limited"])

func GetData():
	return {
		"Name": Name,
		"Icon": Icon,
		"Type": "Gun",
		"Amount": Amount,
		"IsWeapon": false,
		"IsShield": false
	}
