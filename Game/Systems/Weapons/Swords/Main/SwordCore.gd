extends Resource
class_name Sword

@export var Name := ""
@export var Damage := 0
@export var Icon : Texture
@export var AttackSpeed := 1.0

func GetData():
	return {
		"Name": Name,
		"Damage": Damage,
		"Icon": Icon,
		"AttackSpeed": AttackSpeed,
		"Type": "Sword"
	}
