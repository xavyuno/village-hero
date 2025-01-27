extends Resource
class_name Amour

@export var Name := ""
@export var Icon : Texture
@export var Amount := 1
@export var Scale := 1
@export var MaxProtection := 10
var Protection := 10
@export_enum("Common", "Rare", "Epic", "Legendary", "Mythic", "Limited", "Seaonal", "Battlepas") var Rarity := PackedStringArray(["Common", "limited"])

func GetData():
	return {
		"Name": Name,
		"Icon": Icon,
		"Scale": Scale,
		"Type": "Amour",
		"Amount": Amount,
		"IsWeapon": false,
		"Protection": MaxProtection,
		"MaxProtection": MaxProtection
	}
