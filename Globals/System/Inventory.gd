extends Node

var Data := {}

var MaxSlots := 10
var SlotsUsed := 0

var IsEquipped := false
var EquippedItem := {}
var WeaponSlot := 0
var ChangedSlot := 1

var PrimaryWeapon := {}
var SecondaryWeapon := {}
var Shield := {}

var RefreshInv := false

var IsChangingWeapon := false
var ChangingData := {}

func _ready() -> void:
	AddWeapon(WeaponIndex.GetSword("SenKon"))
	AddWeapon(WeaponIndex.GetGun("Rifle"))

func UnEquip():
	IsEquipped = false
	WeaponSlot = 0
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
				ChangedSlot = 2
			2:
				ChangedSlot = 1
		SwitchWeapons(ChangedSlot)

func SwitchWeapons(Slot: int):
	match Slot:
		1:
			if !PrimaryWeapon.is_empty():
				if WeaponSlot == Slot:
					EquippedItem = {}
					WeaponSlot = 0
				else :
					WeaponSlot = Slot
					EquippedItem = PrimaryWeapon
					IsEquipped = true
			else :
				WeaponSlot = 0
				EquippedItem = {}
		2:
			if !SecondaryWeapon.is_empty():
				if WeaponSlot == Slot:
					EquippedItem = {}
					WeaponSlot = 0
				else :
					WeaponSlot = Slot
					EquippedItem = SecondaryWeapon
					IsEquipped = true
			else :
				WeaponSlot = 0
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

func AddItem(ItemName: String, Amount = 1):
	var Details := {}
	if Data.has(ItemName):
		Data[ItemName]["Amount"] += Amount
	else :
		Data.merge({ItemName: Details}, true)
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
