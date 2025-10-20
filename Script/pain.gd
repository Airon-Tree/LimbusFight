class_name PlayerPainState
extends PlayerState

@onready var hurt_box: HurtBox = $HurtBox

@export var knockback_x: float = 220.0
@export var knockback_y: float = -120.0
var _applied_kb: bool = false

var has_pained: bool

func enter() -> void:
	has_pained = false
	_applied_kb = false
	player.sprite.play(pain_anim)
	player.sprite.animation_finished
	has_pained = true
	player.add_energy(5)

func exit(new_state: State = null) -> void:
	super(new_state)
	player.velocity.x = 0

func process_input(event: InputEvent) -> State:
	super(event)
	if has_pained and event.is_action_pressed(movement_key):
		determine_sprite_flipped(event.as_text())
		return walk_state
	elif has_pained and event.is_action_pressed(jump_key):
		return jump_state
	return null

func process_frame(delta: float) -> State:
	if has_pained:
		return idle_state
	return super(delta)
	
func process_physics(delta: float) -> State:
	if not _applied_kb:
		push_back()
		_applied_kb = true
	return super(delta)
	
func push_back() -> void:
	#var push_dir: Vector2 = hurt_box.hitting_area.global_position - player.global_position
	#player.velocity.x += push_dir.x * 0.1
	var dir_x: float = -1.0

	var attacker: Node2D = null
	if player.has_meta("last_attacker"):
		attacker = player.get_meta("last_attacker")

	if attacker and attacker is Node2D:
		var a := attacker as Node2D
		dir_x = (-1.0 if player.global_position.x < a.global_position.x else 1.0)  # away from attacker
	elif hurt_box and hurt_box.hitting_area and hurt_box.hitting_area is Node2D:
		var hb := hurt_box.hitting_area as Node2D
		dir_x = (-1.0 if player.global_position.x < hb.global_position.x else 1.0) # away from hitbox
	else:
		# fallback: away from facing (flip means looking left)
		dir_x = (1.0 if sprite_flipped else -1.0)

	# apply once-per-entry (assign, don't accumulate)
	player.velocity.x = dir_x * absf(knockback_x)
	if player.is_on_floor():
		player.velocity.y = knockback_y
	
func add_game_juice() -> void:
	camera.set_zoom_str(1.015)
	camera.set_shake_str(Vector2(4, 4))
