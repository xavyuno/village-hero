extends Resource
class_name Gun

@export var Name := ""
@export var Damage := 0
@export var Icon : Texture
@export var AttackSpeed := 1.0
@export var MagSize := 10
@export var MaxMag := 5
@export var BulletSpeed := 300
@export var ReloadSpeed := 1.0
@export var MaxPhases := 1
@export var Amount := 1
@export_enum("Common", "Rare", "Epic", "Legendary", "Mythic", "Limited", "Seaonal", "Battlepas") var Rarity : PackedStringArray

func GetData():
	return {
		"Name": Name,
		"Damage": Damage,
		"Icon": Icon,
		"AttackSpeed": AttackSpeed,
		"Type": "Gun",
		"MagSize": MagSize,
		"MaxMag": MaxMag,
		"BulletSpeed": BulletSpeed,
		"ReloadSpeed": ReloadSpeed,
		"MaxPhases": MaxPhases,
		"Amount": Amount,
		"IsWeapon": true,
		"Rarity": Rarity
	}
