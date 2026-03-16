extends Node

var Character : Texture = load("res://Game/Assets/Icons/PlayerSkins/Default/Hitman.png")

var Health := 100
var MaxHealth := 100
var Protection := 0
var RegenSpeed := 5
var RegenAmount := 10

var PlayerPosition := Vector2.ZERO

var DivideAmmo := true
var MinAmmo := 25
var MaxAmmo := 60
var UserDropPercentage := 0.3

var Level := 1
var ReqExp := 100
var Exp := 0

var Difficulty := 3

func _ready() -> void:
	Health = 10000

func _physics_process(delta: float) -> void:
	LevelUp()
	Health = clamp(Health, 0, MaxHealth)
	if !Inventory.AmourEquipped.is_empty():
		Protection = clamp(Protection, 0, Inventory.AmourEquipped["MaxProtection"])
	else:
		Protection = 0
	if Health <= 0:
		Health = MaxHealth
		get_tree().change_scene_to_file("res://Game/Assets/Interface/DeathScreen/death_screen.tscn")

func LevelUp():
	if Exp >= ReqExp:
		Exp -= ReqExp
		ReqExp *= 1.5
		Level += 1

func DamageTaken(Amount: int):
	for i in Amount:
		if Protection >= 1:
			Protection -= 1
			Amount -= 1
	Health -= Amount
