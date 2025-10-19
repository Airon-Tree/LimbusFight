class_name PlayerJumpAttackState
extends PlayerState

const AIR_SPEED: float = 80
const JUMP_FORCE: float = 80

var _t: float = 0.0
var has_attacked: bool

@onready var hitbox: Area2D = $HitBox

func enter() -> void:
	has_attacked = false
	_t = 0.0
	
	if sprite_flipped: hitbox.scale.x = -1
	else: hitbox.scale.x = 1
	
	player.animation.play(jump_attack_anim)
	_set_hitbox_enabled(false)
	player.animation.animation_finished.connect(func(_anim): has_attacked = true)

func exit(new_state: State = null) -> void:
	super(new_state)
	player.velocity.x =0.0
	_set_hitbox_enabled(false)


func process_input(event: InputEvent) -> State:
	super(event)
	if has_attacked and event.is_action_pressed(movement_key):
		determine_sprite_flipped(event.as_text())
	return null

func process_physics(delta: float) -> State:
	
	if has_attacked:
		return fall_state

	do_move(get_move_dir())
	if(player.is_on_floor()):
		_set_hitbox_enabled(false)
		if get_move_dir() != 0.0:
			return walk_state
		else: return idle_state
	player.velocity.y += gravity * delta * 0.9
	player.move_and_slide()

	return null

func get_move_dir() -> float:
	return Input.get_axis(left_key, right_key)

func do_move(move_dir: float) -> void:
	player.velocity.x = move_dir * AIR_SPEED

func _on_anim_finished(_anim: StringName) -> void:
	has_attacked = true
	
func _set_hitbox_enabled(on: bool) -> void:
	if is_instance_valid(hitbox):
		hitbox.monitoring = on
		hitbox.monitorable = on
		for c in hitbox.get_children():
			if c is CollisionShape2D:
				c.disabled = (not on)

func add_game_juice() -> void:
	camera.set_zoom_str(1.015)
	camera.set_shake_str(Vector2(4, 4))
