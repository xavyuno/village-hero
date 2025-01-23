extends Area2D

var Speed = 300
var GunData := {}

func _ready() -> void:
	Speed = GunData["BulletSpeed"]

func _process(delta: float) -> void:
	position += transform.x * Speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Entity"):
		body.get_parent().Health -= GunData["Damage"]
