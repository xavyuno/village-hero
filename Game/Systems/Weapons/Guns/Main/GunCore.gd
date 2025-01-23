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
		"MaxPhases": MaxPhases
	}
