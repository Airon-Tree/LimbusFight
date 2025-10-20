# EnergyUI.gd
extends Control

@export var player_path: NodePath
@export var show_percent: bool = true
@export var ult_threshold_ratio: float = 1.0  # 满槽=1.0，或设 0.5 表示半槽可放

@onready var bar: Range = $EnergyBar         # ProgressBar 或 TextureProgressBar 都继承 Range
#@onready var label: Label = $EnergyLabel     # 可选
#@onready var ready_fx: Node = $UltReadyFX    # 可选，用来做光效/提示

func _ready() -> void:
	var player = get_node(player_path)
	# 初始化范围
	bar.min_value = 0.0
	bar.max_value = player.max_energy
	bar.value = player.energy

	# 监听玩家能量变化
	player.energy_changed.connect(_on_energy_changed)

	# 初次刷新
	_refresh_ui(player.energy, player.max_energy)

func _on_energy_changed(cur: float, maxv: float) -> void:
	bar.max_value = maxv
	bar.value = cur
	_refresh_ui(cur, maxv)

func _refresh_ui(cur: float, maxv: float) -> void:
	# 文本
	#if is_instance_valid(label) and show_percent:
		#var pct := int(round(100.0 * cur / maxv))
		#label.text = "%d%%" % pct

	# 满槽（或到达阈值）提示
	var ready := (cur >= maxv * ult_threshold_ratio - 0.001)
	#if is_instance_valid(ready_fx):
		#ready_fx.visible = ready

	# 颜色/样式切换（ProgressBar 用 Theme；TextureProgressBar 用不同纹理）
	_set_bar_style(ready)

func _set_bar_style(ready: bool) -> void:
	# ProgressBar：改 Theme 样式（示例）
	if bar is ProgressBar:
		var pb := bar as ProgressBar
		var sb_fg := StyleBoxFlat.new()
		var sb_bg := StyleBoxFlat.new()
		sb_bg.bg_color = Color(0.12, 0.12, 0.12, 0.8)
		sb_bg.corner_radius_top_left = 16
		sb_bg.corner_radius_top_right = 8
		sb_bg.corner_radius_bottom_left = 8
		sb_bg.corner_radius_bottom_right = 8

		sb_fg.bg_color = Color(1.0, 0.85, 0.1) if ready else Color(0.25, 0.8, 1.0)
		sb_fg.corner_radius_top_left = 8
		sb_fg.corner_radius_top_right = 8
		sb_fg.corner_radius_bottom_left = 8
		sb_fg.corner_radius_bottom_right = 8

		pb.add_theme_stylebox_override("background", sb_bg)
		pb.add_theme_stylebox_override("fill", sb_fg)
