extends Button

@onready var highlight: TextureRect = $Highlight
@onready var Icon: TextureRect = $Icon

func _ready() -> void:
	Refresh()

func _physics_process(delta: float) -> void:
	highlight.visible = Inventory.IsChangingSlot

func Refresh():
	if !Inventory.AmourEquipped.is_empty():
		Icon.texture = Inventory.AmourEquipped["Icon"]
	else :
		Icon.texture = null

func _on_pressed() -> void:
	if Inventory.IsChangingSlot:
		if Inventory.ChangingData["Type"] == "Amour":
			Inventory.AmourEquipped = Inventory.ChangingData
			Inventory.IsChangingSlot = false
			Inventory.AmourChanged = true
			Refresh()
	else :
		Inventory.AmourEquipped = {}
		Refresh()
		Inventory.AmourChanged = true
