extends Control

func _ready() -> void:
	RefreshAll()

func RefreshAll():
	for i in $WeaponHolder.get_children():
		i.Refresh()
