class_name HitBox
extends Area2D


@export var damage: int = 10 
@export var knockback: Vector2 = Vector2(150, -120)


func is_hit_box() -> bool:
	return true
