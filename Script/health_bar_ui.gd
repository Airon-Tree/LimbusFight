extends Control

@export var player_path: NodePath
@onready var bar: ProgressBar = $HealthBar
@onready var game_over_label: Label = $GameOverLabel

var player: Node
var health: PlayerHealth

func _ready() -> void:
	# Find player and its Health component
	if player_path != NodePath():
		player = get_node_or_null(player_path)
	if player == null:
		player = get_tree().get_first_node_in_group("Player")
		

	if player:
		health = player.get_node_or_null("Health") as PlayerHealth
		if health == null:
			print("[HealthUI] ERROR: No child node 'Health' with PlayerHealth.gd on Player.")
		else:
			# print("[HealthUI] Found Health node. current/max: ", health.health, "/", health.max_health)
			# Connect signals with prints
			if not health.health_changed.is_connected(_update_bar):
				health.health_changed.connect(_update_bar)
				# print("[HealthUI] Connected health_changed")
			if not health.died.is_connected(_on_player_died):
				health.died.connect(_on_player_died)
				# print("[HealthUI] Connected died")
				
	if bar == null:
		# print("[HealthUI] WARNING: $HealthBar not found. Trying to find any ProgressBar under HealthUI...")
		bar = find_child("HealthBar", true, false) as ProgressBar
	if bar == null:
		# Try to find the first ProgressBar anywhere under this node
		var all := get_children()
		for c in all:
			if c is ProgressBar:
				bar = c
				break

	# Initialize bar + label
	if health and bar:
		_update_bar(health.max_health, health.health)
	# _center_game_over()
	game_over_label.visible = false
	# print("[HealthUI] Ready. Bar present? ", bar != null)

func _notification(what):
	if what == NOTIFICATION_RESIZED:
		_center_game_over()

func _center_game_over() -> void:
	var vp := get_viewport_rect().size
	game_over_label.position = (vp - game_over_label.size) * 0.5

func _update_bar(max_h: int, cur_h: int) -> void:

	if bar:
		bar.max_value = max_h
		bar.value = cur_h
	game_over_label.text = "HP: " + str(cur_h) + " / " + str(max_h)

func _on_player_died() -> void:
	game_over_label.visible = true
	get_tree().paused = true
