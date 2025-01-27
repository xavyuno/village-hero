extends StaticBody2D

var Speed = 1000
var GunData := {}

func _ready() -> void:
	Speed = GunData["BulletSpeed"]

func _process(delta: float) -> void:
	position += transform.x * Speed * delta
