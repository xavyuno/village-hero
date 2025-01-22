extends Node

func GetSword(Name: String):
	return load("res://Game/Systems/Weapons/Swords/" + Name + ".tres").GetData()

func GetGun(Name: String):
	return load("res://Game/Systems/Weapons/Guns/" + Name + ".tres").GetData()
