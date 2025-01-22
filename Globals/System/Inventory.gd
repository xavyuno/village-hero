extends Node

var Data := {}

var IsEquipped := false
var EquippedItem := {}

var PrimaryWeapon := {}
var SecondaryWeapon := {}

func _ready() -> void:
	AddWeapon(SwordIndex.GetSword("SenKon"))

func AddWeapon(WeaponData: Dictionary, Amount = 1):
	if Data.has(WeaponData["Name"]):
		Data[WeaponData["Name"]]["Amount"] += Amount
	else :
		Data.merge({WeaponData["Name"]: WeaponData}, true)
		if PrimaryWeapon.is_empty():
			PrimaryWeapon = WeaponData
			return
		if SecondaryWeapon.is_empty():
			SecondaryWeapon = WeaponData
			return

func AddItem(ItemName: String, Amount: int, Details := {}):
	if Data.has(ItemName):
		Data[ItemName]["Amount"] += Amount
	else :
		Data.merge({ItemName: {"Amount": Amount, "Type": "Item"}}, true)

func RemoveItem(ItemName: String, Amount: int, Details := {}):
	if Data.has(ItemName):
		Data[ItemName]["Amount"] -= Amount
		if Data[ItemName]["Amount"] <= 0:
			Data.erase(ItemName)
