extends Control

@onready var ammo: Label = $Ammo

func _physics_process(delta: float) -> void:
	if !Inventory.EquippedItem.is_empty():
		if Inventory.EquippedItem["Type"] == "Gun":
			visible = true
			ammo.text = str(Inventory.EquippedItem["CurrentMag"]) + " / " + str(Inventory.EquippedItem["MagSize"])
		else :
			visible = false
	else :
		visible = false
