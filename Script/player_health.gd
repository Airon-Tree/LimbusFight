extends Node
class_name PlayerHealth

signal health_changed(max_health: int, current_health: int)
signal died

@export var max_health: int = 100
var health: int

func _ready() -> void:
	health = max_health
	# print("[Health] _ready: max=", max_health, " current=", health)
	emit_signal("health_changed", max_health, health)

func apply_damage(amount: int) -> void:
	if amount <= 0:
		# print("[Health] apply_damage ignored (<=0): ", amount)
		return
		
	# var before := health
	health = max(health - amount, 0)
	# print("[Health] apply_damage: -", amount, " from=", before, " to=", health)
	emit_signal("health_changed", max_health, health)
	
	if health == 0:
		# print("[Health] died -> emitting 'died'")
		emit_signal("died")

func heal(amount: int) -> void:
	if amount <= 0:
		return
	health = clamp(health + amount, 0, max_health)
	emit_signal("health_changed", max_health, health)
