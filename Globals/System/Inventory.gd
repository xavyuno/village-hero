extends Node

var Data := {}

var IsEquipped := false
var EquippedItem := {}
var WeaponSlot := 1

var PrimaryWeapon := {}
var SecondaryWeapon := {}

func _ready() -> void:
	AddWeapon(WeaponIndex.GetSword("SenKon"))
	AddWeapon(WeaponIndex.GetGun("Rifle"))

func _physics_process(delta: float) -> void:
	IsEquipped = !EquippedItem.is_empty()
	if Input.is_action_just_pressed("SwitchWeapon"):
		match WeaponSlot:
			1:
				WeaponSlot = 2
			2:
				WeaponSlot = 1
		SwitchWeapons(WeaponSlot)

func SwitchWeapons(Slot: int):
	match Slot:
		1:
			if !PrimaryWeapon.is_empty():
				if EquippedItem == PrimaryWeapon:
					EquippedItem = {}
				else :
					EquippedItem = PrimaryWeapon
					IsEquipped = true
			else :
				EquippedItem = {}
		2:
			if !SecondaryWeapon.is_empty():
				if EquippedItem == SecondaryWeapon:
					EquippedItem = {}
				else :
					EquippedItem = SecondaryWeapon
					IsEquipped = true
			else :
				EquippedItem = {}


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
