extends Button

@onready var AmountLabel: Label = $Amount
@onready var Icon: TextureRect = $Icon
@onready var progress: TextureProgressBar = $Progress
@onready var hold_down_timer: Timer = $HoldDownTimer

var ItemName := ""
var ItemData := {}

func _ready() -> void:
	ItemData = Inventory.Data[ItemName]
	Icon.texture = ItemData["Icon"]
	if !Inventory.Data[ItemName]["IsWeapon"]:
		AmountLabel.text = str(ItemData["Amount"])

func ChangeWeapon():
	Inventory.IsChangingWeapon = true
	Inventory.ChangingData = ItemData

func _on_pressed() -> void:
	ChangeWeapon()

func Equip():
	Inventory.Equip(ItemName)
