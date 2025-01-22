extends Node

var Data := {}

func AddItem(ItemName: String, Amount: int, Details := {}):
	if Data.has(ItemName):
		Data[ItemName] += Amount
	else :
		Data.merge({ItemName: Amount}, true)

func RemoveItem(ItemName: String, Amount: int, Details := {}):
	if Data.has(ItemName):
		Data[ItemName] -= Amount
		if Data[ItemName] <= 0:
			Data.erase(ItemName)
