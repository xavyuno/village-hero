extends Node

var Data := {}

var MaxSlots := 10
var SlotsUsed := 0

var IsEquipped := false
var EquippedItem := {}
var ItemSlot := 0
var ChangedSlot := 1

var AmourEquipped := {}
var AmourChanged := false

var Slot1 := {}
var Slot2 := {}
var Slot3 := {}
var Slot4 := {}
var Slot5 := {}

var RefreshInv := false

var IsChangingSlot := false
var ChangingData := {}

func _ready() -> void:
	AddItem(WeaponIndex.GetSword("SenKon"))
	AddItem(WeaponIndex.GetGun("Rifle"))

func UnEquip():
	IsEquipped = false
	ItemSlot = 0
	EquippedItem = {}

func Equip(ItemName : String):
	if Data.has(ItemName):
		EquippedItem = Data[ItemName]

func _physics_process(delta: float) -> void:
	IsEquipped = !EquippedItem.is_empty()
	SlotsUsed = Data.size()

func AddAmmo(Amount = 0):
	var Guns := []
	var AmmoAmount : int = Amount
	if Amount == 0:
		AmmoAmount = randf_range(User.MinAmmo, User.MaxAmmo)
	if EquippedItem.is_empty():
		for i in Data:
			if Data[i]["Type"] == "Gun":
				Guns.append(i)
		if Guns.size() >= 1:
			if User.DivideAmmo:
				var DividedAmount := AmmoAmount / Guns.size()
				for i in Guns:
					Data[i]["MagSize"] += DividedAmount
			else :
				Data[Guns[0]]["MagSize"] += AmmoAmount
		else :
			return 0
	else :
		if EquippedItem["Type"] != "Gun":
			for i in Data:
				if Data[i]["Type"] == "Gun":
					Guns.append(i)
			if Guns.size() >= 1:
				if User.DivideAmmo:
					var DividedAmount := AmmoAmount / Guns.size()
					for i in Guns:
						Data[i]["MagSize"] += DividedAmount
				else :
					Data[Guns[0]]["MagSize"] += AmmoAmount
			else :
				return 0
		else :
			Data[EquippedItem["Name"]]["MagSize"] += AmmoAmount

func SwitchItems(Slot: int):
	match Slot:
		1:
			if !Slot1.is_empty():
				if ItemSlot == Slot:
					EquippedItem = {}
					ItemSlot = 0
				else :
					ItemSlot = Slot
					EquippedItem = Slot1
					IsEquipped = true
			else :
				ItemSlot = 0
				EquippedItem = {}
		2:
			if !Slot2.is_empty():
				if ItemSlot == Slot:
					EquippedItem = {}
					ItemSlot = 0
				else :
					ItemSlot = Slot
					EquippedItem = Slot2
					IsEquipped = true
			else :
				ItemSlot = 0
				EquippedItem = {}
		3:
			if !Slot3.is_empty():
				if ItemSlot == Slot:
					EquippedItem = {}
					ItemSlot = 0
				else :
					ItemSlot = Slot
					EquippedItem = Slot3
					IsEquipped = true
			else :
				ItemSlot = 0
				EquippedItem = {}
		4:
			if !Slot4.is_empty():
				if ItemSlot == Slot:
					EquippedItem = {}
					ItemSlot = 0
				else :
					ItemSlot = Slot
					EquippedItem = Slot4
					IsEquipped = true
			else :
				ItemSlot = 0
				EquippedItem = {}
		5:
			if !Slot5.is_empty():
				if ItemSlot == Slot:
					EquippedItem = {}
					ItemSlot = 0
				else :
					ItemSlot = Slot
					EquippedItem = Slot5
					IsEquipped = true
			else :
				ItemSlot = 0
				EquippedItem = {}

func AddItem(ItemData : Dictionary, Amount = 1):
	var done = false
	if ItemData["IsWeapon"] or ItemData["Type"] == "Amour":
		var UniqueIdentifier = ItemData["Name"] + str(randi() % 100000)
		ItemData["Name"] = UniqueIdentifier
	if Data.has(ItemData["Name"]):
		Data[ItemData["Name"]]["Amount"] += Amount
	else :
		Data.merge({ItemData["Name"]: ItemData}, true)
		if ItemData["Type"] == "Amour":
			done = true
		if Slot1.is_empty() and !done:
			Slot1 = ItemData
			done = true
		if Slot2.is_empty() and !done:
			Slot2 = ItemData
			done = true
		if Slot3.is_empty() and !done:
			Slot3 = ItemData
			done = true
		if Slot4.is_empty() and !done:
			Slot4 = ItemData
			done = true
		if Slot5.is_empty() and !done:
			Slot5 = ItemData
			done = true
	RefreshInv = true

func RemoveItem(ItemName: String, Amount = 1):
	var Details := {}
	if Data.has(ItemName):
		Details = Data[ItemName]
		Details["Amount"] -= Amount
		if Details["Amount"] <= 0:
			if !Details["IsWeapon"]:
				Data[ItemName]["Amount"] -= Amount
			if Slot1 == Details:
				Slot1 = {}
			if Slot2 == Details:
				Slot2 = {}
			if Slot3 == Details:
				Slot3 = {}
			if Slot4 == Details:
				Slot4 = {}
			if Slot5 == Details:
				Slot5 = {}
				
			Data.erase(ItemName)
		RefreshInv = true
		return Details["Amount"]
