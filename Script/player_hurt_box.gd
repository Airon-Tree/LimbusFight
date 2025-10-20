class_name PlayerHurtBox
extends HurtBox

@onready var pain_state: PlayerPainState = $".."
@onready var state_machine: StateMachine = $"../.."

var hitting_area: Node2D
var already_hit:= false

#func on_area_entered(hit_box: HitBox) -> void:
	#print("hurt")
	#if hit_box == null: return
	#super(hit_box)
	#hitting_area = hit_box.owner
	#state_machine.change_state(pain_state)
	##add_game_juice()
#


func _on_area_entered(hit_box: HitBox) -> void:
	if hit_box == null: return
	super(hit_box)
	hit_box.owner.add_energy(10)
	state_machine.change_state(pain_state)
	#add_game_juice()
