extends Resource
class_name Gun

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
		"Type": "Gun"
	}
