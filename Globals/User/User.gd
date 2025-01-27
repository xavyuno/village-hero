extends Node

var Character : Texture = load("res://Game/Assets/Icons/PlayerSkins/Default/Hitman.png")

var Health := 10
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
var ReqExp := 10
var Exp := 0

func _physics_process(delta: float) -> void:
	LevelUp()

func LevelUp():
	if Exp >= ReqExp:
		ReqExp *= 1.5
		Exp -= ReqExp
		Level += 1

func DamageTaken(Amount: int):
	Health -= Amount - Protection
