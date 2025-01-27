extends HBoxContainer

var Refreshing := false

func _ready() -> void:
	RefreshAll()

func _physics_process(delta: float) -> void:
	if !Inventory.RefreshInv:
		Refreshing = false
	if Inventory.RefreshInv and !Refreshing:
		Refreshing = true
		RefreshAll()

func RefreshAll():
	for i in get_children():
		i.Refresh()
