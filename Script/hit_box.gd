class_name HitBox
extends Area2D


@export var damage: int = 10 
@export var knockback: Vector2 = Vector2(150, -120)

func find_attacker_in_parents() -> Player:
	var n: Node = self
	while n:
		if n.is_in_group("player"):
			return n as Player
		n = n.get_parent()
	return null

func is_hit_box() -> bool:
	return true
