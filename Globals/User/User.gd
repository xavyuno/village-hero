extends Node

var Health := 100

func DamageTaken(Amount: int):
	Health -= Amount
