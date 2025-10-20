class_name HurtBox
extends Area2D

@export var player_path: NodePath
var hitting_area_h: Area2D = null

@onready var camera: Camera = get_tree().get_first_node_in_group("Camera")
@onready var player: Node = null
#@onready var player: Node = get_tree().get_first_node_in_group("Player")

func _ready():
	
	if player_path != NodePath():
		player = get_node_or_null(player_path)
	if player == null:
		player = _find_player_root(self)
	
	collision_layer = 0
	collision_mask = 2
	area_entered.connect(_on_area_entered_bridge)
	#self.area_entered.connect(on_area_entered)

func _find_player_root(from: Node) -> Node:
	var p := from
	while p and p.get_node_or_null("Health") == null:
		p = p.get_parent()
	return p
	
func _find_attacker_root(from: Node) -> Node:
	var p := from
	while p and p.get_node_or_null("Health") == null:
		p = p.get_parent()
	return p
	
func on_area_entered(hit_box: HitBox) -> void:
	if hit_box == null:
		return
		
	# ignore self-hits
	var attacker := _find_attacker_root(hit_box)
	if attacker == player:
		return
	
	hitting_area_h = hit_box
	
	# apply damage through player's Health node
	if player:
		var health_node := player.get_node_or_null("Health")
		if health_node and health_node.has_method("apply_damage"):
			health_node.apply_damage(hit_box.damage)

	#var attacker := _find_attacker_root(hit_box)
	#if player:
		player.set_meta("last_attacker", attacker)
		player.set_meta("last_hit_box", hit_box)
		player.set_meta("got_hit", true)
		
	add_game_juice()

func _on_area_entered_bridge(area: Area2D) -> void:
	if area is HitBox:
		on_area_entered(area as HitBox)


func add_game_juice() -> void:
	engine_slow()
	camera.set_zoom_str(1.15)
	camera.set_shake_str(Vector2(8, 8))
	
func engine_slow() -> void:
	Engine.time_scale = 0.9
	await get_tree().create_timer(0.9 * 0.5).timeout
	Engine.time_scale = 1
