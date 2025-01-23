extends Node

var Health := 100

var PlayerPosition := Vector2.ZERO

func DamageTaken(Amount: int):
	Health -= Amount
