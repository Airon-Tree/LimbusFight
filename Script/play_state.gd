class_name PlayerState
extends State

#@onready var player: Player = get_tree().get_first_node_in_group("Player")
@onready var player = get_parent().get_parent()
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
@export var movement_key: String = "Movement"
@export var left_key: String = "Left"
@export var right_key: String = "Right"
@export var jump_key: String = "Jump"
@export var punch_key: String = "Punch"
@export var kick_key: String = "Kick"
@export var jump_attack_key: String = "Kick"

#For play2
#var movement_key: String = "Movement_p2"
#var left_key: String = "Left_p2"
#var right_key: String = "Right_p2"
#var jump_key: String = "Jump_p2"
#var punch_key: String = "Punch_p2"
#var kick_key: String = "Kick_p2"
#var jump_attack_key: String = "Kick_p2"

#Input Action
var left_actions: Array = InputMap.action_get_events(left_key).map(func(action: InputEvent) -> String: 
	return action.as_text().get_slice(" (",0))
var right_actions: Array = InputMap.action_get_events(right_key).map(func(action: InputEvent) -> String: 
	return action.as_text().get_slice(" (",0))

#Util Fn
func determine_sprite_flipped(event_text: String) -> void:
	#print(event_text)
	#print(left_actions)
	#print(right_actions)
	#print(left_key)
	#print(right_key)
	#if event_text == left_key or event_text.find(left_key) != -1:
		#sprite_flipped = true
	#elif event_text == right_key or event_text.find(right_key) != -1:
		#sprite_flipped = false
	#if left_actions.find(event_text) != -1: 
		#sprite_flipped = true
	#elif right_actions.find(event_text) != -1: 
		#sprite_flipped = false
	if Input.is_action_pressed(left_key):
		sprite_flipped = true
	elif Input.is_action_pressed(right_key):
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
