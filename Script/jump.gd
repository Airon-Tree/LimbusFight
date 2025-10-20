class_name PlayerJumpState
extends PlayerState

const AIR_SPEED: float = 80
const JUMP_FORCE: float = 300


func enter() -> void:
	super()
	player.velocity.y = -JUMP_FORCE
	player.sprite.play(jump_anim)
	
	
func exit(new_state: State = null) -> void:
	super(new_state)

func process_input(event: InputEvent) -> State:
	if event.is_action_pressed(jump_attack_key): 
		return jump_attack_state
	if event.is_action_pressed(punch_key): 
		if player.has_energy(player.ult_cost):
			return dive_kick_state
	super(event)
	if event.is_action_pressed(movement_key): 
		determine_sprite_flipped(event.as_text())


	return null

func process_physics(delta: float) -> State:
	# print(player.velocity)
	do_move(get_move_dir())
	var next := super(delta)
	if(player.is_on_floor()):
		if get_move_dir() != 0.0:
			return walk_state
		else: return idle_state
	player.velocity.y += gravity * delta
	return next



func get_move_dir() -> float:
	return Input.get_axis(left_key, right_key)

func do_move(move_dir: float) -> void:
	player.velocity.x = move_dir * AIR_SPEED
