extends Control

@export var player_path: NodePath

# Low-HP visuals (Inspector-tweakable)
@export_range(0.05, 0.9, 0.01) var low_health_threshold: float = 0.5
@export var warn_color_start: Color = Color(1.0, 0.824, 0.0)	
@export var warn_color_end: Color = Color(0.89, 0.149, 0.149)	
@export var pulse_enabled: bool = true
@export var pulse_scale: float = 1.06
@export var pulse_half_period: float = 0.35	# seconds

@onready var bar: ProgressBar = $HealthBar
@onready var game_over_label: Label = $GameOverLabel

var player: Node
var health: PlayerHealth
var is_game_over: bool = false
var pulse_tween: Tween = null

func _ready() -> void:
	# allow restart input while paused
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

	# find player
	if player_path != NodePath():
		player = get_node_or_null(player_path)
	if player == null:
		player = get_tree().get_first_node_in_group("Player")

	# find health and connect
	if player:
		health = player.get_node_or_null("Health") as PlayerHealth
		if health:
			if not health.health_changed.is_connected(_on_health_changed):
				health.health_changed.connect(_on_health_changed)
			if not health.died.is_connected(_on_player_died):
				health.died.connect(_on_player_died)
			_on_health_changed(health.max_health, health.health)

	# leave layout & styling to Inspector
	if is_instance_valid(game_over_label):
		game_over_label.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if not is_game_over:
		return
	if event.is_action_pressed("restart"):
		_do_restart()
	elif event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_R:
		_do_restart()

func _do_restart() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_health_changed(max_h: int, cur_h: int) -> void:
	if is_instance_valid(bar):
		bar.max_value = max_h
		bar.value = cur_h

	var ratio: float = 0.0
	if max_h > 0:
		ratio = float(cur_h) / float(max_h)

	if ratio < low_health_threshold:
		var t: float = clampf((low_health_threshold - ratio) / low_health_threshold, 0.0, 1.0)
		var warn: Color = warn_color_start.lerp(warn_color_end, t)
		if is_instance_valid(bar):
			bar.modulate = warn
		_start_pulse()
	else:
		if is_instance_valid(bar):
			bar.modulate = Color.WHITE
		_stop_pulse()

func _on_player_died() -> void:
	is_game_over = true
	if is_instance_valid(game_over_label):
		game_over_label.visible = true
	get_tree().paused = true
	if is_instance_valid(bar):
		bar.modulate = warn_color_end
	_start_pulse()

func _start_pulse() -> void:
	if not pulse_enabled or not is_instance_valid(bar):
		return
	if pulse_tween and pulse_tween.is_running():
		return
	pulse_tween = create_tween()
	pulse_tween.set_loops()
	pulse_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	pulse_tween.tween_property(bar, "scale", Vector2(pulse_scale, pulse_scale), pulse_half_period)
	pulse_tween.tween_property(bar, "scale", Vector2.ONE, pulse_half_period)

func _stop_pulse() -> void:
	if pulse_tween:
		pulse_tween.kill()
		pulse_tween = null
	if is_instance_valid(bar):
		bar.scale = Vector2.ONE
