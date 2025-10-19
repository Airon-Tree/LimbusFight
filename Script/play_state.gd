class_name PlayerState
extends State

@onready var player: Player = get_tree().get_first_node_in_group("Player")
@onready var camera: Camera = get_tree().get_first_node_in_group("Camera")

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity", -9.8)

var idle_anim: String = "Idle"
var walk_anim: String = "Walk"
var jump_anim: String = "Jump"
var fall_anim: String = "Fall"
var punch_anim: String = "Punch"
var kick_anim: String = "Kick"
var pain_anim: String = "Pain"
var jump_attack_anim: String = "Jump_Attack"

#States
@export_group("States")
@export var idle_state: PlayerState
@export var walk_state: PlayerState
@export var jump_state: PlayerState
@export var fall_state: PlayerState
@export var punch_state: PlayerState
@export var kick_state: PlayerState
@export var pain_state: PlayerState
@export var jump_attack_state: PlayerState

#State Variables
var sprite_flipped: bool = false

#Input Key
var movement_key: String = "Movement"
var left_key: String = "Left"
var right_key: String = "Right"
var jump_key: String = "Jump"
var punch_key: String = "Punch"
var kick_key: String = "Kick"
var jump_attack_key: String = "Kick"

#Input Action
var left_actions: Array = InputMap.action_get_events(left_key).map(func(action: InputEvent) -> String: 
	return action.as_text().get_slice(" (",0))
var right_actions: Array = InputMap.action_get_events(right_key).map(func(action: InputEvent) -> String: 
	return action.as_text().get_slice(" (",0))

#Util Fn
func determine_sprite_flipped(event_text: String) -> void:
	#print(event_text)
	if left_actions.find(event_text) != -1: 
		sprite_flipped = true
	elif right_actions.find(event_text) != -1: 
		sprite_flipped = false
	player.sprite.flip_h = sprite_flipped

#Base Fn
func process_physics(delta: float) -> State:
	player.velocity.y += gravity * delta
	player.move_and_slide()
	if(player.velocity.y > 0.0 and not player.is_on_floor()):
		return fall_state
	return null
	
func exit(new_state: State = null) -> void:
	super()
	new_state.sprite_flipped = sprite_flipped
