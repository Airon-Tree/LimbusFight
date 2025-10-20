class_name Player
extends CharacterBody2D

@onready var state_machine: StateMachine = $"State Machine"
@onready var sprite: AnimatedSprite2D = $Sprite

func _ready():
	state_machine.init()
	collision_layer = 2

func _process(delta):
	state_machine.process_frame(delta)

func _physics_process(delta):
	state_machine.process_physics(delta)
	

func _input(event):
	state_machine.process_input(event)




signal energy_changed(cur: float, maxv: float)

@export var max_energy := 100.0
@export var ult_cost := 100.0
var energy := 0.0

func has_energy(cost: float) -> bool:
	return energy >= cost

func spend_energy(cost: float) -> bool:
	if has_energy(cost):
		energy -= cost
		emit_signal("energy_changed", energy, max_energy)
		return true
	return false

func add_energy(x: float) -> void:
	energy = clamp(energy + x, 0.0, max_energy)
	emit_signal("energy_changed", energy, max_energy)
