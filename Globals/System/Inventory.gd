extends Node

var Data := {}

var MaxSlots := 10
var SlotsUsed := 0

var IsEquipped := false
var EquippedItem := {}
var WeaponSlot := 1

var PrimaryWeapon := {}
var SecondaryWeapon := {}

var RefreshInv := false

func _ready() -> void:
	AddWeapon(WeaponIndex.GetSword("SenKon"))
	AddWeapon(WeaponIndex.GetGun("Rifle"))

func UnEquip():
	IsEquipped = false
	EquippedItem = {}

func Equip(ItemName : String):
	if Data.has(ItemName):
		EquippedItem = Data[ItemName]

func _physics_process(delta: float) -> void:
	IsEquipped = !EquippedItem.is_empty()
	SlotsUsed = Data.size()
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
	var UniqueIdentifier = WeaponData["Name"] + str(randi() % 100000)
	WeaponData["Name"] = UniqueIdentifier
	Data.merge({UniqueIdentifier: WeaponData}, true)
	RefreshInv = true
	if PrimaryWeapon.is_empty():
		PrimaryWeapon = WeaponData
		return
	if SecondaryWeapon.is_empty():
		SecondaryWeapon = WeaponData
		return

func AddItem(ItemName: String, Amount = 1, Details := {}):
	if Data.has(ItemName):
		Data[ItemName]["Amount"] += Amount
	else :
		Data.merge({ItemName: {"Amount": Amount, "Type": "Item", "IsWeapon": false}}, true)
	RefreshInv = true

func RemoveWeapon(ItemName: String):
	var Details := {}
	if Data.has(ItemName):
		Details = Data[ItemName]
		Data.erase(ItemName)
		if PrimaryWeapon == Details:
			PrimaryWeapon = {}
		if SecondaryWeapon == Details:
			SecondaryWeapon = {}
	RefreshInv = true

func RemoveItem(ItemName: String, Amount = 1):
	var Details := {}
	if Data.has(ItemName):
		Details = Data[ItemName]
		Data[ItemName]["Amount"] -= Amount
		if Data[ItemName]["Amount"] <= 0:
			Data.erase(ItemName)
			if Details["IsWeapon"]:
				if PrimaryWeapon == Details:
					PrimaryWeapon = {}
				if SecondaryWeapon == Details:
					SecondaryWeapon = {}
	RefreshInv = true
