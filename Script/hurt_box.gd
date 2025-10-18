class_name HurtBox
extends Area2D

@onready var camera: Camera = get_tree().get_first_node_in_group("Camera")

func _ready():
	collision_layer = 0
	collision_mask = 2
	self.area_entered.connect(on_area_entered)
	
func on_area_entered(hit_box: HitBox) -> void:
	if hit_box == null: return
	add_game_juice()
	print("Damage D")

func add_game_juice() -> void:
	engine_slow()
	camera.set_zoom_str(1.15)
	camera.set_shake_str(Vector2(8, 8))
	
func engine_slow() -> void:
	Engine.time_scale = 0.9
	await get_tree().create_timer(0.9 * 0.5).timeout
	Engine.time_scale = 1
